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

import QtQuick 1.1
import com.nokia.meego 1.0
import 'butacautils.js' as Util
import 'aftercredits.js'as WATC
import 'moviedbwrapper.js' as TMDB
import 'constants.js' as UIConstants
import 'storage.js' as Storage

Page {
    id: movieView

    orientationLock: PageOrientation.LockPortrait

    tools: ButacaToolBar {
        content: ({
                      id: parsedMovie.tmdbId,
                      url: parsedMovie.url,
                      title: parsedMovie.name,
                      icon: parsedMovie.poster,
                      type: Util.MOVIE
                  })
        isFavorite: welcomeView.indexOf({
                                            id: tmdbId,
                                            type: Util.MOVIE
                                        }) >= 0
        menu: movieMenu
    }

    Menu {
        id: movieMenu
        visualParent: pageStack

        MenuLayout {
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
                //: This opens a website displaying movie's extras after or during credits
                text: qsTr('View extras')
                visible: parsedMovie.extrasUrl
                onClicked: Qt.openUrlExternally(parsedMovie.extrasUrl)
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
        }
    }

    property variant movie: ''
    property string tmdbId: parsedMovie.tmdbId
    property string imdbId: parsedMovie.imdbId
    property bool loading: false
    property bool loadingExtended: false
    property bool loadingExtras: false
    property bool inWatchlist: tmdbId ? Storage.inWatchlist({ 'id': tmdbId }) : false

    QtObject {
        id: parsedMovie

        // Part of the lightweight movie object
        property string tmdbId: ''
        property string name: ''
        property string originalName: ''
        property string released: ''
        property double rating: 0
        property int votes: 0
        property string poster: 'qrc:/resources/movie-placeholder.svg'
        property string url: '' // implicit: base url + movie id
        // also available: backdrop, adult, popularity

        // Part of the full movie object
        property string imdbId: ''
        property string overview: ''
        property string tagline: ''
        property string trailer: ''
        property string revenue: ''
        property string budget: ''
        property int runtime: 0
        property string certification: '-'
        property string homepage: ''
        property string extras:
            //: This indicates that no extra content after or during the credits was found
            qsTr('Not found')
        property string extrasUrl: ''
        property bool extrasFetched: false
        // also available: belongs_to_collection, spoken_languages, status

        function updateWithLightWeightMovie(movie) {
            tmdbId = movie.id
            name = movie.title
            originalName = movie.original_title
            released = movie.release_date
            rating = movie.vote_average
            votes = movie.vote_count
            url = 'http://www.themoviedb.org/movie/' + tmdbId
            if (movie.poster_path)
                poster = TMDB.image(TMDB.IMAGE_POSTER, 2,
                                    movie.poster_path, { app_locale: appLocale })
        }

        function updateWithFullWeightMovie(movie) {
            if (!movieView.movie) {
                updateWithLightWeightMovie(movie)
            }
            movieView.movie = ''

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

            Util.populateModelFromArray(movie.alternative_titles, 'titles', altTitlesModel)
            Util.populateModelFromArray(movie, 'genres', genresModel)
            Util.populateModelFromArray(movie, 'production_companies', studiosModel)
            Util.populateModelFromArray(movie.images, 'posters', postersModel)
            Util.populateModelFromArray(movie.images, 'backdrops', backdropsModel)

            for (var i = 0; i < movie.releases['countries'].length; i++)
                if (movie.releases.countries[i].iso_3166_1 == appLocale.toUpperCase())
                    certification = movie.releases.countries[i].certification

            if (movie.credits.cast) {
                movie.credits.cast.sort(sortByCastId)
                Util.populateModelFromArray(movie.credits, 'cast', castModel)
            }
            if (movie.credits.crew) {
                movie.credits.crew.sort(sortByDepartment)
                Util.populateModelFromArray(movie.credits, 'crew', crewModel)
            }

            if (!loadingExtras && !parsedMovie.extrasFetched)
                fetchExtras()
        }
    }

    function sortByCastId(oneItem, theOther) {
        return oneItem.cast_id - theOther.cast_id
    }

    function sortByDepartment(oneItem, theOther) {
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
        }
        return result
    }

    Component.onCompleted: {
        if (movie) {
            var theMovie = new Util.TMDbMovie(movie)
            parsedMovie.updateWithLightWeightMovie(theMovie)
        }

        if (tmdbId)
            fetchExtendedContent(TMDB.movie_info(tmdbId,
                                                 'alternative_titles,credits,images,trailers,releases',
                                                 { app_locale: appLocale }),
                                 Util.FETCH_RESPONSE_TMDB_MOVIE)

        if (imdbId && parsedMovie.originalName)
            fetchExtras()
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

    Flickable {
        id: movieFlickableWrapper
        anchors {
            fill: parent
            margins: UIConstants.DEFAULT_MARGIN
        }
        contentHeight: movieContent.height
        visible: !loading

        Column {
            id: movieContent
            width: parent.width
            spacing: UIConstants.DEFAULT_MARGIN

            Header {
                text: parsedMovie.name + ' (' + Util.getYearFromDate(parsedMovie.released) + ')'
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
                    platformStyle: BusyIndicatorStyle {
                        size: 'small'
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
                        headerFontSize: UIConstants.FONT_SLARGE
                        text: parsedMovie.originalName + ' (' + Util.getYearFromDate(parsedMovie.released) + ')'
                    }

                    Label {
                        id: ratedAndRuntimeLabel
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_LSMALL
                        }
                        wrapMode: Text.WordWrap
                        //: This shows the classification of a movie and its runtime (duration)
                        text: qsTr('Rated %1, %2').arg(parsedMovie.certification).arg(Util.parseRuntime(parsedMovie.runtime))
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
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_DEFAULT
                            fontFamily: UIConstants.FONT_FAMILY_LIGHT
                        }
                        font.italic: true
                        wrapMode: Text.WordWrap
                        text: parsedMovie.tagline
                    }
                }
            }

            Row {
                id: movieRatingSection

                Label {
                    id: ratingLabel
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_XXXLARGE
                        fontFamily: UIConstants.FONT_FAMILY_TABULAR
                    }
                    text: parsedMovie.rating.toFixed(1)
                }

                Label {
                    anchors.verticalCenter: ratingLabel.verticalCenter
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_XXLARGE
                        fontFamily: UIConstants.FONT_FAMILY_TABULAR
                    }
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

            Column {
                id: movieReleasedSection
                width: parent.width

                MyEntryHeader {
                    width: parent.width
                    //: Label acting as the header for the release date
                    text: qsTr('Release date')
                }

                Label {
                    id: release
                    width: parent.width
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_LSMALL
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                    }
                    text: Qt.formatDate(Util.parseDate(parsedMovie.released), Qt.DefaultLocaleLongDate)
                }
            }

            Column {
                id: movieGenresSection
                width: parent.width
                visible: genresModel.count > 0

                MyEntryHeader {
                    width: parent.width
                    //: Label acting as the header for the genres
                    text: qsTr('Genre')
                }

                MyModelFlowPreviewer {
                    width: parent.width
                    flowModel: genresModel
                    previewedField: 'name'
                }
            }

            Column {
                id: movieAltTitlesSection
                width: parent.width
                visible: altTitlesModel.count > 0

                MyEntryHeader {
                    width: parent.width
                    //: Label acting as the header for the alternative titles
                    text: qsTr('Alternative titles')
                }

                MyModelFlowPreviewer {
                    width: parent.width
                    flowModel: altTitlesModel
                    previewedField: 'title'
                }
            }

            Column {
                id: movieStudiosSection
                width: parent.width
                visible: studiosModel.count > 0

                MyEntryHeader {
                    width: parent.width
                    //: Label acting as the header for the studios
                    text: qsTr('Studios')
                }

                MyModelFlowPreviewer {
                    width: parent.width
                    flowModel: studiosModel
                    previewedField: 'name'
                }
            }

            Column {
                id: movieBudgetSection
                width: parent.width
                visible: parsedMovie.budget

                MyEntryHeader {
                    width: parent.width
                    //: Label acting as the header for the movie budget
                    text: qsTr('Budget')
                }

                Label {
                    width: parent.width
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_LSMALL
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                    }
                    text: controller.formatCurrency(parsedMovie.budget)
                }
            }

            Column {
                id: movieRevenueSection
                width: parent.width
                visible: parsedMovie.revenue

                MyEntryHeader {
                    width: parent.width
                    //: Label acting as the header for the movie revenue
                    text: qsTr('Revenue')
                }

                Label {
                    width: parent.width
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_LSMALL
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                    }
                    text: controller.formatCurrency(parsedMovie.revenue)
                }
            }

            Column {
                id: movieExtrasSection
                width: parent.width

                MyEntryHeader {
                    width: parent.width
                    //: Label acting as the header for the extra information after / during credits
                    text: qsTr('Extras after or during credits?')

                    BusyIndicator {
                        visible: running
                        running: loadingExtras
                        anchors {
                            right: parent.right
                            rightMargin: UIConstants.DEFAULT_MARGIN
                            verticalCenter: parent.verticalCenter
                        }
                        platformStyle: BusyIndicatorStyle {
                            size: 'small'
                        }
                    }
                }

                Label {
                    width: parent.width
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_LSMALL
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                    }
                    text: parsedMovie.extras
                    visible: !loadingExtras
                }
            }

            MyModelPreviewer {
                width: parent.width
                previewedModel: castModel
                previewerHeaderText:
                    //: Header for the cast preview shown in the movie view
                    qsTr('Cast')
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'character'
                previewerDelegateIcon: 'profile_path'
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
                previewerDelegateSubtitle: 'job'
                previewerDelegateIcon: 'profile_path'
                previewerDelegatePlaceholder: 'qrc:/resources/person-placeholder.svg'
                previewerFooterText:
                    //: Footer for the crew preview shown in the movie view. When clicked, shows the full cast and crew.
                    qsTr('Full crew')
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
                                                 castModel: crewModel,
                                                 showsCast: false
                                             })
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: movieFlickableWrapper
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }

    function fetchExtendedContent(contentUrl, action) {
        loadingExtended = true
        Util.asyncQuery({
                            url: contentUrl,
                            response_action: action
                        },
                        handleMessage)
    }

    function fetchExtras() {
        loadingExtras = true
        Util.asyncQuery({
                            url: WATC.movie_extras(parsedMovie.originalName),
                            response_action: Util.FETCH_RESPONSE_WATC
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

        case Util.FETCH_RESPONSE_WATC:
            parsedMovie.extrasFetched = true
            var watcMovie = WATC.parseACResponse(objectArray, parsedMovie.imdbId)
            if (watcMovie) {
                parsedMovie.extras = watcMovie.subtitle
                parsedMovie.extrasUrl = watcMovie.url
            }
            loadingExtras = false
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
        platformStyle: BusyIndicatorStyle {
            size: 'large'
        }
    }
}
