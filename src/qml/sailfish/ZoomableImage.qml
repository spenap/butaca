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

// Zoom features support (both pinch gesture and double click) taken from xkcdMeegoReader

Flickable {
    id: flickable
    clip: true
    contentHeight: imageContainer.height
    contentWidth: imageContainer.width
    onHeightChanged: image.calculateSize()

    property alias image: image
    property alias source: image.source
    property alias status: image.status
    property alias progress: image.progress
    property string remoteSource: ''
    signal swipeLeft()
    signal swipeRight()

    onRemoteSourceChanged: {
        image.source = remoteSource

        // in case it's cached
        if (image.status == Image.Ready)
            image.calculateSize()
    }

    Item {
        id: imageContainer
        width: Math.max(image.width * image.scale, flickable.width)
        height: Math.max(image.height * image.scale, flickable.height)

        Image {
            id: image
            property real prevScale
            smooth: !flickable.movingVertically
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit

            function calculateSize() {
                scale = Math.min(flickable.width / width, flickable.height / height) * 0.98;
                pinchArea.minScale = scale;
                prevScale = Math.min(scale, 1);
            }

            onScaleChanged: {
                if ((width * scale) > flickable.width) {
                    var xoff = (flickable.width / 2 + flickable.contentX) * scale / prevScale;
                    flickable.contentX = xoff - flickable.width / 2;
                }
                if ((height * scale) > flickable.height) {
                    var yoff = (flickable.height / 2 + flickable.contentY) * scale / prevScale;
                    flickable.contentY = yoff - flickable.height / 2;
                }

                prevScale = scale;
            }

            onStatusChanged: {
                if (status == Image.Ready) {
                    calculateSize();
                } else if (status == Image.Error &&
                           image.source != remoteSource) {
                    image.source = remoteSource
                }
            }
        }
    }

    PinchArea {
        id: pinchArea
        property real minScale:  1.0
        property real lastScale: 1.0
        anchors.fill: parent

        pinch.target: image
        pinch.minimumScale: minScale
        pinch.maximumScale: 3.0

        onPinchFinished: flickable.returnToBounds()
    }

    MouseArea {
        anchors.fill : parent
        property bool doubleClicked: false
        property int startX
        property int startY
        property real startScale: pinchArea.minScale

        onDoubleClicked: {
            mouse.accepted = true

            if (image.scale > pinchArea.minScale) {
                image.scale = pinchArea.minScale
                flickable.returnToBounds()
            } else {
                image.scale = 2.3
            }
        }

        onPressed: {
            startX = (mouse.x / image.scale)
            startY = (mouse.y / image.scale)
            startScale = image.scale
        }

        onReleased: {
            if (image.scale === startScale) {
                var deltaX = (mouse.x / image.scale) - startX
                var deltaY = (mouse.y / image.scale) - startY

                // Swipe is only allowed when we're not zoomed in
                if (image.scale == pinchArea.minScale &&
                        (Math.abs(deltaX) > 50 || Math.abs(deltaY) > 50)) {

                    if (deltaX > 30) {
                        flickable.swipeRight()
                    } else if (deltaX < -30) {
                        flickable.swipeLeft()
                    }
                }
            }
        }
    }
}
