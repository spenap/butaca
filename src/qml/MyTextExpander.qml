/**************************************************************************
 *   Butaca
 *   Copyright (C) 2011 - 2012 Simon Pena <spena@igalia.com>
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
import com.nokia.extras 1.1
import 'constants.js' as UIConstants

Column {
    id: textExpander

    property string textHeader: ''
    property string textContent: ''

    Item {
        id: textContainer
        width: parent.width
        height: expanded ? actualSize : Math.min(actualSize, collapsedSize)
        clip: true

        Behavior on height {
            NumberAnimation { duration: 200 }
        }

        property int actualSize: innerColumn.height
        property int collapsedSize: 160
        property bool expanded: false

        Column {
            id: innerColumn
            width: parent.width

            MyEntryHeader {
                id: header
                width: parent.width
                text: textHeader
            }

            Label {
                id: contentLabel
                width: parent.width
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_LSMALL
                    fontFamily: UIConstants.FONT_FAMILY_LIGHT
                }
                text: textContent
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignJustify
            }
        }
    }

    Item {
        id: expanderToggle
        height: UIConstants.SIZE_ICON_LARGE
        width: parent.width
        visible: textContainer.actualSize > textContainer.collapsedSize

        MouseArea {
            anchors.fill: parent
            onClicked: textContainer.expanded = !textContainer.expanded
        }

        MyMoreIndicator {
            id: moreIndicator
            anchors.centerIn: parent
            rotation: textContainer.expanded ? -90 : 90

            Behavior on rotation {
                NumberAnimation { duration: 200 }
            }
        }
    }
}
