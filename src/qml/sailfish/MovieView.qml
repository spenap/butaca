/**************************************************************************
 *   Butaca
 *   Copyright (C) 2011 - 2012 Simon Pena <spena@igalia.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 **************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import 'butacautils.js' as Util
import 'moviedbwrapper.js' as TMDB
import 'constants.js' as UIConstants
import 'storage.js' as Storage

Page {
    id: movieView

    allowedOrientations: Orientation.Portrait

    property variant movie: ''
    property alias tmdbId: parsedMovie.tmdbId
    property alias imdbId: parsedMovie.imdbId
    property bool loading: false
    property bool loadingExtended: false
    property bool inWatchlist: tmdbId ? Storage.inWatchlist({ 'id': tmdbId }) : false

    QtObject {
        id: parsedMovie

        // Part of the lightweight movie object
        property string tmdbId: ''
        property string name: ''
        property string poster: 'qrc:/resources/movie-placeholder.svg'
        property string url: '' // implicit: base url + movie id
        // also available: backdrop, adult, popularity

        // Part of the full movie object
        property string originalName: ''
        property string released: ''
        property double rating: 0
        property int votes: 0
        property string imdbId: ''
        property string overview: ''
        property string tagline: ''
        property string trailer: ''
        property string revenue: ''
        property string budget: ''
        property int runtime: 0
        property string certification: '-'
        property string homepage: ''
        // also available: belongs_to_collection, spoken_languages, status

        // parses TMDBObject
        function updateWithLightWeightMovie(movie) {
            tmdbId = movie.id
            name = movie.name
            url = 'http://www.themoviedb.org/movie/' + tmdbId
            if (movie.img)
                poster = TMDB.image(TMDB.IMAGE_POSTER, 2,
                                    movie.img, { app_locale: appLocale })
        }

        // parses JSON response
        function updateWithFullWeightMovie(movie) {
            name = movie.title
            url = 'http://www.themoviedb.org/movie/' + tmdbId
            if (movie.poster_path)
                poster = TMDB.image(TMDB.IMAGE_POSTER, 2,
                                    movie.poster_path, { app_locale: appLocale })
            if (movie.original_title)
                originalName = movie.original_title
            if (movie.release_date)
                released = movie.release_date
            if (movie.vote_average)
                rating = movie.vote_average
            if (movie.vote_count)
                votes = movie.vote_count
            if (movie.imdb_id)
                imdbId = movie.imdb_id
            if (movie.overview)
                overview = movie.overview
            if (movie.trailers.youtube[0]) // can't deal with quicktime
                trailer = 'http://www.youtube.com/watch?v=' + movie.trailers.youtube[0].source
            if (movie.homepage)
                homepage = movie.homepage
            if (movie.revenue)
                revenue = movie.revenue
            if (movie.budget)
                budget = movie.budget
            if (movie.tagline)
                tagline = movie.tagline
            if (movie.runtime)
                runtime = movie.runtime

            Util.populateModelFromArray(movie.alternative_titles.titles, altTitlesModel)
            Util.populateModelFromArray(movie.genres, genresModel)
            Util.populateModelFromArray(movie.production_companies, studiosModel)
            Util.populateModelFromArray(movie.images.posters, postersModel)
            Util.populateModelFromArray(movie.images.backdrops, backdropsModel)

            for (var i = 0; i < movie.releases['countries'].length; i++)
                if (movie.releases.countries[i].iso_3166_1 == appLocale.toUpperCase())
                    certification = movie.releases.countries[i].certification

            var cast = new Array()
            Util.populateArrayFromArray(movie.credits.cast, cast, Util.TMDbCredit)
            cast.sort(sortByCastId)
            Util.populateModelFromArray(cast, castModel)

            var crew = new Array()
            Util.populateArrayFromArray(movie.credits.crew, crew, Util.TMDbCredit)
            crew.sort(sortByDepartmentAndCastId)
            Util.populateModelFromArray(crew, crewModel)

            Util.populateModelFromArray(crew, creditsModel)
            Util.populateModelFromArray(cast, creditsModel)
        }
    }

    function sortByCastId(oneItem, theOther) {
        return oneItem.cast_id - theOther.cast_id
    }

    function sortByDepartmentAndCastId(oneItem, theOther) {
        var result = oneItem.department.localeCompare(theOther.department)
        if (result !== 0) {
            // pull directors and writers to the top
            if (oneItem.department === 'Directing')
                return -1
            else if (theOther.department === 'Directing')
                return 1
            else if (oneItem.department === 'Writing')
                return -1
            else if (theOther.department === 'Writing')
                return 1
        } else {
            result = sortByCastId(oneItem, theOther)
        }
        return result
    }

    Component.onCompleted: {
        if (movie)
            parsedMovie.updateWithLightWeightMovie(movie)

        if (tmdbId)
            fetchExtendedContent(TMDB.movie_info(tmdbId,
                                                 'alternative_titles,credits,images,trailers,releases',
                                                 { app_locale: appLocale }),
                                 Util.FETCH_RESPONSE_TMDB_MOVIE)
    }

    // Several ListModels are used.
    // * Genres stores the genres / categories which best describe the movie. When
    //   browsing by genre, the movie will have at least the genre we were navigating
    // * Studios stores the company which produced the film
    // * Posters stores all the poster images for this particular film. By using the
    //   resolutions in the API configuration, all quality levels can be accessed
    // * Backdrops stores all the backdrop images for this particular film. By using the
    //   resolutions in the API configuration, all quality levels can be accessed
    // * Cast and crew are separated from each other, so we can be more specific
    //   in the movie preview
    // * AltTitles stores the alternative titles of the film

    ListModel {
        id: genresModel
    }

    ListModel {
        id: studiosModel
    }

    ListModel {
        id: postersModel
    }

    ListModel {
        id: backdropsModel
    }

    ListModel {
        id: creditsModel
    }

    ListModel {
        id: castModel
    }

    ListModel {
        id: crewModel
    }

    ListModel {
        id: altTitlesModel
    }

    Component {
        id: galleryView

        MediaGalleryView {
            gridSize: 0
            saveSize: 100
        }
    }

    Component { id: castView; CastView { } }

    SilicaFlickable {
        id: movieFlickableWrapper
        anchors.fill: parent
        contentHeight: movieContent.height
        visible: !loading

        PullDownMenu {
            MenuItem {
                enabled: !loading
                text: !inWatchlist ?
                          //: This adds the movie to the watch list
                          qsTr('Add to watchlist') :
                          //: This removes the movie from the watch list
                          qsTr('Remove from watchlist')
                onClicked: {
                    if (inWatchlist) {
                        Storage.removeFromWatchlist({
                                                        'id': tmdbId
                                                    })
                    } else {
                        Storage.addToWatchlist({
                                                   'id': tmdbId,
                                                   'name': parsedMovie.name,
                                                   'year': Util.getYearFromDate(parsedMovie.released),
                                                   'iconSource': parsedMovie.poster,
                                                   'rating': parsedMovie.rating,
                                                   'votes': parsedMovie.votes
                                               })
                    }
                }
            }
            MenuItem {
                //: This opens a website displaying the movie homepage
                text: qsTr('Open homepage')
                visible: parsedMovie.homepage
                onClicked: Qt.openUrlExternally(parsedMovie.homepage)
            }
            MenuItem {
                //: This visits the Internet Movie Database page of this content (movie or person)
                text: qsTr('View in IMDb')
                onClicked: Qt.openUrlExternally(Util.IMDB_BASE_URL + 'title/' + parsedMovie.imdbId)
            }
            MenuItem {
                //: This visits the The Movie Database page of this content (movie or person)
                text: qsTr('View in TMDb')
                onClicked: Qt.openUrlExternally(parsedMovie.url)
            }

            MenuItem {
                property bool isFavorite: welcomeView.indexOf({id: tmdbId, type: Util.MOVIE }) >= 0
                property variant content: ({
                                      id: parsedMovie.tmdbId,
                                      url: parsedMovie.url,
                                      title: parsedMovie.name,
                                      icon: parsedMovie.poster,
                                      type: Util.MOVIE
                                  })
                text: isFavorite ? qsTr('Remove from Favorites') : qsTr('Add to Favorites')
                onClicked: {
                    if (isFavorite)
                        welcomeView.removeFavorite(content)
                    else
                        welcomeView.addFavorite(content)
                }
            }
        }

        VerticalScrollDecorator { }

        Column {
            id: movieContent
            width: parent.width
            spacing: UIConstants.DEFAULT_MARGIN

            PageHeader {
                title: parsedMovie.name
            }

            Label {
                id: extendedContentLabel
                //: This indicates that the extended info for a content (person or movie) is still loading
                text: qsTr('Loading content')
                visible: loadingExtended
                anchors.horizontalCenter: parent.horizontalCenter

                BusyIndicator {
                    visible: running
                    running: loadingExtended
                    anchors {
                        left: extendedContentLabel.right
                        leftMargin: UIConstants.DEFAULT_MARGIN
                        verticalCenter: extendedContentLabel.verticalCenter
                    }
                }
            }

            Row {
                id: row
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }

                Image {
                    id: image
                    width: parent.width * 0.3
                    source: parsedMovie.poster
                    fillMode: Image.PreserveAspectFit
                }

                Column {
                    width: parent.width - image.width

                    MyEntryHeader {
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        text: parsedMovie.originalName +
                              (parsedMovie.released ? ' (' + Util.getYearFromDate(parsedMovie.released) + ')' : '')
                    }

                    Label {
                        id: ratedAndRuntimeLabel
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        wrapMode: Text.WordWrap
                        //: This shows the classification of a movie and its runtime (duration)
                        // TODO rating doesn't work anymore
                        text: '%1'.arg(Util.parseRuntime(parsedMovie.runtime))
                    }

                    Item {
                        height: UIConstants.DEFAULT_MARGIN
                        width: parent.width
                    }

                    Label {
                        id: taglineLabel
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        font.italic: true
                        wrapMode: Text.WordWrap
                        text: parsedMovie.tagline
                        color: Theme.secondaryColor
                    }
                }
            }

            Row {
                id: movieRatingSection
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: UIConstants.DEFAULT_MARGIN
                    rightMargin: UIConstants.DEFAULT_MARGIN
                }

                Label {
                    id: ratingLabel
                    text: parsedMovie.rating.toFixed(1)
                }

                Label {
                    anchors.verticalCenter: ratingLabel.verticalCenter
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    text: '/10'
                }

                Item {
                    height: UIConstants.DEFAULT_MARGIN
                    width: UIConstants.DEFAULT_MARGIN
                }

                // TODO fix rating indicator
//                MyRatingIndicator {
//                    anchors.verticalCenter: ratingLabel.verticalCenter
//                    ratingValue: parsedMovie.rating
//                    maximumValue: 10
//                    count: parsedMovie.votes
//                }
            }

            Column {
                width: parent.width

                Rectangle {
                    width: parent.width
                    height: 1
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                }

                MyGalleryPreviewer {
                    width: parent.width

                    galleryPreviewerModel: postersModel
                    previewerDelegateType: TMDB.IMAGE_POSTER
                    visible: postersModel.count > 0

                    onClicked: {
                        appWindow.pageStack.push(galleryView,
                                                 {
                                                     galleryViewModel: postersModel,
                                                     imgType: TMDB.IMAGE_POSTER,
                                                     fullSize: 3
                                                 })
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    visible: postersModel.count > 0
                }

                MyGalleryPreviewer {
                    width: parent.width

                    galleryPreviewerModel: backdropsModel
                    previewerDelegateType: TMDB.IMAGE_BACKDROP
                    previewedItems: 2
                    previewerDelegateIconWidth: 92 * 2
                    visible: backdropsModel.count > 0

                    onClicked: {
                        appWindow.pageStack.push(galleryView,
                                                 {
                                                     galleryViewModel: backdropsModel,
                                                     imgType: TMDB.IMAGE_BACKDROP,
                                                     fullSize: 1
                                                 })
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    visible: backdropsModel.count > 0
                }

                MyListDelegate {
                    width: parent.width
                    //: Opens the movie trailer for viewing
                    title: qsTr('Watch trailer')
                    titleSize: UIConstants.FONT_SLARGE

                    iconSource: 'qrc:/resources/icon-m-common-video-playback.png'
                    visible: parsedMovie.trailer

                    onClicked: Qt.openUrlExternally(parsedMovie.trailer)
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    visible: parsedMovie.trailer
                }
            }

            MyTextExpander {
                width: parent.width
                visible: parsedMovie.overview
                //: Label acting as the header for the overview
                textHeader: qsTr('Overview')
                textContent: parsedMovie.overview
            }

            PropertyItem {
                title: qsTr('Release date')
                text: Qt.formatDate(Util.parseDate(parsedMovie.released), Qt.DefaultLocaleLongDate)
            }

            MyModelFlowPreviewer {
                flowModel: genresModel
                title: qsTr('Genre')
                previewedField: 'name'
            }

            MyModelFlowPreviewer {
                flowModel: altTitlesModel
                title: qsTr('Alternative titles')
                previewedField: 'title'
            }

            MyModelFlowPreviewer {
                flowModel: studiosModel
                title: qsTr('Studios')
                previewedField: 'name'
            }

            PropertyItem {
                visible: parsedMovie.budget
                title: qsTr('Budget')
                text: controller.formatCurrency(parsedMovie.budget)
            }

            PropertyItem {
                visible: parsedMovie.revenue
                title: qsTr('Revenue')
                text: controller.formatCurrency(parsedMovie.revenue)
            }

            MyModelPreviewer {
                width: parent.width
                previewedModel: castModel
                previewerHeaderText:
                    //: Header for the cast preview shown in the movie view
                    qsTr('Cast')
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'subtitle'
                previewerDelegateIcon: 'img'
                previewerDelegatePlaceholder: 'qrc:/resources/person-placeholder.svg'
                previewerFooterText:
                    //: Footer for the cast preview shown in the movie view. When clicked, shows the full cast.
                    qsTr('Full cast')
                visible: castModel.count > 0

                onClicked: {
                    appWindow.pageStack.push(personView,
                                             {
                                                 person: castModel.get(modelIndex),
                                                 loading: true
                                             })
                }
                onFooterClicked: {
                    appWindow.pageStack.push(castView,
                                             {
                                                 movieName: parsedMovie.name,
                                                 castModel: castModel
                                             })
                }
            }

            MyModelPreviewer {
                width: parent.width
                previewedModel: crewModel
                previewerHeaderText:
                    //: Header for the crew preview shown in the movie view
                    qsTr('Crew')
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'subtitle'
                previewerDelegateIcon: 'img'
                previewerDelegatePlaceholder: 'qrc:/resources/person-placeholder.svg'
                previewerFooterText:
                    //: Footer for the crew preview shown in the movie view. When clicked, shows the full cast and crew.
                    qsTr('Full cast & crew')
                visible: crewModel.count > 0

                onClicked: {
                    appWindow.pageStack.push(personView,
                                             {
                                                 person: crewModel.get(modelIndex),
                                                 loading: true
                                             })
                }
                onFooterClicked: {
                    appWindow.pageStack.push(castView,
                                             {
                                                 movieName: parsedMovie.name,
                                                 castModel: creditsModel,
                                                 showsCast: false
                                             })
                }
            }
        }
    }

    function fetchExtendedContent(contentUrl, action) {
        loadingExtended = true
        Util.asyncQuery({
                            url: contentUrl,
                            response_action: action
                        },
                        handleMessage)
    }

    function handleMessage(messageObject) {
        var objectArray = JSON.parse(messageObject.response)
        if (objectArray.errors !== undefined) {
            console.debug("Error parsing JSON: " + objectArray.errors[0].message)
            return
        }

        switch (messageObject.action) {
        case Util.FETCH_RESPONSE_TMDB_MOVIE:
            parsedMovie.updateWithFullWeightMovie(objectArray)
            loading = loadingExtended = false
            break

        default:
            console.debug('Unknown action response: ', messageObject.action)
            break
        }
    }

    BusyIndicator {
        id: movieBusyIndicator
        anchors.centerIn: parent
        visible: running
        running: loading
        size: BusyIndicatorSize.Large
    }
}
