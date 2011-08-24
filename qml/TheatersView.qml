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
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "butacautils.js" as BUTACA
import "storage.js" as Storage

Page {
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    property string location

    onStatusChanged: {
        if (status == PageStatus.Active) {
            Storage.initialize()
            location = Storage.getSetting('location')
            if (list.model === undefined ||
                    location != controller.currentLocation()) {
                controller.fetchTheaters(location)
                theatersContent.state = 'Loading'
            }
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
        anchors.fill: parent
        anchors {
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
            bottomMargin: UIConstants.DEFAULT_MARGIN
        }

        ButacaHeader {
            id: header
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            text: 'On theaters'
        }

        Item {
            id: theatersContent
            anchors { top: header.bottom; left: parent.left; right: parent.right; bottom:  parent.bottom }
            anchors.margins: UIConstants.DEFAULT_MARGIN
            state: 'Loading'

            ListView {
                id: list
                anchors.fill: parent
                clip: true
                delegate: ListDelegate { }

                section.property: 'theaterName'
                section.delegate: ListSectionDelegate { sectionName: section }
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
                text: 'No results for ' + (location ? location : 'your location')
                visible: list.model !== undefined
            }

            states: [
                State {
                    name: 'Ready'
                    PropertyChanges { target: busyIndicator; running: false; visible: false }
                    PropertyChanges { target: list; visible: true; model: theaterModel }
                    PropertyChanges { target: noTheaterResults; visible: false}
                },
                State {
                    name: 'Loading'
                    PropertyChanges { target: busyIndicator; running: true; visible: true }
                    PropertyChanges { target: list; visible: false; model: undefined }
                    PropertyChanges { target: noTheaterResults; visible: false }
                },
                State {
                    name: 'Failed'
                    PropertyChanges { target: busyIndicator; running: false; visible: false }
                    PropertyChanges { target: list; visible: false; model: undefined }
                    PropertyChanges { target: noTheaterResults; visible: true }
                }

            ]
        }
    }
}
