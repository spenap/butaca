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
import com.nokia.extras 1.0
import 'constants.js' as UIConstants

Item {
    id: delegate

    signal clicked()

    property string title: ''
    property int titleSize: UIConstants.FONT_SLARGE
    property int titleWeight: Font.Normal
    property string titleFontFamily: UIConstants.FONT_FAMILY
    property color titleColor: UIConstants.COLOR_INVERTED_FOREGROUND

    property string subtitle: ''
    property int subtitleSize: UIConstants.FONT_LSMALL
    property int subtitleWeight: Font.Normal
    property string subtitleFontFamily: UIConstants.FONT_FAMILY_LIGHT
    property color subtitleColor: UIConstants.COLOR_SECONDARY_FOREGROUND

    property string iconSource: ''
    property bool smallSize: false

    property bool expandable: false
    property bool expanded: false

    height: smallSize ? UIConstants.LIST_ITEM_HEIGHT_SMALL : UIConstants.LIST_ITEM_HEIGHT_DEFAULT

    BorderImage {
        id: delegateBackground
        anchors.fill: parent
        visible: delegateMouseArea.pressed
        source: 'image://theme/meegotouch-list-fullwidth-inverted-background-pressed-vertical-center'
    }

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
            verticalCenter: parent.verticalCenter
        }
        width: parent.width -
               (delegateImage.visible ? (delegateImage.width + UIConstants.DEFAULT_MARGIN) : 0) -
               delegateMoreIndicator.width -
               UIConstants.DEFAULT_MARGIN

        Label {
            id: delegateTitleLabel
            platformStyle: LabelStyle {
                fontPixelSize: titleSize
                fontFamily: titleFontFamily
            }
            font.weight: titleWeight
            color: titleColor
            width: parent.width
            elide: Text.ElideRight

            text: title
        }

        Label {
            id: delegateSubtitleLabel
            platformStyle: LabelStyle {
                fontFamily: subtitleFontFamily
                fontPixelSize: subtitleSize
            }
            font.weight: subtitleWeight
            color: subtitleColor
            width: parent.width
            elide: Text.ElideRight
            visible: subtitle

            text: subtitle
        }
    }

    MyMoreIndicator {
        id: delegateMoreIndicator
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: UIConstants.DEFAULT_MARGIN
        }
        rotation: expandable ? (expanded ? -90 : 90) : 0

        Behavior on rotation {
            NumberAnimation { duration: 100 }
        }
    }

    MouseArea {
        id: delegateMouseArea
        anchors.fill: parent
        onClicked: delegate.clicked()
    }
}
