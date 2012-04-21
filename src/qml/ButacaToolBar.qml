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

ToolBarLayout {
    property variant content: ''
    property variant menu: ''
    property bool isFavorite: false

    function toggleFavorite() {
        if (isFavorite)
            welcomeView.removeFavorite(content)
        else
            welcomeView.addFavorite(content)
    }

    ToolIcon {
        iconId: enabled ?
                    'toolbar-back' :
                    'toolbar-back-dimmed'
        onClicked: {
            if (menu) menu.close()
            pageStack.pop()
        }
    }

    ToolIcon {
        iconId: (isFavorite ?
                     'toolbar-favorite-mark' :
                      'toolbar-favorite-unmark') +
                 (enabled ? '' : '-dimmed')
        onClicked: toggleFavorite()
    }

    ToolIcon {
        iconId: enabled ?
                    'toolbar-share' :
                    'toolbar-share-dimmed'
        onClicked: controller.share(content.title, content.url)
    }

    ToolIcon {
        iconId: enabled ?
                    'toolbar-view-menu' :
                    'toolbar-view-menu-dimmed'
        onClicked: (menu.status === DialogStatus.Closed) ?
                       menu.open() : menu.close()
    }
}
