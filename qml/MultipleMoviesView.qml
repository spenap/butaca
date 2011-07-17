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
    id: multipleMoviesView

    Page {
        tools: commonTools
        property string searchTerm: ''
        property string genre: ''
        property string genreName:  ''

        MultipleMoviesModel {
            id: moviesModel
            apiMethod: searchTerm ? BUTACA.TMDB_MOVIE_SEARCH : BUTACA.TMDB_MOVIE_BROWSE
            params: searchTerm ? searchTerm : BUTACA.getBrowseCriteria(genre)
        }

        Text {
            id: header
            anchors.top: parent.top
            anchors.margins: 20
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: 40
            text: genreName
        }

        ListView {
            id: list
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            anchors.margins: 20
            width: parent.width; height: parent.height - header.height - 40
            clip: true
            model: moviesModel
            delegate: MultipleMoviesDelegate {}
        }

        ScrollDecorator {
            flickableItem: list
        }
    }
}
