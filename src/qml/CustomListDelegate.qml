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
import com.nokia.extras 1.0
import "butacautils.js" as BUTACA
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "file:///usr/lib/qt4/imports/com/nokia/extras/constants.js" as ExtrasConstants

Item {
    id: customListDelegate

    signal clicked

    property string listTitle: model.title
    property string listSubtitle: model.subtitle ? model.subtitle : ''
    property bool pressable: true

    width: parent.width
    height: ExtrasConstants.LIST_ITEM_HEIGHT

    BorderImage {
        anchors.fill: parent
        visible: mouseArea.pressed && pressable
        source: theme.inverted ?
                    'image://theme/meegotouch-list-fullwidth-inverted-background-pressed-vertical-center':
                    'image://theme/meegotouch-list-fullwidth-background-pressed-vertical-center'
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: customListDelegate.clicked()
    }

    Item {
        anchors.fill: parent
        anchors {
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - viewDetails.width - ExtrasConstants.LIST_ITEM_SPACING

            Text {
                id: titleText
                text: listTitle
                font.family: UIConstants.FONT_FAMILY
                font.pixelSize: ExtrasConstants.LIST_TILE_SIZE
                color: theme.inverted ?
                           ExtrasConstants.LIST_TITLE_COLOR_INVERTED :
                           ExtrasConstants.LIST_TITLE_COLOR
                width: parent.width
                elide: Text.ElideRight
            }

            Text {
                id: subtitleText
                text: listSubtitle
                font.family: "Nokia Pure Text Light"
                font.pixelSize: ExtrasConstants.LIST_SUBTILE_SIZE
                color: theme.inverted ?
                           ExtrasConstants.LIST_SUBTITLE_COLOR_INVERTED :
                           ExtrasConstants.LIST_SUBTITLE_COLOR
                visible: listSubtitle
                width: parent.width
                elide: Text.ElideRight
            }
        }

        CustomMoreIndicator {
            id: viewDetails
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            visible: pressable
        }
    }
}
