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
import "butacautils.js" as BUTACA

Component {
    id: searchView

    Page {
        tools: commonTools

        property alias searchTerm: searchInput.text

        MultipleMoviesView { id: multipleMoviesView }
        PeopleView { id: peopleView }

        Text {
            id: header
            anchors.top: parent.top
            anchors.margins: 20
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: 40
            text: 'Search'
        }

        Row {
            id: searchArea
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            anchors.margins: 20
            spacing: 10

            TextField {
                id: searchInput
                placeholderText: "Enter search terms"
                width: parent.width - searchButton.width
            }
            Button {
                id: searchButton
                text: 'Search'
                width: 100
                onClicked: {
                    if (searchCategory.checkedButton == movieSearch) {
                        searchResults.state = 'MovieSearch'
                    } else if (searchCategory.checkedButton == peopleSearch) {
                        searchResults.state = 'PeopleSearch'
                    }
                }
            }
        }

        ButtonRow {
            id: searchCategory
            anchors { top: searchArea.bottom; left: parent.left; right: parent.right }
            anchors.margins: 20

            Button {
                id: movieSearch
                text: 'Movies'
            }
            Button {
                id: peopleSearch
                text: 'People'
            }
            Button {
                id: showSearch
                text: 'Shows'
            }
        }

        Item {
            id: searchResults
            anchors { top: searchCategory.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
            anchors.margins: 20

            MultipleMoviesModel {
                id: moviesModel
                source: ''
                onStatusChanged: {
                    if (status == XmlListModel.Ready) {
                        busyIndicator.visible = false
                        busyIndicator.running = false
                    }
                }
            }

            PeopleModel {
                id: peopleModel
                source: ''
                onStatusChanged: {
                    if (status == XmlListModel.Ready) {
                        busyIndicator.visible = false
                        busyIndicator.running = false
                    }
                }
            }

            PeopleDelegate { id: peopleDelegate }
            MultipleMoviesDelegate { id: moviesDelegate }

            ListView {
                id: resultList
                anchors.fill: parent
                clip: true
                model: undefined
            }

            BusyIndicator {
                id: busyIndicator
                visible: true
                running: true
                platformStyle: BusyIndicatorStyle { size: 'large' }
                anchors.centerIn: parent
            }

            ScrollDecorator {
                id: scrollDecorator
                flickableItem: resultList
            }

            states: [
                State {
                    name: 'PeopleSearch'
                    PropertyChanges  { target: resultList; model: peopleModel; delegate: peopleDelegate }
                    PropertyChanges { target: peopleModel; source: BUTACA.getTMDbSource(BUTACA.TMDB_PERSON_SEARCH, searchTerm) }
                    PropertyChanges  { target: moviesModel; source: '' }
                    PropertyChanges { target: busyIndicator; visible: true; running: true }
                },
                State {
                    name: 'MovieSearch'
                    PropertyChanges  { target: resultList; model: moviesModel; delegate: moviesDelegate }
                    PropertyChanges { target: moviesModel; source: BUTACA.getTMDbSource(BUTACA.TMDB_MOVIE_SEARCH, searchTerm) }
                    PropertyChanges  { target: peopleModel; source: '' }
                    PropertyChanges { target: busyIndicator; visible: true; running: true }
                }
            ]
        }
    }
}
