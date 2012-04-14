/**************************************************************************
 *    Butaca
 *    Copyright (C) 2011 Simon Pena <spena@igalia.com>
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
import 'butacautils.js' as BUTACA
import 'constants.js' as UIConstants

Page {
    id: personView

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
    }

    property variant person: ''
    property string tmdbId: parsedPerson.tmdbId
    property bool loading: false

    QtObject {
        id: parsedPerson

        // Part of the lightweight person
        property string tmdbId: ''
        property string name: ''
        property string biography: ''
        property string url: ''
        property string profile: ''

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

            BUTACA.populateModel(person, 'filmography', filmographyModel)
            BUTACA.populateImagesModel(person, 'profile', picturesModel)

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

    Component.onCompleted: {
        if (person) {
            var thePerson = new BUTACA.TMDbPerson(person)
            parsedPerson.updateWithLightWeightPerson(thePerson)
        }

        if (tmdbId !== -1) {
            asyncWorker.sendMessage({
                                        action: BUTACA.REMOTE_FETCH_REQUEST,
                                        tmdbId: tmdbId,
                                        tmdbType: 'person'
                                    })
        }
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
                        text: 'Born'
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
                        text: Qt.formatDate(BUTACA.parseDate(parsedPerson.birthday), Qt.DefaultLocaleLongDate)
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
                        text: 'Known for %1 movies'.arg(parsedPerson.knownMovies)
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
            }

            Rectangle {
                width: parent.width
                height: 1
                color: UIConstants.COLOR_SECONDARY_FOREGROUND
            }

            MyTextExpander {
                width: parent.width

                textHeader: 'Biography'
                textContent: parsedPerson.biography
            }

            MyModelPreviewer {
                width: parent.width
                previewedModel: filmographyModel
                previewerHeaderText: 'Filmography'
                previewerDelegateTitle: 'name'
                previewerDelegateSubtitle: 'job'
                previewerDelegateIcon: 'poster'
                previewerDelegatePlaceholder: 'qrc:/resources/movie-placeholder.svg'
                previewerFooterText: 'Full Filmography'
            }
        }
    }

    ScrollDecorator {
        flickableItem: personFlickableWrapper
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }

    function handleMessage(messageObject) {
        if (messageObject.action === BUTACA.REMOTE_FETCH_RESPONSE) {
            loading = false
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

    WorkerScript {
        id: asyncWorker
        source: 'workerscript.js'
        onMessage: {
            handleMessage(messageObject)
        }
    }
}
