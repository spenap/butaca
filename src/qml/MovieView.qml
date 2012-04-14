import QtQuick 1.1
import com.nokia.meego 1.0
import 'butacautils.js' as BUTACA
import 'constants.js' as UIConstants

Page {
    id: movieView

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
    }

    property variant movie: ''
    property string tmdbId: parsedMovie.tmdbId
    property bool loading: false

    QtObject {
        id: parsedMovie

        // Part of the lightweight movie object
        property string tmdbId: ''
        property string name: ''
        property string originalName: ''
        property string alternativeName: ''
        property string released: ''
        property double rating: 0
        property int votes: 0
        property string overview: ''
        property string poster: 'qrc:/resources/movie-placeholder.svg'
        property string url: ''

        // Part of the full movie object
        property string imdbId: ''
        property string tagline: ''
        property string trailer: ''
        property string revenue: ''
        property string budget: ''
        property int runtime: 0
        property string certification: ''
        property string homepage: ''

        property variant rawCast: ''

        function updateWithLightWeightMovie(movie) {
            tmdbId = movie.id
            name = movie.name
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

            rawCast = movie.cast
            rawCast.sort(sortByDepartment)
            movie.cast.sort(sortByCastId)

            BUTACA.populateModel(movie, 'genres', genresModel)
            BUTACA.populateModel(movie, 'studios', studiosModel)
            BUTACA.populateImagesModel(movie, 'posters', postersModel)
            BUTACA.populateModel(movie, 'cast', crewModel,
                                 {
                                     filteringProperty: 'job',
                                     filteredValue: 'Actor',
                                     secondaryModel: castModel,
                                     Delegate: BUTACA.TMDbCrewPerson
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
        return oneItem.department.localeCompare(theOther.department)
    }

    Component.onCompleted: {
        if (movie) {
            var theMovie = new BUTACA.TMDbMovie(movie)
            parsedMovie.updateWithLightWeightMovie(theMovie)
        }

        if (tmdbId !== -1) {
            asyncWorker.sendMessage({
                                        action: BUTACA.REMOTE_FETCH_REQUEST,
                                        tmdbId: tmdbId,
                                        tmdbType: 'movie'
                                    })
        }
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

    Component { id: galleryView; MediaGalleryView { } }

    Component { id: personView; PersonView { } }

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
                text: parsedMovie.name + ' (' + BUTACA.getYearFromDate(parsedMovie.released) + ')'
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
                        text: parsedMovie.name + ' (' + BUTACA.getYearFromDate(parsedMovie.released) + ')'
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
                        text: 'Rated ' + parsedMovie.certification + ', ' + parseRuntime(parsedMovie.runtime)
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

                    onClicked: {
                        appWindow.pageStack.push(galleryView, { galleryViewModel: postersModel })
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    visible: parsedMovie.trailer
                }

                MyListDelegate {
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
                }
            }

            MyTextExpander {
                width: parent.width

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
                    text: Qt.formatDate(BUTACA.parseDate(parsedMovie.released), Qt.DefaultLocaleLongDate)
                }
            }

            Column {
                id: movieGenresSection
                width: parent.width

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

            MyModelPreviewer {
                width: parent.width
                previewedModel: castModel
                previewerHeaderText: 'Cast'
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'character'
                previewerDelegateIcon: 'profile'
                previewerDelegatePlaceholder: 'qrc:/resources/person-placeholder.svg'
                previewerFooterText: 'Full Cast'

                onClicked: {
                    appWindow.pageStack.push(personView,
                                             {
                                                 detailId: castModel.get(modelIndex).id,
                                                 viewType: BUTACA.PERSON
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

                onClicked: {
                    appWindow.pageStack.push(personView,
                                             {
                                                 detailId: crewModel.get(modelIndex).id,
                                                 viewType: BUTACA.PERSON
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

    function parseRuntime(runtime) {
        var hours = parseInt(runtime / 60)
        var minutes = (runtime % 60)

        var str = hours + ' h ' + minutes + ' m'
        return str
    }

    function handleMessage(messageObject) {
        if (messageObject.action === BUTACA.REMOTE_FETCH_RESPONSE) {
            loading = false
            var fullMovie = JSON.parse(messageObject.response)[0]
            parsedMovie.updateWithFullWeightMovie(fullMovie)
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

    WorkerScript {
        id: asyncWorker
        source: 'workerscript.js'
        onMessage: {
            handleMessage(messageObject)
        }
    }
}
