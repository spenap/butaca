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

Item {
    id: movieDelegate
    width: movieDelegate.ListView.view.width; height: 230

    function getYear(date) {
        /* This asumes a date in yyyy-mm-dd */
        var dateParts = date.split('-');
        return dateParts[0]
    }

    SingleMovieView { id: singleMovieView }

    Rectangle {
        anchors.fill: content
        color: "black"; opacity: 0.3
        radius: 10
    }

    MouseArea {
        anchors.fill: parent
        onClicked: { tabGroup.currentTab.push(singleMovieView, { movieId: tmdbId }) }
    }

    Row {
        id: content
        spacing: 10
        anchors.margins: 5
        anchors.fill: parent

        Item {
            id: moviePoster
            width: 135
            height: 160

            Image {
                source: poster
                anchors.centerIn: parent
            }
        }

        Column {
            width: parent.width - moviePoster.width - viewDetails.width - 20
            height: parent.height
            spacing: 10

            Text {
                id: titleText
                width: parent.width
                font.pixelSize: 26
                text: '<b>' + title + '</b>' + ' (' + getYear(released) +')'
                wrapMode: Text.WordWrap
            }

            RatingIndicator {
                ratingValue: rating
                maximumValue: 10
                count: votes
            }

            Text {
                id: overviewText
                width: parent.width - 5
                font.pixelSize: 20
                textFormat: Text.StyledText
                text: '<i>' + overview + '</i>'
                wrapMode: Text.WordWrap
                maximumLineCount: 5
                elide: Text.ElideRight
            }
        }

        Item {
            id: viewDetails
            width: moreIndicator.width + 10
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter

            MoreIndicator {
                id: moreIndicator
                anchors.centerIn: parent
            }
        }
    }
}
