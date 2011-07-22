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
import "file:///usr/lib/qt4/imports/com/nokia/extras/constants.js" as UIConstants

Component {
    Item {
        id: movieDelegate

        property int titleSize: UIConstants.LIST_TILE_SIZE
        property int titleWeight: Font.Bold
        property color titleColor: theme.inverted ? UIConstants.LIST_TITLE_COLOR_INVERTED : UIConstants.LIST_TITLE_COLOR

        property int subtitleSize: UIConstants.LIST_SUBTILE_SIZE
        property int subtitleWeight: Font.Light
        property color subtitleColor: theme.inverted ? UIConstants.LIST_SUBTITLE_COLOR_INVERTED : UIConstants.LIST_SUBTITLE_COLOR

        width: movieDelegate.ListView.view.width; height: 150

        BorderImage {
            id: background
            anchors.fill: parent
            visible: mouseArea.pressed
            source: "image://theme/meegotouch-list-background-pressed-center"
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: { pageStack.push(singleMovieView, { movieId: tmdbId }) }
        }

        Row {
            id: content
            spacing: 15
            anchors.margins: 5
            anchors.fill: parent

            Image {
                id: moviePoster
                width: 95
                height: 140
                source: poster ? poster : 'images/movie-placeholder.svg'
                onStatusChanged: {
                    if (moviePoster.status == Image.Error) {
                        moviePoster.source = 'images/movie-placeholder.svg'
                    }
                }
            }

            Column {
                width: parent.width - moviePoster.width - viewDetails.width - 20
                height: parent.height
                spacing: 10

                Text {
                    id: titleText
                    width: parent.width
                    elide: Text.ElideRight
                    textFormat: Text.StyledText
                    font.weight: movieDelegate.titleWeight
                    font.pixelSize: movieDelegate.titleSize
                    color: movieDelegate.titleColor
                    maximumLineCount: 3
                    wrapMode: Text.WordWrap
                    text: title
                }

                Text {
                    id: yearText
                    width: parent.width
                    font.weight: movieDelegate.subtitleWeight
                    font.pixelSize: movieDelegate.subtitleSize
                    color: movieDelegate.subtitleColor
                    text: '(' + BUTACA.getYearFromDate(released) +')'
                }

                RatingIndicator {
                    ratingValue: rating / 2
                    maximumValue: 5
                    count: votes
                    inverted: theme.inverted
                }
            }

            Item {
                id: viewDetails
                width: moreIndicator.width + 10
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                CustomMoreIndicator {
                    id: moreIndicator
                    anchors.centerIn: parent
                }
            }
        }
    }
}
