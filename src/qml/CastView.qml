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
    id: peopleView

    Page {
        tools: commonTools
        orientationLock: PageOrientation.LockPortrait

        property string movie: ''
        property string movieId:  ''

        Item {
            id: castContent
            anchors.fill: parent
            anchors.topMargin: appWindow.inPortrait?
                                   UIConstants.HEADER_DEFAULT_TOP_SPACING_PORTRAIT :
                                   UIConstants.HEADER_DEFAULT_TOP_SPACING_LANDSCAPE

            CastModel {
                id: castModel
                params: movieId
                onStatusChanged: {
                    if (status == XmlListModel.Ready) {
                        castContent.state = 'Ready'
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
                model: castModel
                header: ButacaHeader {
                    //: Full cast in %1
                    text: qsTr('btc-full-cast').arg(movie)
                    showDivider: false
                }
                delegate: CustomListDelegate {
                    onClicked: { pageStack.push(personView,
                                                { detailId: personId,
                                                  viewType: BUTACA.PERSON })}
                }

                section.property: 'department'
                section.delegate: ListSectionDelegate {
                    // Translate the section name. See CastModel.qml for translations
                    sectionName: qsTranslate("CastModel", section)
                }
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
