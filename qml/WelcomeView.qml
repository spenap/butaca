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
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "butacautils.js" as BUTACA

Page {
    id: welcomeView
    Component.onCompleted: {
        theme.inverted = true
    }

    orientationLock: PageOrientation.LockPortrait

    ButacaToolBar { id: commonTools }
    BrowseGenresView { id: browseView }
    SearchView { id: searchView }
    ShowtimesView { id: showtimesView }
    SingleMovieView { id: singleMovieView }
    PersonView { id: personView }

    /* Model containing the actions: browse, search and shows */
    ListModel {
        id: menuModel

        ListElement {
            title: 'Movie genres'
            subtitle: 'Explore movie genres'
            action: 0
        }

        ListElement {
            title: 'Cinemas'
            subtitle: 'What\'s on cinemas near you'
            action: 1
        }

        ListElement {
            title: 'Search'
            subtitle: 'Search people, movies and shows'
            action: 2
        }
    }

    ButacaHeader {
        id: mainHeader
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        text: 'Enjoy the show!'
    }

    Component {
        id: menuDelegate
        ListDelegate {
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
                    helper.openUrl("http://www.google.com/movies")
                    break;
                case 2:
                    appWindow.pageStack.push(searchView)
                    break;
                }
            }
        }
    }

    ListView {
        id: list
        anchors {top: mainHeader.bottom; left: parent.left; right: parent.right }
        anchors.margins: 20
        width: parent.width;
        height: parent.height / 3
        model: menuModel
        interactive: false
        delegate: menuDelegate
    }

    ListModel {
        id: favoritesModel
    }

    Item {
        id: favorites
        anchors { top: list.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        anchors.margins: 20

        GridView {
            id: view
            anchors.fill: parent
            clip: true
            cellWidth: 200
            cellHeight: 200

            model: favoritesModel
            delegate: favoriteDelegate
        }

        NoContentItem {
            anchors.fill: parent
            text: 'Mark content as favorite'
            opacity: 0.5
            visible: favoritesModel.count == 0
        }

        Component {
            id: favoriteDelegate
            Item {
                width: 200
                height: 200

                Image {
                    id: favoriteIcon
                    source: icon ? icon :
                                        (type == BUTACA.MOVIE ?
                                             'images/movie-placeholder.svg' :
                                             'images/person-placeholder.svg')
                    width: 95; height: 140
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    onStatusChanged: {
                        if (favoriteIcon.status == Image.Error) {
                            favoriteIcon.source = (type == BUTACA.MOVIE ?
                                                       'images/movie-placeholder.svg' :
                                                       'images/person-placeholder.svg')
                        }
                    }
                }

                Text {
                    anchors.top: favoriteIcon.bottom;
                    anchors.topMargin: UIConstants.DEFAULT_MARGIN
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: title
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (type == BUTACA.MOVIE) {
                            appWindow.pageStack.push(singleMovieView, { movieId: id})
                        } else {
                            appWindow.pageStack.push(personView, { person: id })
                        }
                    }
                }
            }
        }
    }

    function addFavorite(content) {
        favoritesModel.append(content)
    }

    function removeFavorite(content) {
        var idx = indexOf(content)
        if (idx != -1) {
            favoritesModel.remove(idx)
        }
    }

    function removeFavoriteAt(content, idx) {
        if (idx != -1) {
            favoritesModel.remove(idx)
        }
    }

    function indexOf(content) {
        for (var i = 0; i < favoritesModel.count; i ++) {
            if (favoritesModel.get(i).title === content.title) {
                return i
            }
        }
        return -1
    }
}
