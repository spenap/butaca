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

    property string title: ''
    property int titleSize: Theme.fontSizeMedium
    property string titleFontFamily: UIConstants.FONT_FAMILY
    property color titleColor: UIConstants.COLOR_INVERTED_FOREGROUND
    property bool titleWraps: false

    property string subtitle: ''
    property int subtitleSize: Theme.fontSizeMedium
    property string subtitleFontFamily: UIConstants.FONT_FAMILY_LIGHT
    property color subtitleColor: UIConstants.COLOR_SECONDARY_FOREGROUND
    property bool subtitleWraps: false

    property string iconSource: ''
    property bool smallSize: false

    property bool expandable: false
    property bool expanded: false

    property int defaultSize: smallSize ?
                                  UIConstants.LIST_ITEM_HEIGHT_SMALL :
                                  UIConstants.LIST_ITEM_HEIGHT_DEFAULT
    height: titleWraps || subtitleWraps ?
                delegateColumn.height :
                defaultSize

    Image {
        id: delegateImage
        anchors {
            left: parent.left
            leftMargin: UIConstants.PADDING_LARGE
            verticalCenter: parent.verticalCenter
        }
        source: iconSource
        fillMode: Image.PreserveAspectFit
        width: UIConstants.SIZE_ICON_LARGE
        height: UIConstants.SIZE_ICON_LARGE
        visible: iconSource
    }

    Column {
        id: delegateColumn
        anchors {
            left: delegateImage.visible ? delegateImage.right : parent.left
            leftMargin: UIConstants.DEFAULT_MARGIN
            right: parent.right
            rightMargin: UIConstants.DEFAULT_MARGIN
            verticalCenter: parent.verticalCenter
        }
        width: parent.width -
               (delegateImage.visible ? (delegateImage.width + UIConstants.DEFAULT_MARGIN) : 0) -
               UIConstants.DEFAULT_MARGIN

        Label {
            id: delegateTitleLabel
            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            width: parent.width
            wrapMode: titleWraps ? Text.WordWrap : Text.NoWrap
            elide: titleWraps ? Text.ElideNone : Text.ElideRight
            font.pixelSize: delegate.titleSize
            text: title
        }

        Label {
            id: delegateSubtitleLabel
            color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
            width: parent.width
            wrapMode: subtitleWraps ? Text.WordWrap : Text.NoWrap
            elide: subtitleWraps ? Text.ElideNone : Text.ElideRight
            visible: subtitle
            font.pixelSize: delegate.subtitleSize
            text: subtitle
        }
    }

//    MyMoreIndicator {
//        id: delegateMoreIndicator
//        anchors {
//            verticalCenter: parent.verticalCenter
//            right: parent.right
//            rightMargin: UIConstants.DEFAULT_MARGIN
//        }
//        rotation: expandable ? (expanded ? -90 : 90) : 0

//        Behavior on rotation {
//            NumberAnimation { duration: 100 }
//        }
//    }
}
