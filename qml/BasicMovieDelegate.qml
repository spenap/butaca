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

Item {
    id: movieDelegate
    width: movieDelegate.ListView.view.width; height: image.height + 2

    DetailedMovieView { id: detailedMovieView }

    /* Rectangle serving as a background */
    Rectangle {
        id: backgroundRectangle
        color: "black"; opacity: movieDelegate.ListView.index % 2 ? 0.2 : 0.3;
        height: movieDelegate.height - 2; width: movieDelegate.width;
        y: 1
    }

    /* Movie poster */
    Item {
        id: image
        width: 92
        height: movieDescription.height < posterImage.height ? posterImage.height : movieDescription.height
        smooth: true
        y: movieDescription.height > posterImage.height ? (movieDescription.height - posterImage.height) / 2 : 0

        Loading {
            width: 48; height: 48
            x: (image.width / 2) - width / 2
            y: (image.height / 2) - height / 2
            visible: posterImage.status != Image.Ready
        }

        Image {
            id: posterImage
            source: poster
            onStatusChanged: {
                if(status==Image.Ready)
                    image.state="loaded"
            }
        }
        states: State {
            name: "loaded";
            PropertyChanges { target: posterImage ; opacity:1 }
        }
        transitions: Transition { NumberAnimation { target: posterImage; property: "opacity"; duration: 200 } }
    }

    /* Movie description */
    Column {
        id: movieDescription
        anchors.left: image.right; anchors.right: backgroundRectangle.right
        anchors.leftMargin: 6; anchors.rightMargin: 6
        spacing: 10

        Text {
            id: titleText
            width: parent.width
            text: '<b>' + title + '</b>' + ' (' + released +')'
            wrapMode: Text.WordWrap
        }

        Text {
            id: ratingText
            width: parent.width
            text: '<b>Rating: </b>' + rating + ' (' + votes + ' votes )'
            wrapMode: Text.WordWrap
        }

        Text {
            id: overviewText
            width: parent.width
            text: '<b>Overview:</b><br />' + overview
            wrapMode: Text.WordWrap
        }

        Text {
            id: detailsText
            textFormat: Text.RichText
            text: '<a href="#">view details</a>'
            onLinkActivated: tabGroup.currentTab.push(detailedMovieView, { movieId: tmdbId })
        }
    }
}
