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

Component {
    id: searchView

    Page {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        MultipleMoviesView { id: multipleMoviesView }
        PeopleView { id: peopleView }

        Column {
            Row {
                width: parent.width
                TextField {
                    id: searchInput
                    placeholderText: "Search"
                    width: parent.width - searchButton.width
                }
                Button {
                    id: searchButton
                    text: 'Search'
                    width: 100
                    onClicked: {
                        var searchView = searchCategory.checkedButton==movieSearch ? multipleMoviesView : peopleView
                        tabGroup.currentTab.push(searchView, {searchTerm: searchInput.text})
                    }
                }
            }

            ButtonRow {
                id: searchCategory

                Button {
                    id: movieSearch
                    text: 'Movies'
                }
                Button {
                    id: peopleSearch
                    text: 'People'
                }
                Button {
                    id: showSearch
                    text: 'Shows'
                }
            }
        }
    }
}
