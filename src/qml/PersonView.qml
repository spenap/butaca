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
import 'constants.js' as UIConstants

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
                //: Open homepage
                text: qsTr('btc-open-homepage')
                onClicked: Qt.openUrlExternally(currentItem().homepage)
                visible: false
            }
            MenuItem {
                id: tmdbEntry
                //: View in TMDb
                text: qsTr('btc-open-tmdb')
                onClicked: Qt.openUrlExternally(currentItem().url)
            }
            MenuItem {
                id: imdbEntry
                //: View in IMDb
                text: qsTr('btc-open-imdb')
                onClicked: Qt.openUrlExternally(BUTACA.IMDB_BASE_URL + currentItem().imdbId)
                visible: false
            }
        }
    }
    tools: ButacaToolBar { id: toolBar; state: 'ContentNotReady'; menu: detailedViewMenu }

    Item {
        id: content
        anchors.fill: parent

        PersonModel {
            id: personModel
            params: detailId
            onStatusChanged: {
                if (status === XmlListModel.Ready) {
                    content.state = 'Ready'
                }
            }
        }

        ListView {
            id: list
            anchors.fill: parent
            interactive: false
            model: personModel
            delegate: PersonDelegate { }
        }

        BusyIndicator {
            id: busyIndicator
            visible: running
            running: personModel.status === XmlListModel.Loading
            platformStyle: BusyIndicatorStyle { size: 'large' }
            anchors.centerIn: parent
        }

        states: [
            State {
                name: 'Ready'
                PropertyChanges { target: toolBar; content: BUTACA.favoriteFromPerson(currentItem()) }
            }
        ]
    }
}
