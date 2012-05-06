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
                          //% "Add to watchlist"
                          qsTrId('btc-watchlist-add') :
                          //: This removes the movie from the watch list
                          //% "Remove from watchlist"
                          qsTrId('btc-watchlist-remove')
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
                //% "Open homepage"
                text: qsTrId('btc-open-homepage')
                visible: parsedMovie.homepage
                onClicked: Qt.openUrlExternally(parsedMovie.homepage)
            }
            MenuItem {
                //: This opens a website displaying movie's extras after or during credits
                //% "View extras"
                text: qsTrId('btc-open-movie-extras')
                visible: parsedMovie.extrasUrl
                onClicked: Qt.openUrlExternally(parsedMovie.extrasUrl)
            }
            MenuItem {
                //: This visits the Internet Movie Database page of this content (movie or person)
                //% "View in IMDb"
                text: qsTrId('btc-open-imdb')
                onClicked: Qt.openUrlExternally(Util.IMDB_BASE_URL + parsedMovie.imdbId)
            }
            MenuItem {
                //: This visits the The Movie Database page of this content (movie or person)
                //% "View in TMDb"
                text: qsTrId('btc-open-tmdb')
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
        property string imdbId: ''
        property string name: ''
        property string originalName: ''
        property string released: ''
        property double rating: 0
        property int votes: 0
        property string overview: ''
        property string poster: 'qrc:/resources/movie-placeholder.svg'
        property string url: ''

        // Part of the full movie object
        property string alternativeName: ''
        property string tagline: ''
        property string trailer: ''
        property string revenue: ''
        property string budget: ''
        property int runtime: 0
        property string certification: ''
        property string homepage: ''
        property string extras:
            //: This indicates that no extra content after or during the credits was found
            //% "Not found"
            qsTrId('btc-extras-not-found')
        property string extrasUrl: ''
        property bool extrasFetched: false

        property variant rawCast: ''

        function updateWithLightWeightMovie(movie) {
            tmdbId = movie.id
            imdbId = movie.imdb_id
            name = movie.name
            originalName = movie.original_name
            released = movie.released
            rating = movie.rating
            votes = movie.votes
            overview = movie.overview
            if (movie.poster)
                poster = movie.poster
        }

        function updateWithFullWeightMovie(movie) {
            if (!movieView.movie) {
                updateWithLightWeightMovie(movie)
            }
            movieView.movie = ''

            if (movie.trailer)
                trailer = movie.trailer
            if (movie.homepage)
                homepage = movie.homepage
            if (movie.revenue)
                revenue = movie.revenue
            if (movie.budget)
                budget = movie.budget
            if (movie.certification)
                certification = movie.certification
            if (movie.alternativeName)
                alternativeName = movie.alternative_name
            if (movie.tagline)
                tagline = movie.tagline
            if (movie.runtime)
                runtime = movie.runtime

            if (movie.cast) {
                movie.cast.sort(sortByCastId)
                var crew = movie.cast
                crew.sort(sortByDepartment)
                rawCast = crew
            }

            Util.populateModelFromArray(movie, 'genres', genresModel)
            Util.populateModelFromArray(movie, 'studios', studiosModel)
            Util.populateImagesModelFromArray(movie, 'posters', postersModel)
            Util.populateModelFromArray(movie, 'cast', crewModel,
                                 {
                                     filteringProperty: 'job',
                                     filteredValue: 'Actor',
                                     secondaryModel: castModel,
                                     Delegate: Util.TMDbCrewPerson
                                 })

            if (postersModel.count > 0 &&
                    postersModel.get(0).sizes['cover'].url)
                poster = postersModel.get(0).sizes['cover'].url

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
            if (oneItem.department === 'Directing')
                return -1
            else if (theOther.department === 'Directing')
                return 1
            else if (oneItem.department === 'Actors')
                return 1
            else if (theOther.department === 'Actors')
                return -1
        }
        return result
    }

    Component.onCompleted: {
        if (movie) {
            var theMovie = new Util.TMDbMovie(movie)
            parsedMovie.updateWithLightWeightMovie(theMovie)
        }

        if (tmdbId) {
            fetchExtendedContent(TMDB.movie_info(tmdbId, { app_locale: appLocale, format: 'json' }),
                                 Util.REMOTE_FETCH_RESPONSE)
        } else if (imdbId) {
            fetchExtendedContent(TMDB.movie_imdb_lookup(imdbId, { app_locale: appLocale, format: 'json' }),
                                 Util.LOOKUP_FETCH_RESPONSE)
        }

        if (imdbId && parsedMovie.originalName) fetchExtras()
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
                            response_action: Util.EXTRAS_FETCH_RESPONSE
                        },
                        handleMessage)
    }

    // Several ListModels are used.
    // * Genres stores the genres / categories which best describe the movie. When
    //   browsing by genre, the movie will have at least the genre we were navigating
    // * Studios stores the company which produced the film
    // * Posters stores all the media for this particular film. The media is
    //   processed, so each particular image keeps all available resolutions
    // * Cast and crew are separated from each other, so we can be more specific
    //   in the movie preview

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
        id: castModel
    }

    ListModel {
        id: crewModel
    }

    Component {
        id: galleryView

        MediaGalleryView {
            gridSize: 'w154'
            fullSize: 'mid'
            saveSize: 'original'
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
                //% "Loading content"
                text: qsTrId('btc-content-loading')
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
                        text: parsedMovie.name + ' (' + Util.getYearFromDate(parsedMovie.released) + ')'
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
                        //% "Rated %1, %2"
                        text: qsTrId('btc-movie-rating-runtime').arg(parsedMovie.certification).arg(Util.parseRuntime(parsedMovie.runtime))
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
                    previewerDelegateIcon: 'url'
                    previewerDelegateSize: 'thumb'
                    visible: postersModel.count > 0

                    onClicked: {
                        appWindow.pageStack.push(galleryView, { galleryViewModel: postersModel })
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    visible: postersModel.count > 0
                }

                MyListDelegate {
                    width: parent.width
                    //: Opens the movie trailer for viewing
                    //% "Watch trailer"
                    title: qsTrId('btc-watch-trailer')
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
                //% "Overview"
                textHeader: qsTrId('btc-movie-overview')
                textContent: parsedMovie.overview
            }

            Column {
                id: movieReleasedSection
                width: parent.width

                MyEntryHeader {
                    width: parent.width
                    //: Label acting as the header for the release date
                    //% "Release date"
                    text: qsTrId('btc-movie-release-date')
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
                    //% "Genre"
                    text: qsTrId('btc-movie-genre')
                }

                MyModelFlowPreviewer {
                    width: parent.width
                    flowModel: genresModel
                    previewedField: 'name'
                }
            }

            Column {
                id: movieStudiosSection
                width: parent.width
                visible: studiosModel.count > 0

                MyEntryHeader {
                    width: parent.width
                    //: Label acting as the header for the studios
                    //% "Studios"
                    text: qsTrId('btc-movie-studios')
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
                    //% "Budget"
                    text: qsTrId('btc-movie-budget')
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
                    //% "Revenue"
                    text: qsTrId('btc-movie-revenue')
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
                    //% "Extras after or during credits?"
                    text: qsTrId('btc-extras-header')

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
                    //% "Cast"
                    qsTrId('btc-previewcast-header')
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'character'
                previewerDelegateIcon: 'profile'
                previewerDelegatePlaceholder: 'qrc:/resources/person-placeholder.svg'
                previewerFooterText:
                    //: Footer for the cast preview shown in the movie view. When clicked, shows the full cast.
                    //% "Full cast"
                    qsTrId('btc-previewcast-footer')
                visible: castModel.count > 0

                onClicked: {
                    appWindow.pageStack.push(personView,
                                             {
                                                 tmdbId: castModel.get(modelIndex).id,
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
                    //% "Crew"
                    qsTrId('btc-previewcrew-header')
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'job'
                previewerDelegateIcon: 'profile'
                previewerDelegatePlaceholder: 'qrc:/resources/person-placeholder.svg'
                previewerFooterText:
                    //: Footer for the crew preview shown in the movie view. When clicked, shows the full cast and crew.
                    //% "Full cast & crew"
                    qsTrId('btc-previewcrew-footer')
                visible: crewModel.count > 0

                onClicked: {
                    appWindow.pageStack.push(personView,
                                             {
                                                 tmdbId: crewModel.get(modelIndex).id,
                                                 loading: true
                                             })
                }
                onFooterClicked: {
                    appWindow.pageStack.push(castView,
                                             {
                                                 movieName: parsedMovie.name,
                                                 rawCrew: parsedMovie.rawCast,
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

    function handleMessage(messageObject) {
        if (messageObject.action === Util.REMOTE_FETCH_RESPONSE) {
            loading = loadingExtended = false
            var fullMovie = JSON.parse(messageObject.response)[0]
            parsedMovie.updateWithFullWeightMovie(fullMovie)
        } else if (messageObject.action === Util.LOOKUP_FETCH_RESPONSE) {
            // When doing a IMDB lookup, the information retrieved lacks some details
            loading = false
            var partialMovie = JSON.parse(messageObject.response)[0]
            parsedMovie.updateWithFullWeightMovie(partialMovie)
            fetchExtendedContent(TMDB.movie_info(tmdbId, { app_locale: appLocale, format: 'json' }),
                                 Util.REMOTE_FETCH_RESPONSE)
        } else if (messageObject.action === Util.EXTRAS_FETCH_RESPONSE) {
            loadingExtras = false
            parsedMovie.extrasFetched = true
            var afterCreditsResponse = JSON.parse(messageObject.response)
            var watcMovie = WATC.parseACResponse(afterCreditsResponse, parsedMovie.imdbId)
            if (watcMovie) {
                parsedMovie.extras = watcMovie.subtitle
                parsedMovie.extrasUrl = watcMovie.url
            }
        } else {
            console.debug('Unknown action response: ', messageObject.action)
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
