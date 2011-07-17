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
import "butacautils.js" as BUTACA

Component {
    id: searchView

    Page {
        tools: commonTools

        property alias searchTerm: searchInput.text

        MultipleMoviesView { id: multipleMoviesView }
        PeopleView { id: peopleView }

        Text {
            id: header
            anchors.top: parent.top
            anchors.margins: 20
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: 40
            text: 'Search'
        }

        Row {
            id: searchArea
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            anchors.margins: 20
            spacing: 10

            TextField {
                id: searchInput
                placeholderText: "Enter search terms"
                width: parent.width - searchButton.width
            }
            Button {
                id: searchButton
                text: 'Search'
                width: 100
                onClicked: {
                    if (searchCategory.checkedButton == movieSearch) {
                        peopleModel.source = ''
                        moviesModel.source = BUTACA.getTMDbSource(BUTACA.TMDB_MOVIE_SEARCH, searchTerm)
                        moviesModel.reload()
                        movieList.visible = true
                        peopleList.visible = false
                    } else if (searchCategory.checkedButton == peopleSearch) {
                        moviesModel.source = ''
                        peopleModel.source = BUTACA.getTMDbSource(BUTACA.TMDB_PERSON_SEARCH, searchTerm)
                        peopleModel.reload()
                        peopleList.visible = true
                        movieList.visible = false
                    }
                }
            }
        }

        ButtonRow {
            id: searchCategory
            anchors { top: searchArea.bottom; left: parent.left; right: parent.right }
            anchors.margins: 20

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

        MultipleMoviesModel {
            id: moviesModel
            source: ''
        }

        PeopleModel {
            id: peopleModel
            source: ''
        }

        ListView {
            id: movieList
            anchors { top: searchCategory.bottom; left: parent.left; right: parent.right }
            anchors.margins: 20
            width: parent.width; height: parent.height - header.height - 40
            clip: true
            model: moviesModel
            delegate: MultipleMoviesDelegate {}
        }

        ListView {
            id: peopleList
            anchors { top: searchCategory.bottom; left: parent.left; right: parent.right }
            anchors.margins: 20
            width: parent.width; height: parent.height - header.height - 40
            clip: true
            model: peopleModel
            delegate: PeopleDelegate {}
        }
    }
}
