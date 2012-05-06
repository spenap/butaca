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
import 'moviedbwrapper.js' as TMDB
import 'constants.js' as UIConstants

Page {
    id: personView

    orientationLock: PageOrientation.LockPortrait

    tools: ButacaToolBar {
        content: ({
                      id: parsedPerson.tmdbId,
                      url: parsedPerson.url,
                      title: parsedPerson.name,
                      icon: parsedPerson.profile,
                      type: Util.PERSON
                  })
        isFavorite: welcomeView.indexOf({
                                            id: tmdbId,
                                            type: Util.PERSON
                                        }) >= 0
        menu: personMenu
    }

    Menu {
        id: personMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                //% "View in IMDb"
                text: qsTrId('btc-open-imdb')
                onClicked: Qt.openUrlExternally(Util.IMDB_BASE_URL + parsedPerson.imdbId)
            }
            MenuItem {
                //% "View in TMDb"
                text: qsTrId('btc-open-tmdb')
                onClicked: Qt.openUrlExternally(parsedPerson.url)
            }
        }
    }

    property variant person: ''
    property string tmdbId: parsedPerson.tmdbId
    property bool loading: false
    property bool loadingExtended: false

    QtObject {
        id: parsedPerson

        // Part of the lightweight person
        property string tmdbId: ''
        property string name: ''
        property string biography: ''
        property string url: ''
        property string profile: 'qrc:/resources/person-placeholder.svg'

        // Part of the full person object
        property variant alsoKnownAs: ''
        property string birthday: ''
        property string birthplace: ''
        property int knownMovies: 0

        function updateWithLightWeightPerson(person) {
            tmdbId = person.id
            name = person.name
            biography = person.biography
            url = person.url
            if (person.image)
                profile = person.image
        }

        function updateWithFullWeightPerson(person) {
            if (!personView.person) {
                updateWithLightWeightPerson(person)
            }
            personView.person = ''

            if (person.known_as)
                alsoKnownAs = person.known_as
            if (person.birthday)
                birthday = person.birthday
            if (person.birthplace)
                birthplace = person.birthplace
            if (person.known_movies)
                knownMovies = person.known_movies

            Util.populateModelFromArray(person, 'filmography', filmographyModel)
            Util.populateImagesModelFromArray(person, 'profile', picturesModel)

            if (picturesModel.count > 0 &&
                    picturesModel.get(0).sizes['h632'].url)
                profile = picturesModel.get(0).sizes['h632'].url
        }
    }

    ListModel {
        id: filmographyModel
    }

    ListModel {
        id: picturesModel
    }

    Component {
        id: galleryView

        MediaGalleryView {
            gridSize: 'profile'
            fullSize: 'h632'
            saveSize: 'original'
        }
    }

    Component { id: filmographyView; FilmographyView { } }

    Component.onCompleted: {
        if (person) {
            var thePerson = new Util.TMDbPerson(person)
            parsedPerson.updateWithLightWeightPerson(thePerson)
        }

        if (tmdbId !== -1) fetchExtendedContent()
    }

    function fetchExtendedContent() {
        loadingExtended = true
        Util.asyncQuery({
                              url: TMDB.person_info(tmdbId, { app_locale: appLocale, format: 'json' }),
                              response_action: Util.REMOTE_FETCH_RESPONSE
                          },
                          handleMessage)
    }

    Flickable {
        id: personFlickableWrapper

        anchors {
            fill: parent
            margins: UIConstants.DEFAULT_MARGIN
        }
        contentHeight: personContent.height
        visible: !loading

        Column {
            id: personContent
            width: parent.width
            spacing: UIConstants.DEFAULT_MARGIN

            Header {
                text: parsedPerson.name
            }

            Label {
                id: extendedContentLabel
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
                    source: parsedPerson.profile
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
                        text: parsedPerson.name
                    }

                    Item {
                        height: UIConstants.DEFAULT_MARGIN
                        width: parent.width
                    }

                    MyEntryHeader {
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        //: Header shown for the born details of a person
                        //% "Born"
                        text: qsTrId('btc-person-born')
                    }

                    Label {
                        id: birthdayLabel
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_DEFAULT
                            fontFamily: UIConstants.FONT_FAMILY_LIGHT
                        }
                        wrapMode: Text.WordWrap
                        text: Qt.formatDate(Util.parseDate(parsedPerson.birthday), Qt.DefaultLocaleLongDate)
                    }

                    Label {
                        id: birthplaceLabel
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_DEFAULT
                            fontFamily: UIConstants.FONT_FAMILY_LIGHT
                        }
                        wrapMode: Text.WordWrap
                        text: parsedPerson.birthplace
                    }

                    Item {
                        height: UIConstants.DEFAULT_MARGIN
                        width: parent.width
                    }

                    Label {
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: UIConstants.DEFAULT_MARGIN
                        }
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_DEFAULT
                            fontFamily: UIConstants.FONT_FAMILY_LIGHT
                        }
                        wrapMode: Text.WordWrap
                        //: Text shown in the person view displaying the number of movies a person is known for
                        //% "Known for %1 movies"
                        text: qsTrId('btc-person-known-for').arg(parsedPerson.knownMovies)
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: UIConstants.COLOR_SECONDARY_FOREGROUND
            }

            MyGalleryPreviewer {
                width: parent.width

                galleryPreviewerModel: picturesModel
                previewerDelegateIcon: 'url'
                previewerDelegateSize: 'thumb'
                visible: picturesModel.count > 0

                onClicked: {
                    appWindow.pageStack.push(galleryView, { galleryViewModel: picturesModel })
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: UIConstants.COLOR_SECONDARY_FOREGROUND
                visible: picturesModel.count > 0
            }

            MyTextExpander {
                width: parent.width
                visible: parsedPerson.biography
                //: Label acting as the header for the biography
                //% "Biography"
                textHeader: qsTrId('btc-person-biography')
                textContent: parsedPerson.biography
            }

            MyModelPreviewer {
                width: parent.width
                previewedModel: filmographyModel
                previewerHeaderText:
                    //: Header for the filmography preview shown in the person view
                    //% "Filmography"
                    qsTrId('btc-previewfilmography-header')
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'job'
                previewerDelegateIcon: 'poster'
                previewerDelegatePlaceholder: 'qrc:/resources/movie-placeholder.svg'
                previewerFooterText:
                    //: Footer for the filmography preview shown in the person view. When clicked, shows the full filmography
                    //% "Full filmography"
                    qsTrId('btc-previewfilmography-footer')
                visible: filmographyModel.count > 0

                onClicked: {
                    appWindow.pageStack.push(movieView,
                                             {
                                                 tmdbId: filmographyModel.get(modelIndex).id,
                                                 loading: true
                                             })
                }

                onFooterClicked: {
                    appWindow.pageStack.push(filmographyView,
                                             {
                                                 personName: parsedPerson.name,
                                                 filmographyModel: filmographyModel
                                             })
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: personFlickableWrapper
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }

    function handleMessage(messageObject) {
        if (messageObject.action === Util.REMOTE_FETCH_RESPONSE) {
            loading = loadingExtended = false
            var fullPerson = JSON.parse(messageObject.response)[0]
            parsedPerson.updateWithFullWeightPerson(fullPerson)
        } else {
            console.debug('Unknown action response: ', messageObject.action)
        }
    }

    BusyIndicator {
        id: personBusyIndicator
        anchors.centerIn: parent
        visible: running
        running: loading
        platformStyle: BusyIndicatorStyle {
            size: 'large'
        }
    }
}
