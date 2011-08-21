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

ToolBarLayout {
    id: commonTools
    visible: false

    property variant content: undefined
    property variant menu: undefined

    ToolIcon {
        id: backIcon
        iconId: 'toolbar-back'
        onClicked: {
            if (menu) menu.close()
            pageStack.pop()
        }
    }

    ToolIcon {
        id: favoriteIcon
        iconId: 'toolbar-favorite-unmark'
        visible: false
        onClicked: {
            iconId = iconId == 'toolbar-favorite-mark' ?
                        'toolbar-favorite-unmark' : 'toolbar-favorite-mark'

            var idx = welcomeView.indexOf(content)

            if (idx >= 0) {
                welcomeView.removeFavoriteAt(idx)
            } else {
                welcomeView.addFavorite(content)
            }
        }
    }

    ToolIcon {
        id: shareIcon
        iconId: 'toolbar-share'
        visible: false
        onClicked: helper.share(content.title, content.url)
    }

    ToolIcon {
        id: menuListIcon
        iconId: 'toolbar-view-menu'
        visible: false
        onClicked: (menu.status == DialogStatus.Closed) ?
                       menu.open() : menu.close()
    }

    /*
     * Besides the implicit initial state, with all icons
     * hidden but the 'back' one, there are 'ContentReady',
     * used when the content displayed is available, and
     * 'ContentNotReady', used when we expect content but it's
     * yet unavailable
     */
    states: [
        State {
            name: 'ContentReady'
            when: content !== undefined
            PropertyChanges {
                target: shareIcon
                enabled: true
                visible: true
            }
            PropertyChanges {
                target: favoriteIcon;
                iconId: welcomeView.indexOf(content) >= 0 ?
                                          'toolbar-favorite-mark' : 'toolbar-favorite-unmark'
                enabled: true
                visible: true
            }
            PropertyChanges {
                target: menuListIcon
                enabled: true
                visible: menu !== undefined
            }
            PropertyChanges {
                target: homepageEntry
                visible: (content.type == BUTACA.MOVIE) && content.homepage
            }
            PropertyChanges {
                target: imdbEntry
                visible: (content.type == BUTACA.MOVIE) && content.imdbId
            }
        },
        State {
            name: 'ContentNotReady'
            PropertyChanges {
                target: shareIcon
                enabled: false
                visible: true
            }
            PropertyChanges {
                target: favoriteIcon
                enabled: false
                visible: true
            }
            PropertyChanges {
                target: menuListIcon
                enabled: false
                visible: true && (menu !== undefined)
            }
        }
    ]
}
