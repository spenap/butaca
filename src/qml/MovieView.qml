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
        property string poster: ''
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

        function updateWithLightWeightMovie(movie) {
            tmdbId = movie.id
            name = movie.name
            released = movie.released
            rating = movie.rating
            votes = movie.votes
            overview = movie.overview
            poster = movie.poster
        }

        function updateWithFullWeightMovie(movie) {
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

            populateModel(movie, 'categories', categoriesModel)
            populateModel(movie, 'studios', studiosModel)
            populateModel(movie, 'languages_spoken', languagesSpokenModel)
            populateModel(movie, 'countries', countriesModel)
            populateModel(movie, 'posters', postersModel)
            populateModel(movie, 'cast', castModel)
        }
    }

    function populateModel(movie, movieProperty, model) {
        if (movie[movieProperty]) {
            console.debug('Populating model with ', movieProperty)
            for (var i = 0; i < movie[movieProperty].length; i ++) {
                model.append(movie[movieProperty][i])
            }
        }
    }

    Component.onCompleted: {
        var theMovie = new BUTACA.TMDbMovie(movie)

        parsedMovie.updateWithLightWeightMovie(theMovie)
        movie = ''

        asyncWorker.sendMessage({
                                    action: BUTACA.REMOTE_FETCH_REQUEST,
                                    tmdbId: parsedMovie.tmdbId,
                                    tmdbType: 'movie'
                                })
    }

    ListModel {
        id: categoriesModel
    }

    ListModel {
        id: studiosModel
    }

    ListModel {
        id: languagesSpokenModel
    }

    ListModel {
        id: countriesModel
    }

    ListModel {
        id: postersModel
    }

    ListModel {
        id: castModel
    }

    Flickable {
        id: movieFlickable
        anchors.fill: parent
        contentHeight: content.height

        Column {
            id: content
            width: parent.width
            spacing: UIConstants.DEFAULT_MARGIN

            Header {
                id: titleText
                text: parsedMovie.name + ' (' + BUTACA.getYearFromDate(parsedMovie.released) + ')'
            }

            Row {
                id: row
                spacing: 20
                width: parent.width

                Image {
                    id: image
                    width: 190
                    height: 280
                    source: parsedMovie.poster ? parsedMovie.poster : 'qrc:/resources/movie-placeholder.svg'
                    onStatusChanged: {
                        if (image.status == Image.Error) {
                            image.source = 'qrc:/resources/movie-placeholder.svg'
                        }
                    }
                }

                Column {
                    width: parent.width - image.width
                    spacing: 8

                    Label {
                        id: akaText
                        width: parent.width
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_LSMALL
                        }
                        wrapMode: Text.WordWrap
                        //: 'Also known as:'
                        text: '<b>' + qsTr('btc-also-known-as') + '</b><br />' +
                              (parsedMovie.alternativeName ? parsedMovie.alternativeName : ' - ')
                    }

                    Label {
                        id: certificationText
                        width: parent.width
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_LSMALL
                        }
                        wrapMode: Text.WordWrap
                        //: Certification:
                        text: '<b>' + qsTr('btc-certification') + '</b> ' +
                              (parsedMovie.certification ? parsedMovie.certification : ' - ')
                    }

                    Label {
                        id: releasedText
                        width: parent.width
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_LSMALL
                        }
                        wrapMode: Text.WordWrap
                        //: Release date:
                        text: '<b>' + qsTr('btc-release-date') + '</b><br /> ' +
                              (parsedMovie.released ? parsedMovie.released : ' - ')
                    }

                    Label {
                        id: budgetText
                        width: parent.width
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_LSMALL
                        }
                        wrapMode: Text.WordWrap
                        //: Budget:
                        text: '<b>' + qsTr('btc-budget') + '</b> ' +
                              (parsedMovie.budget ? controller.formatCurrency(parsedMovie.budget) : ' - ')
                    }

                    Label {
                        id: revenueText
                        width: parent.width
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_LSMALL
                        }
                        wrapMode: Text.WordWrap
                        //: Revenue:
                        text: '<b>' + qsTr('btc-revenue') + '</b> ' +
                              (parsedMovie.revenue ? controller.formatCurrency(parsedMovie.revenue) : ' - ')
                    }

                    MyRatingIndicator {
                        ratingValue: parsedMovie.rating / 2
                        maximumValue: 5
                        count: parsedMovie.votes
                    }
                }
            }

            Label {
                id: cast
                width: parent.width - castDetails.width
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_LSMALL
                }
                wrapMode: Text.WordWrap
                text: formatMovieCast()
                opacity: castMouseArea.pressed ? 0.5 : 1

                Image {
                    id: castDetails
                    anchors {
                        top: parent.top
                        right: parent.right
                    }
                    source: 'image://theme/icon-s-music-video-description'
                }

                MouseArea {
                    id: castMouseArea
                    anchors.fill: cast
                    onClicked: {
                        appWindow.pageStack.push(castView,
                                                 { movie: title,
                                                   movieId: tmdbId })
                    }
                }
            }

            Label {
                id: overviewText
                width: parent.width
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_LSMALL
                }
                //: Overview:
                text: '<b>' + qsTr('btc-overview') + '</b><br />' +
                      //: Overview not found
                      (parsedMovie.overview ? BUTACA.sanitizeText(parsedMovie.overview) : qsTr('btc-overview-not-found'))
                wrapMode: Text.WordWrap
            }

            Label {
                id: trailerHeader
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_SLARGE
                }
                //: Movie trailer
                text: '<b>' + qsTr('btc-movie-trailer') + '</b>'
                visible: trailerImage.visible
            }

            Image {
                id: trailerImage
                width: 120; height: 90
                source: BUTACA.getTrailerThumbnail(parsedMovie.trailer)
                visible: playButton.visible

                Image {
                    id: playButton
                    anchors.centerIn: parent
                    source: 'image://theme/icon-s-music-video-play'
                    visible: trailerImage.source != ''
                }

                MouseArea {
                    anchors.fill: trailerImage
                    onClicked: {
                        Qt.openUrlExternally(trailer)
                    }
                }
            }
        }
    }

    function handleMessage(messageObject) {
        if (messageObject.action === BUTACA.REMOTE_FETCH_RESPONSE) {
            var fullMovie = JSON.parse(messageObject.response)[0]
            parsedMovie.updateWithFullWeightMovie(fullMovie)
        } else {
            console.debug('Unknown action response: ', messageObject.action)
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
