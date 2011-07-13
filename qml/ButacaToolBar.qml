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

ToolBarLayout {
    id: commonTools
    visible: false

    ToolIcon {
        platformIconId: "toolbar-back";
        enabled: (tabGroup.currentTab != undefined && tabGroup.currentTab.depth > 1) ? true : false
        onClicked: {
            tabGroup.currentTab.pop()
        }
    }

    ButtonRow {
        TabButton {
            text: "Home"
            tab: homeTab
        }

        TabButton {
            text: "Search"
            tab: searchTab
        }

        TabButton {
            text: "Browse"
            tab: browseTab
        }

        TabButton {
            text: "Shows"
            tab: showtimesTab
        }
    }
}
