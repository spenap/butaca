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
    id: basicMovieView

    Page {
        tools: commonTools
        property string searchTerm: ''
        property string genre: ''
        property string browseCriteria: '?order_by=rating&order=desc&per_page=10' + (genre ? '&genres=' + genre : '')

        BasicMovieModel {
            id: moviesModel
            apiMethod: searchTerm ? BUTACA.TMDB_MOVIE_SEARCH : BUTACA.TMDB_MOVIE_BROWSE
            params: searchTerm ? searchTerm : browseCriteria
        }

        ListView {
            id: list
            width: parent.width; height: parent.height
            model: moviesModel
            delegate: BasicMovieDelegate {}
        }

        ScrollBar {
            scrollArea: list;
            height: list.height; width: 8;
            anchors.right: parent.right
        }
    }
}
