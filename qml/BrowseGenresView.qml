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

        MultipleMoviesView { id: multipleMovieView }

        ButacaHeader {
            id: header
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

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
                delegate: ListDelegate {
                    /* More indicator */
                    Item {
                        id: viewDetails
                        width: moreIndicator.width + 10
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right

                        CustomMoreIndicator {
                            id: moreIndicator
                            anchors.centerIn: parent
                        }
                    }

                    onClicked: {
                        pageStack.push(multipleMovieView , {genre: genreId, genreName: title})
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

