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
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "butacautils.js" as BUTACA
import "storage.js" as Storage

Page {
    id: welcomeView
    Component.onCompleted: {
        theme.inverted = true

        Storage.initialize()
        var favorites = Storage.getFavorites()
        for (var i = 0; i < favorites.length; i ++) {
            favoritesModel.append(favorites[i])
        }
    }

    Menu {
        id: welcomeMenu
        MenuLayout {
            MenuItem {
                id: settingsEntry
                text: 'Settings'
                onClicked: appWindow.pageStack.push(settingsView)
            }
            MenuItem {
                id: aboutEntry
                text: 'About'
                onClicked: appWindow.pageStack.push(aboutView)
            }
        }
    }
    tools: ToolBarLayout {
        ToolIcon {
            id: menuListIcon
            iconId: 'toolbar-view-menu'
            onClicked: (welcomeMenu.status == DialogStatus.Closed) ?
                           welcomeMenu.open() : welcomeMenu.close()
            anchors.right: parent.right
        }
    }

    orientationLock: PageOrientation.LockPortrait

    ButacaToolBar { id: commonTools }
    BrowseGenresView { id: browseView }
    SearchView { id: searchView }
    DetailedView { id: movieView }
    DetailedView { id: personView }
    TheatersView { id: theatersView }
    SettingsView { id: settingsView }
    AboutView { id: aboutView }

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

    Component {
        id: menuDelegate
        CustomListDelegate {
            onClicked: {
                switch (action) {
                case 0:
                    appWindow.pageStack.push(browseView)
                    break;
                case 1:
                    appWindow.pageStack.push(theatersView)
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
        anchors { top: parent.top; left: parent.left; right: parent.right }
        anchors.topMargin: appWindow.inPortrait?
                               UIConstants.HEADER_DEFAULT_TOP_SPACING_PORTRAIT :
                               UIConstants.HEADER_DEFAULT_TOP_SPACING_LANDSCAPE
        height: 0.43 * parent.height
        model: menuModel
        clip: true
        interactive: false
        delegate: menuDelegate
        header: ButacaHeader {
            text: 'Enjoy the show!'
        }
    }

    ListModel {
        id: favoritesModel
    }

    Item {
        id: favorites
        anchors { top: list.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        anchors {
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }

        GridView {
            id: view
            anchors.fill: parent
            clip: true
            cellWidth: 220
            cellHeight: 220

            model: favoritesModel
            delegate: favoriteDelegate
        }

        ScrollDecorator {
            flickableItem: view
        }

        NoContentItem {
            anchors.fill: parent
            text: 'Mark content as favorite'
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
                    anchors.topMargin: UIConstants.DEFAULT_MARGIN / 2
                    anchors.horizontalCenter: favoriteIcon.horizontalCenter
                    text: title
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    elide: Text.ElideRight
                    width: parent.width
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (type == BUTACA.MOVIE) {
                            appWindow.pageStack.push(movieView,
                                                     { detailId: id,
                                                       viewType: BUTACA.MOVIE })
                        } else {
                            appWindow.pageStack.push(personView,
                                                     { detailId: id,
                                                       viewType: BUTACA.PERSON })
                        }
                    }
                }
            }
        }
    }

    function addFavorite(content) {
        var insertId = Storage.saveFavorite(content)
        content.rowId = insertId
        favoritesModel.append(content)
    }

    function removeFavorite(content) {
        var idx = indexOf(content)
        removeFavoriteAt(idx)
    }

    function removeFavoriteAt(idx) {
        if (idx != -1) {
            var rowId = favoritesModel.get(idx).rowId
            favoritesModel.remove(idx)
            Storage.removeFavorite(rowId)
        }
    }

    function indexOf(content) {
        for (var i = 0; i < favoritesModel.count; i ++) {
            if (favoritesModel.get(i).id == content.id &&
                    favoritesModel.get(i).type == content.type) {
                return i
            }
        }
        return -1
    }
}
