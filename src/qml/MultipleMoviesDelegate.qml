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
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import 'constants.js' as UIConstants
import 'moviedbwrapper.js' as TMDB

Item {
    id: movieDelegate

    signal clicked()

    property string iconSource: ''
    property string placeholderSource: 'qrc:/resources/movie-placeholder.svg'
    property string name: ''
    property string year: ''
    property double rating: 0
    property int votes: 0

    width: movieDelegate.ListView.view.width
    height: 140 + UIConstants.DEFAULT_MARGIN

    Item {
        anchors {
            fill: parent
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }

        BorderImage {
            id: background
            anchors {
                fill: parent
                leftMargin: -UIConstants.DEFAULT_MARGIN
                rightMargin: -UIConstants.DEFAULT_MARGIN
            }
            visible: mouseArea.pressed
            source: 'image://theme/meegotouch-list-fullwidth-inverted-background-pressed-vertical-center'
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: movieDelegate.clicked()
        }

        Row {
            id: content
            spacing: 15
            anchors {
                top: parent.top
                topMargin: UIConstants.DEFAULT_MARGIN / 2
                bottom: parent.bottom
                bottomMargin: UIConstants.DEFAULT_MARGIN / 2
                right: viewDetails.left
                rightMargin: UIConstants.DEFAULT_MARGIN
                left: parent.left
            }

            Image {
                id: moviePoster
                width: 95
                height: 140
                fillMode: Image.PreserveAspectFit
                source: iconSource ?
                            TMDB.image(TMDB.IMAGE_POSTER, 0, iconSource, { app_locale: appLocale }) :
                            placeholderSource
                onStatusChanged: {
                    if (moviePoster.status == Image.Error) {
                        moviePoster.source = placeholderSource
                    }
                }
            }

            Column {
                width: parent.width - moviePoster.width - 15
                height: parent.height
                spacing: 10

                Label {
                    id: titleText
                    platformStyle: LabelStyle {
                        fontFamily: UIConstants.FONT_FAMILY_BOLD
                        fontPixelSize: UIConstants.FONT_SLARGE
                    }
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                    width: parent.width
                    elide: Text.ElideRight
                    textFormat: Text.StyledText
                    maximumLineCount: 2
                    wrapMode: Text.WordWrap
                    text: name
                }

                Label {
                    id: yearText
                    platformStyle: LabelStyle {
                        fontFamily: UIConstants.FONT_FAMILY_LIGHT
                        fontPixelSize: UIConstants.FONT_LSMALL
                    }
                    color: UIConstants.COLOR_SECONDARY_FOREGROUND
                    width: parent.width
                    text: '(%1)'.arg(year)
                }

                MyRatingIndicator {
                    ratingValue: rating / 2
                    maximumValue: 5
                    count: votes
                    inverted: theme.inverted
                }
            }
        }

        MyMoreIndicator {
            id: viewDetails
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
        }
    }
}
