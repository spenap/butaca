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
import "butacautils.js" as BUTACA
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Component {
    id: filmographyView

    Page {
        tools: commonTools
        orientationLock: PageOrientation.LockPortrait

        property string person: ''
        property string personId: ''

        Item {
            id: filmographyContent
            anchors.fill: parent
            anchors.topMargin: appWindow.inPortrait?
                                   UIConstants.HEADER_DEFAULT_TOP_SPACING_PORTRAIT :
                                   UIConstants.HEADER_DEFAULT_TOP_SPACING_LANDSCAPE

            FilmographyModel {
                id: filmographyModel
                params: personId
                onStatusChanged: {
                    if (status == XmlListModel.Ready) {
                        filmographyContent.state = 'Ready'
                    }
                }
            }

            BusyIndicator {
                id: busyIndicator
                visible: true
                running: true
                platformStyle: BusyIndicatorStyle { size: 'large' }
                anchors.centerIn: parent
            }

            ListView {
                id: list
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick
                model: filmographyModel
                header: ButacaHeader {
                    text: qsTr("%1's filmography").arg(person)
                    showDivider: false
                }
                delegate: CustomListDelegate {
                    onClicked: { pageStack.push(movieView,
                                                { detailId: tmdbId,
                                                  viewType: BUTACA.MOVIE })}
                }

                section.property: 'name'
                section.delegate: ListSectionDelegate { sectionName: section }
            }

            ScrollDecorator {
                flickableItem: list
            }

            states: [
                State {
                    name: 'Ready'
                    PropertyChanges { target: busyIndicator; running: false; visible: false }
                    PropertyChanges { target: list; visible: true }
                }
            ]
        }
    }
}
