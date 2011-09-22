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
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "butacautils.js" as BUTACA
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Item {
    id: movieDelegate
    width: movieDelegate.ListView.view.width
    height: movieDelegate.ListView.view.height

    CastView { id: castView }

    function formatMovieCast() {
        var actors = [ actor1, actor2, actor3 ]
        var output = '<b>Director: </b> ' + (director ? director : 'not found') +
            '<br />' + '<b>Cast: </b><br />'
        for (var i = 0; i < actors.length; i ++) {
            if (actors[i]) {
                output += actors[i]
                if (i < actors.length - 1) {
                    output += ', '
                } else {
                    output += '...'
                }
            }
        }
        return output
    }

    Flickable {
        id: movieFlickable
        anchors.fill: parent
        anchors {
            rightMargin: UIConstants.DEFAULT_MARGIN
            leftMargin: UIConstants.DEFAULT_MARGIN
        }
        contentHeight: titleText.height +
                       row.height +
                       cast.height +
                       overviewText.height +
                       4 * UIConstants.DEFAULT_MARGIN +
                       (trailerHeader.visible ?
                            trailerHeader.height +
                            trailerImage.height +
                            30 : 0)

        ButacaHeader {
            id: titleText
            anchors.rightMargin: 0
            anchors.leftMargin: 0

            text: title + ' (' + BUTACA.getYearFromDate(released) + ')'
            tagline: tagline
        }

        Row {
            id: row
            spacing: 20
            width: parent.width
            anchors.top: titleText.bottom
            anchors.topMargin: UIConstants.DEFAULT_MARGIN

            Image {
                id: image
                width: 190
                height: 280
                source: poster ? poster : 'qrc:/resources/movie-placeholder.svg'
                onStatusChanged: {
                    if (image.status == Image.Error) {
                        image.source = 'qrc:/resources/movie-placeholder.svg'
                    }
                }
            }

            Column {
                width: parent.width - image.width
                spacing: 8

                Text {
                    id: akaText
                    width: parent.width
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: UIConstants.FONT_FAMILY
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                    wrapMode: Text.WordWrap
                    text: '<b>Also known as:</b><br />' +
                          (alternativeName ? alternativeName : ' - ')
                }

                Text {
                    id: certificationText
                    width: parent.width
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: UIConstants.FONT_FAMILY
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                    wrapMode: Text.WordWrap
                    text: '<b>Certification</b>: ' +
                          (certification ? certification : ' - ')
                }

                Text {
                    id: releasedText
                    width: parent.width
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: UIConstants.FONT_FAMILY
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                    wrapMode: Text.WordWrap
                    text: '<b>Release date:</b><br /> ' +
                          (released ? released : ' - ')
                }

                Text {
                    id: budgetText
                    width: parent.width
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: UIConstants.FONT_FAMILY
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                    wrapMode: Text.WordWrap
                    text: '<b>Budget:</b> ' +
                          (budget ? controller.formatCurrency(budget) : ' - ')
                }

                Text {
                    id: revenueText
                    width: parent.width
                    font.pixelSize: UIConstants.FONT_LSMALL
                    font.family: UIConstants.FONT_FAMILY
                    color: !theme.inverted ?
                               UIConstants.COLOR_FOREGROUND :
                               UIConstants.COLOR_INVERTED_FOREGROUND
                    wrapMode: Text.WordWrap
                    text: '<b>Revenue:</b> ' +
                          (revenue ? controller.formatCurrency(revenue) : ' - ')
                }

                RatingIndicator {
                    ratingValue: rating / 2
                    maximumValue: 5
                    count: votes
                    inverted: theme.inverted
                }
            }
        }

        Text {
            id: cast
            anchors.top: row.bottom
            anchors.topMargin: 20

            width: parent.width - castDetails.width
            font.pixelSize: UIConstants.FONT_LSMALL
            font.family: UIConstants.FONT_FAMILY
            color: !theme.inverted ?
                       UIConstants.COLOR_FOREGROUND :
                       UIConstants.COLOR_INVERTED_FOREGROUND
            wrapMode: Text.WordWrap
            text: formatMovieCast()
            opacity: castMouseArea.pressed ? 0.5 : 1

            Image {
                id: castDetails
                anchors.top: parent.top
                anchors.right: parent.right
                source: 'image://theme/icon-s-music-video-description'
            }

            MouseArea {
                id: castMouseArea
                anchors.fill: cast
                onClicked: {
                    appWindow.pageStack.push(castView,
                                             { movie: title,
                                               movieId: tmdbId })
                }
            }
        }

        Text {
            id: overviewText
            anchors.top: cast.bottom
            anchors.topMargin: 20

            width: parent.width
            font.pixelSize: UIConstants.FONT_LSMALL
            font.family: UIConstants.FONT_FAMILY
            text: '<b>Overview:</b><br />' +
                  (overview ? BUTACA.sanitizeText(overview) : 'Overview not found')
            color: !theme.inverted ?
                       UIConstants.COLOR_FOREGROUND :
                       UIConstants.COLOR_INVERTED_FOREGROUND
            wrapMode: Text.WordWrap
        }

        Text {
            id: trailerHeader
            anchors.top: overviewText.bottom
            anchors.topMargin: 20
            font.pixelSize: UIConstants.FONT_SLARGE
            font.family: UIConstants.FONT_FAMILY
            color: !theme.inverted ?
                       UIConstants.COLOR_FOREGROUND :
                       UIConstants.COLOR_INVERTED_FOREGROUND
            text: '<b>Movie trailer</b>'
            visible: trailerImage.visible
        }

        Image {
            id: trailerImage
            anchors.top: trailerHeader.bottom
            anchors.topMargin: 10
            anchors.leftMargin: 10
            width: 120; height: 90
            source: BUTACA.getTrailerThumbnail(trailer)
            visible: playButton.visible

            Image {
                id: playButton
                anchors.centerIn: parent
                source: 'image://theme/icon-s-music-video-play'
                visible: trailerImage.source != ''
            }

            MouseArea {
                anchors.fill: trailerImage
                onClicked: {
                    Qt.openUrlExternally(trailer)
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: movieFlickable
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }
}
