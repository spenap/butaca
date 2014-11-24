/**************************************************************************
 *   Butaca
 *   Copyright (C) 2011 - 2012 Simon Pena <spena@igalia.com>
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

import QtQuick 2.0
import Sailfish.Silica 1.0
import 'butacautils.js' as Util
import 'moviedbwrapper.js' as TMDB
import 'storage.js' as Storage

Page {
    id: welcomeView

    allowedOrientations: Orientation.Portrait

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: content.height

        Component.onCompleted: {
            Storage.initialize()
            var favorites = Storage.getFavorites()
            for (var i = 0; i < favorites.length; i ++) {
                favoritesModel.append(favorites[i])
            }

            Util.asyncQuery({
                                url: TMDB.configuration_getUrl({ app_locale: appLocale }),
                                response_action: 0
                            },
                            handleMessage)
        }

        PullDownMenu {
            id: welcomeMenu
            MenuItem {
                id: settingsEntry
                //: Title for the settings entry in the main page object menu
                text: qsTr('Settings')
                onClicked: appWindow.pageStack.push(settingsView)
            }
            MenuItem {
                id: aboutEntry
                //: Title for the about entry in the main page object menu
                text: qsTr('About')
                onClicked: appWindow.pageStack.push(aboutView)
            }
        }

        Component { id: browseView; GenresView { } }

        Component { id: searchView; SearchView { } }

        Component { id: showtimesView; TheatersView { } }

        Component { id: settingsView; SettingsView { } }

        Component { id: movieView; MovieView { } }

        Component { id: tvView; TvView { } }

        Component { id: personView; PersonView { } }

        Component { id: aboutView; AboutView { } }

        Component { id: listsView; ListsView { } }


        ListModel {
            id: menuModel

            ListElement {
                title: QT_TR_NOOP('Movie genres')
                subtitle: QT_TR_NOOP('Explore movie genres')
                action: 0
            }

            // FIXME: Backend currently doesn't support this
//            ListElement {
//                title: QT_TR_NOOP('Showtimes')
//                subtitle: QT_TR_NOOP('What\'s on in cinemas near you')
//                action: 1
//            }

            ListElement {
                title: QT_TR_NOOP('Search')
                subtitle: QT_TR_NOOP('Search movies and celebrities')
                action: 2
            }

            ListElement {
                title: QT_TR_NOOP('Lists')
                subtitle: QT_TR_NOOP('Favorites and watchlist')
                action: 3
            }
        }

        Column {
            id: content
            width: parent.width

            PageHeader {
                id: header
                //: Shown in the main view header
                title: qsTr('Enjoy the show!')
            }

            Repeater {
                id: mainMenuList
                width: parent.width
//                height: menuModel.count * UIConstants.LIST_ITEM_HEIGHT_DEFAULT
                model: menuModel
                clip: true
                delegate: MyListDelegate {
                    width: parent.width
                    title: qsTr(model.title)
                    subtitle: qsTr(model.subtitle)

                    onClicked: {
                        switch (action) {
                        case 0:
                            pageStack.push(browseView)
                            break;
                        case 1:
                            pageStack.push(showtimesView)
                            break;
                        case 2:
                            pageStack.push(searchView)
                            break;
                        case 3:
                            pageStack.push(listsView, { headerText: model.title })
                            break;
                        default:
                            console.debug('Action not available')
                            break
                        }
                    }
                }
            }

            Grid {
                id: view
                width: parent.width
                clip: true
                columns: 3

                Repeater {
                    model: favoritesModel
                    delegate: FavoriteDelegate {
                        source: icon ? icon :
                                       (type == Util.MOVIE ?
                                            'qrc:/resources/movie-placeholder.svg' :
                                            'qrc:/resources/person-placeholder.svg')
                        text: title
                        onClicked: {
                            if (type == Util.MOVIE) {
                                appWindow.pageStack.push(movieView,
                                                         { tmdbId: id,
                                                             loading: true })
                            } else if (type == Util.TV) {
                                appWindow.pageStack.push(tvView,
                                                         { tmdbId: id,
                                                             loading: true })
                            } else {
                                appWindow.pageStack.push(personView,
                                                         { tmdbId: id,
                                                             loading: true })
                            }
                        }
                    }
                }
            }

            ViewPlaceholder {
                //: Shown as a placeholder in the favorites area of the main view while no favorites are there
                text: qsTr('Your favorite content will appear here')
                enabled: favoritesModel.count == 0
                verticalOffset: 6* Theme.paddingLarge
            }
        }

        ListModel {
            id: favoritesModel
        }

        VerticalScrollDecorator { }
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

    function handleMessage(messageObject) {
        var jsonResponse = JSON.parse(messageObject.response)
        if (jsonResponse.errors === undefined)
            TMDB.configuration_set(jsonResponse, { app_locale: appLocale })
    }
}
