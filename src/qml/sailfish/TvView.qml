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
    id: tvView

    property variant movie: ''
    property alias tmdbId: parsedMovie.tmdbId
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
        property string started: ''
        property string ended: ' - '
        property double rating: 0
        property int votes: 0
        property string overview: ''
        property int numSeasons: 0
        property int numEpisodes: 0
        property string trailer: ''
        property string runtime: ''
        property string homepage: ''
        property bool in_production: false
        property string status: ''

        // also available:

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
            name = movie.name
            url = 'http://www.themoviedb.org/tv/' + tmdbId
            if (movie.poster_path)
                poster = TMDB.image(TMDB.IMAGE_POSTER, 2,
                                    movie.poster_path, { app_locale: appLocale })
            if (movie.original_name)
                originalName = movie.original_name
            if (movie.first_air_date)
                started = movie.first_air_date
            if (movie.last_air_date)
                ended = movie.last_air_date
            if (movie.vote_average)
                rating = movie.vote_average
            if (movie.vote_count)
                votes = movie.vote_count
            if (movie.overview)
                overview = movie.overview
            if (movie.number_of_seasons)
                numSeasons = movie.number_of_seasons
            if (movie.number_of_episodes)
                numEpisodes = movie.number_of_episodes
            if (movie.videos.results[0] &&
                    movie.videos.results[0].site === 'YouTube') // can't deal with quicktime
                trailer = 'http://www.youtube.com/watch?v=' + movie.videos.results[0].key
            if (movie.homepage)
                homepage = movie.homepage
            if (movie.in_production)
                in_production = movie.in_production
            if (movie.status)
                status = movie.status
            if (movie.episode_run_time[0]) {
                runtime = Util.parseRuntime(movie.episode_run_time[0])
                for (var i = 1; i < movie.episode_run_time.length; i ++)
                    runtime += ' / ' + Util.parseRuntime(movie.episode_run_time[i])
            }

            Util.populateModelFromArray(movie.genres, genresModel)
            Util.populateModelFromArray(movie.images.posters, postersModel)
            Util.populateModelFromArray(movie.images.backdrops, backdropsModel)

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
            fetchExtendedContent(TMDB.tv_info(tmdbId,
                                                 'credits,images,videos',
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

    ListModel {
        id: genresModel
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
                //: This opens a website displaying the movie homepage
                text: qsTr('Open homepage')
                visible: parsedMovie.homepage
                onClicked: Qt.openUrlExternally(parsedMovie.homepage)
            }
            MenuItem {
                //: This visits the The Movie Database page of this content (movie or person)
                text: qsTr('View in TMDb')
                onClicked: Qt.openUrlExternally(parsedMovie.url)
            }

            MenuItem {
                property bool isFavorite: welcomeView.indexOf({id: tmdbId, type: Util.TV }) >= 0
                property variant content:
                    ({
                         id: parsedMovie.tmdbId,
                         url: parsedMovie.url,
                         title: parsedMovie.name,
                         icon: parsedMovie.poster,
                         type: Util.TV
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
                width: parent.width

                Image {
                    id: image
                    width: 160
                    height: 236
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
                              (parsedMovie.started ? ' (' + Util.getYearFromDate(parsedMovie.started) + ')' : '')
                    }

                    Label {
                        id: episodeSeasonLabel
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.WordWrap
                        //: This shows the TV show's number of episodes and seasons
                        text: qsTr('%1 Episodes, %2 Seasons').arg(parsedMovie.numEpisodes).arg(parsedMovie.numSeasons)
                    }

                    Item {
                        height: UIConstants.DEFAULT_MARGIN
                        width: parent.width
                    }

                    Label {
                        id: statusLabel
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.WordWrap
                        //: This shows whether the TV show is currently in the means of producing further episodes or not
                        text: parsedMovie.status + ', ' +
                              (parsedMovie.in_production ? qsTr('in Production') :
                                                           qsTr('currently not in Production'))
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

                MyRatingIndicator {
                    anchors.verticalCenter: ratingLabel.verticalCenter
                    ratingValue: parsedMovie.rating
                    maximumValue: 10
                    count: parsedMovie.votes
                }
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
                text: Qt.formatDate(Util.parseDate(parsedMovie.started), Qt.DefaultLocaleLongDate) + ' -\n' +
                      Qt.formatDate(Util.parseDate(parsedMovie.ended), Qt.DefaultLocaleLongDate)
            }

            MyModelFlowPreviewer {
                flowModel: genresModel
                title: qsTr('Genre')
                previewedField: 'name'
            }

            PropertyItem {
                title: qsTr('Episode runtime')
                text: parsedMovie.runtime
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
