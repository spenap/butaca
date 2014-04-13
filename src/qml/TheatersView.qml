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
import com.nokia.extras 1.1
import 'constants.js' as UIConstants
import "storage.js" as Storage

Page {
    id: cinemasView

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
        ToolIcon {
            enabled: theatersContent.state !== 'Loading'
            iconId: 'toolbar-refresh' + (enabled ? '' : '-dimmed')
            onClicked: {
                location = Storage.getSetting('location', '')
                if (location.localeCompare(controller.currentLocation()) !== 0) {
                    controller.fetchTheaters(location)
                    theatersContent.state = 'Loading'
                }
            }
            anchors.horizontalCenter: parent.horizontalCenter
        }
        ToolIcon {
            iconId: 'toolbar-settings'
            onClicked: {
                appWindow.pageStack.push(settingsView, { state: 'showShowtimesSection' })
            }
            anchors.right: parent.right
        }
    }

    orientationLock: PageOrientation.LockPortrait

    property string extendedSection: ''
    property string location
    property bool showShowtimesFilter: false
    property real contentYPos: list.visibleArea.yPosition *
                                   Math.max(list.height, list.contentHeight)

    Component.onCompleted: {
        location = Storage.getSetting('location', '')
        theaterModel.setFilterWildcard('')
        if (list.model.count === 0 ||
                location.localeCompare(controller.currentLocation()) !== 0) {
            controller.fetchTheaters(location)
            theatersContent.state = 'Loading'
        } else {
            theatersContent.state = 'Ready'
        }
    }

    function handleTheatersFetched(ok) {
        if (ok) {
            theatersContent.state = 'Ready'
        } else {
            theatersContent.state = 'Failed'
        }
    }

    Connections {
        target: controller
        onTheatersFetched: handleTheatersFetched(ok)
    }

    Item {
        id: theatersContent
        anchors.fill: parent
        anchors.topMargin: appWindow.inPortrait?
                               UIConstants.HEADER_DEFAULT_TOP_SPACING_PORTRAIT :
                               UIConstants.HEADER_DEFAULT_TOP_SPACING_LANDSCAPE
        state: 'Loading'

        TextField {
            id: searchInput
            anchors {
               top: parent.top
               left: parent.left
               right: parent.right
            }
            anchors {
               topMargin: UIConstants.PADDING_LARGE
               leftMargin: UIConstants.DEFAULT_MARGIN
               rightMargin: UIConstants.DEFAULT_MARGIN
            }
            placeholderText:
                //: Placeholder text for the search field in the showtimes view
                qsTr('Search')
            opacity: showShowtimesFilter ? 1 : 0
            inputMethodHints: Qt.ImhNoPredictiveText

            Behavior on opacity {
               NumberAnimation { from: 0; duration: 200 }
            }

            Image {
               id: clearText
               anchors.right: parent.right
               anchors.verticalCenter: parent.verticalCenter
               source: searchInput.activeFocus ?
                           'image://theme/icon-m-input-clear' :
                           'image://theme/icon-m-common-search'
            }

            MouseArea {
               id: searchInputMouseArea
               anchors.fill: clearText
               onClicked: {
                   inputContext.reset()
                   searchInput.text = ''
               }
            }

            onTextChanged: {
               theaterModel.setFilterWildcard(text)
            }

            onActiveFocusChanged: {
               if (focus) {
                   listTimer.stop()
               } else {
                   listTimer.start()
               }
           }
        }

        Component { id: showtimesView; ShowtimesView { } }

        ListView {
            id: list
            anchors {
                top: showShowtimesFilter ? searchInput.bottom : parent.top
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            flickableDirection: Flickable.VerticalFlick
            model: theaterModel
            clip: true
            header: Column {
                width: parent.width
                visible: height !== 0
                height: !showShowtimesFilter ? childrenRect.height : 0

                Header {
                    //: Header shown in the showtimes view
                    text: qsTr('In theaters')
                    showDivider: false
                }

                Label {
                    platformStyle: LabelStyle {
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                        fontPixelSize: UIConstants.FONT_LSMALL
                    }
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    width: parent.width
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter

                    //: Hint shown to tell users that they can filter by pulling
                    text: qsTr('Pull to filter by cinema or movie')
                }
            }
            delegate: MyListDelegate {
                width: list.width
                title: model.name
                subtitle: model.playing
                subtitleSize: UIConstants.FONT_XSMALL

                onClicked: {
                    appWindow.pageStack.push(showtimesView,
                                             {
                                                 cinemaName: model.name,
                                                 cinemaInfo: model.info,
                                                 showtimesModel: theaterModel.showtimes(index)
                                             })
                }
            }

            Connections {
                target: list.visibleArea
                onYPositionChanged: {
                    if (contentYPos < 0 &&
                            !showShowtimesFilter &&
                            (list.moving && !list.flicking)) {
                        showShowtimesFilter = true
                        listTimer.start()
                    }
                }
            }

            Timer {
                id: listTimer
                interval: 3000
                onTriggered: {
                    showShowtimesFilter = searchInput.text
                    list.positionViewAtBeginning(0, ListView.Beginning)
                }
            }
        }

        ScrollDecorator {
            flickableItem: list
        }

        BusyIndicator {
            id: busyIndicator
            visible: true
            running: true
            platformStyle: BusyIndicatorStyle { size: 'large' }
            anchors.centerIn: parent
        }

        NoContentItem {
            id: noTheaterResults
            anchors {
                fill: parent
                margins: UIConstants.DEFAULT_MARGIN
            }
            text: (location ?
                       //: Message shown when no results are found for a given location
                       qsTr('No results for %1').arg(location) :
                       //: Message shown when no results are found for the automatic location
                       qsTr('No results for your location'))
            visible: list.model.count === 0
        }

        states: [
            State {
                name: 'Ready'
                PropertyChanges { target: busyIndicator; running: false; visible: false }
                PropertyChanges { target: list; visible: true }
                PropertyChanges { target: noTheaterResults; visible: false}
            },
            State {
                name: 'Loading'
                PropertyChanges { target: busyIndicator; running: true; visible: true }
                PropertyChanges { target: list; visible: false }
                PropertyChanges { target: noTheaterResults; visible: false }
            },
            State {
                name: 'Failed'
                PropertyChanges { target: busyIndicator; running: false; visible: false }
                PropertyChanges { target: list; visible: false }
                PropertyChanges { target: noTheaterResults; visible: true }
            }

        ]
    }
}
