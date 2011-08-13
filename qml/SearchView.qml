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
        orientationLock: PageOrientation.LockPortrait

        property alias searchTerm: searchInput.text

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
                width: parent.width - searchButton.width - 10

                Image {
                    id: clearText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: searchInput.text ?
                                'image://theme/icon-m-input-clear' :
                                'image://theme/icon-m-common-search'
                }

                MouseArea {
                    id: searchInputMouseArea
                    anchors.fill: clearText
                    onClicked: {
                        searchInput.text = ''
                        searchResults.state = 'Waiting'
                    }
                }
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
                        searchResults.state = 'SearchFinished'
                    }
                }
            }

            PeopleModel {
                id: peopleModel
                source: ''
                onStatusChanged: {
                    if (status == XmlListModel.Ready &&
                            searchResults.state == 'PeopleSearch') {
                        searchResults.state = 'SearchFinished'
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
                text: '«Shows» uses the web browser'
                visible: true
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
                    name: 'SearchFinished'
                    PropertyChanges { target: noResults;
                        visible: resultList.model.count == 0;
                        text: 'No results found'
                    }
                }
            ]
        }
    }
}
