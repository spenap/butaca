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
import com.nokia.extras 1.0
import "butacautils.js" as BUTACA

Item {
    id: movieDelegate
    width: movieDelegate.ListView.view.width; height: movieDelegate.ListView.view.height

    /* Header: title (year), tagline and rating */
    Column {
        id: header
        spacing: 20
        width: parent.width
        anchors {top: parent.top; left: parent.left; right: parent.right }
        anchors.margins: 20

        Text {
            id: titleText
            width: parent.width
            font.pixelSize: 26
            text: '<b>' + title + '</b>' + ' (' + BUTACA.getYearFromDate(released) +')'
            wrapMode: Text.WordWrap
        }

        Text {
            id: taglineText
            width: parent.width
            font.pixelSize: 24
            text: '<i>' + tagline + '</i>'
            wrapMode: Text.WordWrap
            visible: text != ''
        }

        RatingIndicator {
            ratingValue: rating
            maximumValue: 10
            count: votes
        }
    }

    /* Variable content */
    Flickable {
        id: flick
        width: parent.width
        anchors.top: header.bottom; anchors.bottom: parent.bottom
        anchors.margins: 20
        contentHeight: row.height + overviewText.height + trailerHeader.height + trailerImage.height + 60
        clip: true

        Row {
            id: row
            spacing: 20
            width: parent.width

            Image {
                id: image
                width: 190
                height: 280
                source: poster
            }

            Text {
                id: movieFacts
                width: parent.width - image.width
                font.pixelSize: 22
                wrapMode: Text.WordWrap
                text: '<b>Also known as:</b> ' + alternativeName + '<br />' +
                      '<b>Certification:</b> ' + certification + '<br />' +
                      '<b>Release date:</b> ' + released + '<br />' +
                      '<b>Budget:</b> ' + budget + '<br />' +
                      '<b>Revenue:</b> ' + revenue + '<br />' +
                      '<a href="' + homepage + '">Homepage</a>'
            }
        }

        Text {
            id: overviewText
            anchors.top: row.bottom
            anchors.topMargin: 20

            width: parent.width
            font.pixelSize: 20
            text: overview
            wrapMode: Text.WordWrap
        }

        Text {
            id: trailerHeader
            anchors.top: overviewText.bottom
            anchors.topMargin: 20
            font.pixelSize: 26
            text: '<b>Movie trailer</b>'
        }

        Image {
            id: trailerImage
            anchors.top: trailerHeader.bottom
            anchors.topMargin: 10
            anchors.leftMargin: 10
            width: 120; height: 90
            source: BUTACA.getTrailerThumbnail(trailer)

            MouseArea {
                anchors.fill: trailerImage
                onClicked: {
                    helper.openVideo(trailer)
                }
            }
        }
    }
}
