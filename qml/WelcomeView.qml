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
    id: welcomeView

    Page {
        orientationLock: PageOrientation.LockPortrait

        ButacaToolBar { id: commonTools }
        BrowseGenresView { id: browseView }
        SearchView { id: searchView }
        ShowtimesView { id: showtimesView }

        /* Model containing the actions: browse, search and shows */
        ListModel {
            id: menuModel

            ListElement {
                title: 'Movie genres'
                subtitle: ''
                action: 0
            }

            ListElement {
                title: 'Cinemas'
                subtitle: ''
                action: 1
            }

            ListElement {
                title: 'Search'
                subtitle: ''
                action: 2
            }
        }

        ButacaHeader {
            id: mainHeader
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            text: 'Enjoy the show!'
        }

        ListView {
            id: list
            anchors {top: mainHeader.bottom; left: parent.left; right: parent.right }
            anchors.margins: 20
            width: parent.width; height: parent.height / 2
            model: menuModel
            interactive: false
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
                    switch (action) {
                    case 0:
                        appWindow.pageStack.push(browseView)
                        break;
                    case 1:
                        appWindow.pageStack.push(showtimesView)
                        break;
                    case 2:
                        appWindow.pageStack.push(searchView)
                        break;
                    }
                }
            }
        }
    }
}
