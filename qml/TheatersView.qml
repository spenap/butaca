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

Component {
    id: theatersView

    Page {
        tools: commonTools
        orientationLock: PageOrientation.LockPortrait

        Component.onCompleted: {
            if (!list.model) {
                controller.fetchTheaters(BUTACA.SHOWTIMES_LOCATION)
            }
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

            ListView {
                id: list
                anchors.fill: parent
                model: theaterModel
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

            states: [
                State {
                    name: 'Ready'
                    when: theaterModel !== undefined
                    PropertyChanges  { target: busyIndicator; running: false; visible: false }
                    PropertyChanges  { target: list; visible: true }
                }
            ]
        }
    }
}

