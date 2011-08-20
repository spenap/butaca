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
import "butacautils.js" as BUTACA

Component {
    id: multipleMoviesPage

    Page {
        tools: commonTools
        orientationLock: PageOrientation.LockPortrait

        property string searchTerm: ''
        property string genre: ''
        property string genreName:  ''

        ButacaHeader {
            id: headerText
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            text: genreName
        }

        Item {
            id: moviesContent
            anchors { top: headerText.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
            anchors.margins: 20

            MultipleMoviesModel {
                id: moviesModel
                apiMethod: searchTerm ? BUTACA.TMDB_MOVIE_SEARCH : BUTACA.TMDB_MOVIE_BROWSE
                params: searchTerm ? searchTerm : BUTACA.getBrowseCriteria(genre)
                onStatusChanged: {
                    if (status == XmlListModel.Ready) {
                        moviesContent.state = 'Ready'
                    }
                }
            }

            ListView {
                id: list
                anchors.fill: parent
                clip: true
                model: moviesModel
                delegate: MultipleMoviesDelegate {}
            }

            NoContentItem {
                id: noResults
                anchors.fill: parent
                text: 'No content found'
                visible: false
            }

            BusyIndicator {
                id: busyIndicator
                visible: true
                running: true
                platformStyle: BusyIndicatorStyle { size: 'large' }
                anchors.centerIn: parent
            }

            ScrollDecorator {
                flickableItem: list
            }

            states: [
                State {
                    name: 'Ready'
                    PropertyChanges  { target: busyIndicator; running: false; visible: false }
                    PropertyChanges  { target: list; visible: true }
                    PropertyChanges  { target: noResults; visible: moviesModel.count == 0 }
                }
            ]
        }
    }
}
