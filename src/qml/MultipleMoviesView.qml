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
    }
    orientationLock: PageOrientation.LockPortrait

    property string genre: ''
    property string genreName:  ''

    MultipleMoviesModel {
        id: moviesModel
        apiMethod: BUTACA.TMDB_MOVIE_BROWSE
        params: BUTACA.getBrowseCriteria(
                    Storage.getSetting('orderBy', 'rating'),
                    Storage.getSetting('order', 'desc'),
                    Storage.getSetting('perPage', 10),
                    Storage.getSetting('minVotes', 0),
                    genre)
    }

    ListView {
        id: list
        anchors.fill: parent
        model: moviesModel
        delegate: MultipleMoviesDelegate {
            onClicked: {
                pageStack.push(movieView,
                               { detailId: tmdbId,
                                 viewType: BUTACA.MOVIE })
            }
        }
        header: Header {
            text: genreName
        }
    }

    NoContentItem {
        id: noResults
        anchors.fill: parent
        text: 'No content found'
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
