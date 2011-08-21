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
    id: detailedViewWrapper

    Page {
        id: detailedView
        orientationLock: PageOrientation.LockPortrait

        property string detailId
        property int viewType: -1

        function currentItem() {
            return list.model.get(list.currentIndex)
        }

        Menu {
            id: detailedViewMenu
            MenuLayout {
                MenuItem {
                    id: homepageEntry
                    text: 'Open homepage'
                    onClicked: helper.openUrl(currentItem().homepage)
                    visible: false
                }
                MenuItem {
                    id: tmdbEntry
                    text: 'View in TMDb'
                    onClicked: helper.openUrl(currentItem().url)
                }
                MenuItem {
                    id: imdbEntry
                    text: 'View in IMDb'
                    onClicked: helper.openUrl(BUTACA.IMDB_BASE_URL + currentItem().imdbId)
                    visible: false
                }
            }
        }
        tools: ButacaToolBar { id: toolBar; state: 'ContentNotReady'; menu: detailedViewMenu }

        width: parent.width; height: parent.height

        Item {
            id: content
            anchors.fill: parent

            PersonModel {
                id: personModel
                onStatusChanged: {
                    if (content.state == 'FetchingPerson' &&
                            status == XmlListModel.Ready) {
                        content.state = 'Ready'
                    }
                }
            }

            SingleMovieModel {
                id: movieModel
                onStatusChanged: {
                    if (content.state == 'FetchingMovie' &&
                            status == XmlListModel.Ready) {
                        content.state = 'Ready'
                    }
                }
            }

            Component { id: movieDelegateWrapper; SingleMovieDelegate { } }
            Component { id: personDelegateWrapper; PersonDelegate { } }

            ListView {
                id: list
                anchors.fill: parent
                interactive: false
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
                    name: 'FetchingMovie'
                    when: viewType == BUTACA.MOVIE
                    PropertyChanges {
                        target: movieModel; restoreEntryValues: false;
                        params: detailId }
                    PropertyChanges {
                        target: list; restoreEntryValues: false;
                        model: movieModel; delegate: movieDelegateWrapper }
                },
                State {
                    name: 'FetchingPerson'
                    when: viewType == BUTACA.PERSON
                    PropertyChanges {
                        target: personModel; restoreEntryValues: false;
                        params: detailId }
                    PropertyChanges { target: list; restoreEntryValues: false;
                        model: personModel; delegate: personDelegateWrapper }
                },
                State {
                    name: 'Ready'
                    PropertyChanges { target: busyIndicator; running: false; visible: false }
                    PropertyChanges { target: list; visible: true }
                    PropertyChanges {
                        target: toolBar
                        content: viewType == BUTACA.MOVIE ?
                                     BUTACA.favoriteFromMovie(currentItem()) :
                                     BUTACA.favoriteFromPerson(currentItem())
                    }
                }
            ]
        }
    }
}
