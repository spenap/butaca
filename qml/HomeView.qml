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

Page {
    tools: commonTools

    orientationLock: PageOrientation.LockPortrait

    ButacaToolBar { id: commonTools }

    TabGroup {
        id: tabGroup

        currentTab: homeTab

        PageStack {
            id: homeTab
        }

        PageStack {
            id: searchTab
        }

        PageStack {
            id: browseTab
        }

        PageStack {
           id: showtimesTab
        }
    }

    WelcomeView { id: welcomeView }
    SearchView { id: searchView }
    BasicMovieView { id: browseView }
    ShowtimesView { id: showtimesView }

    Component.onCompleted: {
        homeTab.push(welcomeView);
        searchTab.push(searchView);
        browseTab.push(browseView);
        /* showtimesTab.push(showtimesView); */
    }
}
