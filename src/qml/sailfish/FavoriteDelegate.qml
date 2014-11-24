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

import QtQuick 2.0
import Sailfish.Silica 1.0
import 'constants.js' as UIConstants

BackgroundItem {
    id: delegate

    property alias text: delegateLabel.text
    property alias source: delegateImage.source

    property int labelMaximumLineCount: 3

    width: parent.width / 3
    height: width * 1.5 + Theme.itemSizeSmall

    Column {
        id: content
        width: parent.width
        height: parent.height
        spacing: UIConstants.PADDING_SMALL

        Image {
            id: delegateImage
            width: parent.width
            height: width * 1.5
//            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: delegateLabel
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            elide: Text.ElideRight
            anchors {
                left: parent.left
                leftMargin: UIConstants.PADDING_SMALL
                right: parent.right
                rightMargin: UIConstants.PADDING_SMALL
            }
            maximumLineCount: labelMaximumLineCount
            font.pixelSize: Theme.fontSizeTiny
            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
        }
    }
}
