import QtQuick 1.1
import com.nokia.meego 1.0
import 'butacautils.js' as Util
import 'aftercredits.js'as WATC
import 'moviedbwrapper.js' as TMDB
import 'constants.js' as UIConstants

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
    }

    property variant movie: ''
    property string tmdbId: parsedMovie.tmdbId
    property bool loading: false
    property bool loadingExtended: false
    property bool loadingExtras: false

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
        property string extras: 'not found'

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

            movie.cast.sort(sortByCastId)
            var crew = movie.cast
            crew.sort(sortByDepartment)
            rawCast = crew

            Util.populateModel(movie, 'genres', genresModel)
            Util.populateModel(movie, 'studios', studiosModel)
            Util.populateImagesModel(movie, 'posters', postersModel)
            Util.populateModel(movie, 'cast', crewModel,
                                 {
                                     filteringProperty: 'job',
                                     filteredValue: 'Actor',
                                     secondaryModel: castModel,
                                     Delegate: Util.TMDbCrewPerson
                                 })

            if (postersModel.count > 0 &&
                    postersModel.get(0).sizes['cover'].url)
                poster = postersModel.get(0).sizes['cover'].url
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

        if (tmdbId !== -1) fetchExtendedContent()

        if (parsedMovie.imdbId) fetchExtras()
    }

    function fetchExtendedContent() {
        loadingExtended = true
        Util.asyncQuery({
                            url: TMDB.movie_info(tmdbId, { app_locale: appLocale, format: 'json' }),
                            response_action: Util.REMOTE_FETCH_RESPONSE
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
                text: 'Loading content'
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
                        text: 'Rated ' + parsedMovie.certification + ', ' + Util.parseRuntime(parsedMovie.runtime)
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
                    title: 'Watch Trailer'
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

                textHeader: 'Overview'
                textContent: parsedMovie.overview
            }

            Column {
                id: movieReleasedSection
                width: parent.width

                MyEntryHeader {
                    width: parent.width
                    //: Release date:
                    text: qsTr('btc-release-date')
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
                    text: 'Genre'
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
                    text: 'Studios'
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
                    text: 'Budget'
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
                    text: 'Revenue'
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
                    text: 'Extras after or during credits?'

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
                previewerHeaderText: 'Cast'
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'character'
                previewerDelegateIcon: 'profile'
                previewerDelegatePlaceholder: 'qrc:/resources/person-placeholder.svg'
                previewerFooterText: 'Full Cast'
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
                previewerHeaderText: 'Crew'
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'job'
                previewerDelegateIcon: 'profile'
                previewerDelegatePlaceholder: 'qrc:/resources/person-placeholder.svg'
                previewerFooterText: 'Full Cast & Crew'
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
        } else if (messageObject.action === Util.EXTRAS_FETCH_RESPONSE) {
            var afterCreditsResponse = JSON.parse(messageObject.response)
            var resultsFound = (afterCreditsResponse.posts &&
                            afterCreditsResponse.posts.length > 0)

            if (resultsFound) {
                for (var i = 0; i < afterCreditsResponse.posts.length; i ++) {
                    var postEntry = afterCreditsResponse.posts[i]
                    if (postEntry.url !== 'http://aftercredits.com/privacy-policy/') {
                        var movie = new WATC.ACMovie(postEntry.title,
                                                     postEntry.url,
                                                     postEntry.content)
                        if ((movie.imdbId + '').indexOf(parsedMovie.imdbId) >= 0) {
                            if (postEntry.categories &&
                                    postEntry.categories.length > 0) {
                                for (var j = 0; j < postEntry.categories.length; j ++) {
                                    var category = postEntry.categories[j]
                                    movie.addCategory(category)
                                }
                            }
                            parsedMovie.extras = movie.subtitle
                            break
                        }
                    }
                }
            }
            loadingExtras = false
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
