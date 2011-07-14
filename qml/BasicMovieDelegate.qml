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
    width: movieDelegate.ListView.view.width; height: 260

    function getYear(date) {
        /* This asumes a date in yyyy-mm-dd */
        var dateParts = date.split('-');
        return dateParts[0]
    }

    DetailedMovieView { id: detailedMovieView }

    Rectangle {
        anchors.fill: content
        color: "black"; opacity: 0.3
        radius: 10
    }

    Row {
        id: content
        spacing: 10
        anchors.margins: 5
        anchors.fill: parent

        Item {
            id: moviePoster
            width: 140
            height: 160

            Image {
                source: poster
                anchors.centerIn: parent
            }
        }

        Column {
            width: parent.width - moviePoster.width
            height: parent.height
            spacing: 10
            anchors.margins: 10

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
                text: '<b>Overview:</b><br />' + overview
                wrapMode: Text.WordWrap
                maximumLineCount: 6
                elide: Text.ElideRight
            }

            Text {
                id: detailsText
                textFormat: Text.RichText
                font.pixelSize: 20
                text: '<a href="#">View Details</a>'
                onLinkActivated: tabGroup.currentTab.push(detailedMovieView, { movieId: tmdbId })
            }
        }
    }
}
