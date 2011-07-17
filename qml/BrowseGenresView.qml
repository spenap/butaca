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
import com.meego 1.0
import com.nokia.extras 1.0

Component {
    id: browseGenresView

    Page {
        tools: commonTools

        Text {
            id: header
            anchors.top: parent.top
            anchors.margins: 20
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: 40
            text: 'Movie genres'
        }

        Item {
            id: genresContent
            anchors { top: header.bottom; left: parent.left; right: parent.right; bottom:  parent.bottom }
            anchors.margins: 20

            GenresModel {
                id: genresModel
                onStatusChanged: {
                    if (status == XmlListModel.Ready) {
                        genresContent.state = 'Ready'
                    }
                }
            }

            ListView {
                id: list
                model: genresModel
                anchors.fill: parent
                clip: true
                delegate: GenresDelegate { }
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
                    PropertyChanges  { target: busyIndicator; running: false; visible: false }
                    PropertyChanges  { target: list; visible: true }
                }
            ]
        }
    }
}

