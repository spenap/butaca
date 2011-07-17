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
import com.nokia.extras 1.0

Component {
    id: browseGenresView

    Page {
        tools: commonTools

        GenresModel {
            id: genresModel
        }

        Text {
            id: header
            anchors.top: parent.top
            anchors.margins: 20
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: 40
            text: 'Movie genres'
        }

        ListView {
            id: list
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            anchors.margins: 20
            model: genresModel
            width: parent.width; height: parent.height - header.height - 40
            clip: true
            delegate: GenresDelegate { }
        }

        ScrollBar {
            scrollArea: list;
            height: list.height; width: 8;
            anchors { top: list.top; right: list.right; bottom: list.bottom }
        }
    }
}

