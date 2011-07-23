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
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Component {
    id: filmographyView

    Page {
        tools: commonTools
        property string person: ''
        property string personId: ''

        ButacaHeader {
            id: header
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            text: person + "'s filmography"
        }

        Item {
            id: castContent
            anchors { top: header.bottom; left: parent.left; right: parent.right; bottom:  parent.bottom }
            anchors.margins: UIConstants.DEFAULT_MARGIN

            FilmographyModel {
                id: filmographyModel
                params: personId
            }

            ListView {
                id: list
                anchors.fill: parent
                clip: true

                model: filmographyModel
                delegate: MultipleMoviesDelegate { }
            }

            ScrollDecorator {
                flickableItem: list
            }
        }
    }
}

