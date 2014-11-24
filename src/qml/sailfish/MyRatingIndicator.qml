/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0

/*
   Class: RatingIndicator
   Component to indicate user specified ratings.
   A rating indicator is a component that shows the rating value within the maximum allowed range according
   to the user's specification.  The user can also specify the display type to select the positive/negative
   visual.  Optionally, the user can also specify a count value that will be displayed next to the images.
*/
//ImplicitSizeItem {
Item {
    id: root

    /*
     * Property: maximumValue
     * [double] The maximum rating.  The number should be larger or equal to 0.
     */
    property double maximumValue: 0.0

    /*
     * Property: ratingValue
     * [double] The rating value.  The number should be larger or equal to 0.
     */
    property double ratingValue: 0.0

    property bool highlighted: false



    /*
     * Property: count
     * [int] A number to be displayed next to the rating images.  It is usually used to count the number of
     * votes cast. It is only displayed if a number larger or equal to 0 is specified.
     */
    property int count: -1

    /*
     * Property: starsMax
     * [integer] Specify whether the visual for the rating indicator uses the inverted color.  The value is
     * false for use with a light background and true for use with a dark background.
     */
    property int starsMax: 5
    /*
     * Property: starValue
     * [integer] Specify whether the visual for the rating indicator uses the inverted color.  The value is
     * false for use with a light background and true for use with a dark background.
     */
    property double starValue: roundHalf((ratingValue/maximumValue)*starsMax)
    property int starValueInt: Math.floor(starValue)
    property double starWidth: (starValue % 1)

    implicitHeight: Math.max(background.height, text.paintedHeight);
    implicitWidth: background.width + (count >= 0 ? internal.textSpacing + text.paintedWidth : 0);

    QtObject {
        id: internal

        property int imageWidth: 16
        property int imageHeight: 16
        property int indicatorSpacing: 5  // spacing between images
        property int textSpacing: 8  // spacing between image and text
        property url backgroundImageSource: "image://theme/icon-m-favorite" + (highlighted ? "?" + Theme.highlightColor : "")
        property url indicatorImageSource: "image://theme/icon-m-favorite-selected" + (highlighted ? "?" + Theme.highlightColor : "")
    }
    function roundHalf(num) {
        num = Math.round(num*2)/2;
        return num;
    }
    function round(n) {
        var h = Math.floor((n % starsMax)*10);
        console.log(h)
        return h >= 7
            ? n + (10 - h) * .01
            : n;
    }
    Row {
        id: background
        anchors.bottom: parent.bottom
        width: bgRepeater.model.count*Theme.iconSizeSmall
        anchors.verticalCenter: height < text.paintedHeight ? text.verticalCenter : undefined
        Repeater {
            id: bgRepeater
            model: starsMax
            Image {
                width: Theme.iconSizeSmall; height: Theme.iconSizeSmall
                source: internal.backgroundImageSource
            }
        }
    }
    Row {
        id: indicator
        anchors.bottom: parent.bottom
        width: indRepeater.model.count*Theme.iconSizeSmall
        anchors.verticalCenter: height < text.paintedHeight ? text.verticalCenter : undefined
        Repeater {
            id: indRepeater
            model: starValueInt
            Image {
                width: Theme.iconSizeSmall; height: Theme.iconSizeSmall
                source: internal.indicatorImageSource
            }
        }
        Rectangle {
            width: starWidth*Theme.iconSizeSmall; height: Theme.iconSizeSmall
            color: 'transparent'
            clip: true
            Image {
                anchors.left: parent.left
                anchors.top: parent.top
                width: Theme.iconSizeSmall; height: Theme.iconSizeSmall
                source: internal.indicatorImageSource
            }
        }
    }

    Text {
        id: text
        visible: count >= 0
        text: "(" + count + ")"
        color: highlighted ? Theme.highlightColor : Theme.primaryColor
        font.pixelSize: Theme.fontSizeSmall
        anchors.left: background.right
        anchors.leftMargin: internal.textSpacing
    }
}
