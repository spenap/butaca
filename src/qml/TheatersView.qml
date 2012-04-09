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
import com.nokia.extras 1.0
import 'constants.js' as UIConstants
import "butacautils.js" as BUTACA
import "storage.js" as Storage

Page {
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    property string location
    property bool showShowtimesFilter
    property real contentYPos: list.visibleArea.yPosition *
                                   Math.max(list.height, list.contentHeight)

    onStatusChanged: {
        if (status == PageStatus.Active) {
            Storage.initialize()
            location = Storage.getSetting('location')
            if (list.model.count === 0 ||
                    location != controller.currentLocation()) {
                controller.fetchTheaters(location)
                theatersContent.state = 'Loading'
            }
        } else if (status == PageStatus.Activating) {
            theaterModel.setFilterWildcard('')
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
            //: Search
            placeholderText: qsTr('btc-search')
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
            header: Header {
                //: On theaters
                text: qsTr('btc-theaters')
                showDivider: false
                visible: !showShowtimesFilter
            }
            delegate: MyListDelegate {
                title: model.title

                pressable: false
            }

            section.property: 'theaterName'
            section.delegate: ListSectionDelegate { sectionName: section }

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
                    showShowtimesFilter = false
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
            anchors.fill: parent
            text: (location ?
                       //: No results for %1
                       qsTr('btc-no-results-given-location').arg(location) :
                       //: No results for your location
                       qsTr('btc-no-results-automatic-location'))
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
