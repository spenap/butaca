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
import com.nokia.extras 1.1
import 'constants.js' as UIConstants
import 'butacautils.js' as BUTACA
import 'storage.js' as Storage

Page {
    id: welcomeView

    orientationLock: PageOrientation.LockPortrait

    Component.onCompleted: {
        Storage.initialize()
        var favorites = Storage.getFavorites()
        for (var i = 0; i < favorites.length; i ++) {
            favoritesModel.append(favorites[i])
        }

        // Due to a limitation in the ListModel, translating its elements
        // must be done this way

        //: Movie genres
        menuModel.get(0).title = qsTr('btc-browse-genres')
        //: Explore movie genres
        menuModel.get(0).subtitle = qsTr('btc-browse-genres-description')
        //: Showtimes
        menuModel.get(1).title = qsTr('btc-showtimes')
        //: What\'s on cinemas near you
        menuModel.get(1).subtitle = qsTr('btc-showtimes-description')
        //: Search
        menuModel.get(2).title = qsTr('btc-search')
        //: Search people, movies and shows
        menuModel.get(2).subtitle = qsTr('btc-search-description')
    }

    tools: ToolBarLayout {
        ToolIcon {
            id: menuListIcon
            iconId: 'toolbar-view-menu'
            onClicked: (welcomeMenu.status === DialogStatus.Closed) ?
                           welcomeMenu.open() : welcomeMenu.close()
            anchors.right: parent.right
        }
    }

    Menu {
        id: welcomeMenu
        MenuLayout {
            MenuItem {
                id: settingsEntry
                //: Settings
                text: qsTr('btc-settings')
                onClicked: appWindow.pageStack.push(settingsView)
            }
            MenuItem {
                id: aboutEntry
                //: About
                text: qsTr('btc-about')
                onClicked: appWindow.pageStack.push(aboutView)
            }
        }
    }

    Component { id: browseView; BrowseView { } }

    Component { id: searchView; SearchView { } }

    Component { id: showtimesView; TheatersView { } }

    Component { id: settingsView; SettingsView { } }

    Component { id: movieView; DetailedView { } }

    Component { id: personView; DetailedView { } }

    Component { id: aboutView; AboutView { } }

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

        ListElement {
            title: 'Lists'
            subtitle: 'Favorites, watchlists and others'
            action: 3
        }
    }

    ListView {
        id: list
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: (appWindow.inPortrait ?
                     UIConstants.HEADER_DEFAULT_HEIGHT_PORTRAIT :
                     UIConstants.HEADER_DEFAULT_HEIGHT_LANDSCAPE) +
                    menuModel.count * UIConstants.LIST_ITEM_HEIGHT_DEFAULT
        model: menuModel
        clip: true
        interactive: false
        delegate: CustomListDelegate {
            title: model.title
            subtitle: model.subtitle

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
                default:
                    console.debug('Action not available')
                    break
                }
            }
        }
        header: Header {
            //: Enjoy the show!
            text: qsTr('btc-welcome-header')
        }
    }

    Item {
        id: favorites
        anchors { top: list.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        anchors {
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }

        ListModel {
            id: favoritesModel
        }

        GridView {
            id: view
            anchors.fill: parent
            clip: true
            cellWidth: 140
            cellHeight: 210

            model: favoritesModel
            delegate: FavoriteDelegate {
                source: icon ? icon :
                               (type == BUTACA.MOVIE ?
                                    'qrc:/resources/movie-placeholder.svg' :
                                    'qrc:/resources/person-placeholder.svg')
                text: title
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

        ScrollDecorator {
            flickableItem: view
        }

        NoContentItem {
            anchors.fill: parent
            //: Mark content as favorite
            text: qsTr('btc-mark-favorite')
            visible: favoritesModel.count == 0
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
