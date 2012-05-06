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

import QtQuick 1.1
import com.nokia.meego 1.0
import 'butacautils.js' as Util
import 'moviedbwrapper.js' as TheMovieDb
import "storage.js" as Storage
import 'constants.js' as UIConstants

Page {
    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
        ToolIcon {
            enabled: moviesModel.status !== XmlListModel.Loading
            iconId: 'toolbar-refresh' + (enabled ? '' : '-dimmed')
            onClicked: {
                var source = TheMovieDb.movie_browse({
                                                         'browse_orderBy_value' : Storage.getSetting('orderBy', 'rating'),
                                                         'browse_order_value' : Storage.getSetting('order', 'desc'),
                                                         'browse_page_value' : 1,
                                                         'browse_count_value' : Storage.getSetting('perPage', 10),
                                                         'browse_minvotes_value' : Storage.getSetting('minVotes', 0),
                                                         'browse_genres_value' : genre
                                                     })
                if (source.localeCompare(moviesModel.source) !== 0) {
                    moviesModel.reload()
                }
            }
            anchors.horizontalCenter: parent.horizontalCenter
        }
        ToolIcon {
            iconId: 'toolbar-settings'
            onClicked: {
                appWindow.pageStack.push(settingsView, { state: 'showBrowsingSection' })
            }
            anchors.right: parent.right
        }
    }
    orientationLock: PageOrientation.LockPortrait

    property string genre: ''
    property string genreName:  ''

    MultipleMoviesModel {
        id: moviesModel
        source: TheMovieDb.movie_browse({
                                            'browse_orderBy_value' : Storage.getSetting('orderBy', 'rating'),
                                            'browse_order_value' : Storage.getSetting('order', 'desc'),
                                            'browse_page_value' : 1,
                                            'browse_count_value' : Storage.getSetting('perPage', 10),
                                            'browse_minvotes_value' : Storage.getSetting('minVotes', 0),
                                            'browse_genres_value' : genre
                                        })
        query: TheMovieDb.query_path(TheMovieDb.MOVIE_BROWSE)
        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                localModel.clear()
                Util.populateModelFromModel(moviesModel, localModel, Util.TMDbMovie)
            }
        }
    }

    ListModel {
        id: localModel
    }

    Component { id: movieView; MovieView { } }

    ListView {
        id: list
        anchors.fill: parent
        model: localModel
        delegate: MultipleMoviesDelegate {
            iconSource: model.poster
            name: model.name
            rating: model.rating
            votes: model.votes
            year: Util.getYearFromDate(model.released)

            onClicked: {
                pageStack.push(movieView,
                               {
                                   movie: localModel.get(index)
                               })
            }
        }
        header: Header {
            text: genreName
        }
    }

    NoContentItem {
        id: noResults
        anchors {
            fill: parent
            margins: UIConstants.DEFAULT_MARGIN
        }
        //: When browsing movies, shown when no movies matched the browse criteria
        text: qsTr('No content found')
        visible: moviesModel.status === XmlListModel.Ready && moviesModel.count === 0
    }

    BusyIndicator {
        id: busyIndicator
        visible: running
        running: moviesModel.status === XmlListModel.Loading
        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: 'large' }
    }

    ScrollDecorator {
        flickableItem: list
    }
}
