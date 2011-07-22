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

        ButacaHeader {
            id: header
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

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
                enabled: searchInput.text !== ''
                onClicked: {
                    if (searchCategory.checkedButton == movieSearch) {
                        searchResults.state = 'MovieSearch'
                    } else if (searchCategory.checkedButton == peopleSearch) {
                        searchResults.state = 'PeopleSearch'
                    } else {
                        helper.openUrl('http://www.google.com/movies?q=' + searchInput.text)
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
            state: 'Waiting'

            MultipleMoviesModel {
                id: moviesModel
                source: ''
                onStatusChanged: {
                    if (status == XmlListModel.Ready &&
                            searchResults.state == 'MovieSearch') {
                        searchResults.state = 'MovieSearchFinished'
                    }
                }
            }

            PeopleModel {
                id: peopleModel
                source: ''
                onStatusChanged: {
                    if (status == XmlListModel.Ready &&
                            searchResults.state == 'PeopleSearch') {
                        searchResults.state = 'PeopleSearchFinished'
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

            NoContentItem {
                id: noResults
                anchors.fill: parent
                text: 'No results found'
                visible: false
            }

            BusyIndicator {
                id: busyIndicator
                visible: false
                platformStyle: BusyIndicatorStyle { size: 'large' }
                anchors.centerIn: parent
            }

            ScrollDecorator {
                id: scrollDecorator
                flickableItem: resultList
            }

            states: [
                State {
                    name: 'Waiting'
                    when: searchInput.activeFocus
                    PropertyChanges  { target: moviesModel; restoreEntryValues: false; source: '' }
                    PropertyChanges  { target: peopleModel; restoreEntryValues: false; source: '' }
                    PropertyChanges { target: noResults; restoreEntryValues: false; visible: false }
                    PropertyChanges { target: busyIndicator; restoreEntryValues: false; visible: false; running: false }
                },
                State {
                    name: 'PeopleSearch'
                    PropertyChanges { target: peopleModel;
                        restoreEntryValues: false;
                        source: BUTACA.getTMDbSource(BUTACA.TMDB_PERSON_SEARCH, searchTerm) }
                    PropertyChanges  { target: resultList; restoreEntryValues: false;
                        model: peopleModel; delegate: peopleDelegate }
                    PropertyChanges  { target: moviesModel; restoreEntryValues: false; source: '' }
                    PropertyChanges { target: busyIndicator; visible: true; running: true }
                },
                State {
                    name: 'PeopleSearchFinished'
                    PropertyChanges { target: noResults; visible: peopleModel.count == 0 }
                },
                State {
                    name: 'MovieSearch'
                    PropertyChanges { target: moviesModel;
                        restoreEntryValues: false;
                        source: BUTACA.getTMDbSource(BUTACA.TMDB_MOVIE_SEARCH, searchTerm) }
                    PropertyChanges  { target: resultList; restoreEntryValues: false;
                        model: moviesModel; delegate: moviesDelegate }
                    PropertyChanges  { target: peopleModel; restoreEntryValues: false; source: '' }
                    PropertyChanges { target: busyIndicator; visible: true; running: true }
                },
                State {
                    name: 'MovieSearchFinished'
                    PropertyChanges { target: noResults; visible: moviesModel.count == 0 }
                }
            ]
        }
    }
}
