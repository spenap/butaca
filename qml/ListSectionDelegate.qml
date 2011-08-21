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
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "file:///usr/lib/qt4/imports/com/nokia/extras/constants.js" as ExtrasConstants

Item {

    property alias sectionName: sectionDelegateText.text

    id: sectionDelegate
    width: parent.width
    height: sectionDelegateText.height + UIConstants.DEFAULT_MARGIN

    Rectangle {
        id: sectionDelegateDivider
        width: parent.width -
               sectionDelegateText.width -
               UIConstants.DEFAULT_MARGIN
        height: 1
        color: ExtrasConstants.LIST_SUBTITLE_COLOR_INVERTED
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: sectionDelegateText
        color: ExtrasConstants.LIST_SUBTITLE_COLOR_INVERTED
        font.pixelSize: ExtrasConstants.LIST_SUBTILE_SIZE
        font.weight: Font.Light
        anchors.left: sectionDelegateDivider.right
        anchors.leftMargin: UIConstants.DEFAULT_MARGIN
        anchors.verticalCenter: sectionDelegateDivider.verticalCenter
    }
}
