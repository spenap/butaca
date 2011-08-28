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
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "file:///usr/lib/qt4/imports/com/nokia/extras/constants.js" as ExtrasConstants
import "butacautils.js" as BUTACA
import "storage.js" as Storage

Component {
    id: settingsView

    Page {
        tools: commonTools
        orientationLock: PageOrientation.LockPortrait

        Component.onCompleted: {
            Storage.initialize()
            var orderBy = Storage.getSetting('orderBy')
            var order = Storage.getSetting('order')
            var perPage = Storage.getSetting('perPage')
            var minVotes = Storage.getSetting('minVotes')

            if (!perPage) {
                resultsPerPageInput.text = '10'
                Storage.setSetting('perPage', '10')
            }

            if (!minVotes) {
                minVotesInput.text = '0'
                Storage.setSetting('minVotes', '0')
            }

            if (!orderBy) {
                Storage.setSetting('orderBy', 'rating')
            }

            if (!order) {
                Storage.setSetting('order', 'desc')
            }

            if (orderBy == 'title') {
                criteriaOptions.checkedButton = byTitle
            } else if (orderBy == 'release') {
                criteriaOptions.checkedButton = byRelease
            } else {
                criteriaOptions.checkedButton = byRating
            }

            if (order == 'asc') {
                sortOrderOptions.checkedButton = sortAscending
            } else {
                sortOrderOptions.checkedButton = sortDescending
            }
        }

        Component.onDestruction: {
            Storage.setSetting('location', locationInput.text)
            Storage.setSetting('minVotes', minVotesInput.text)
            Storage.setSetting('perPage', resultsPerPageInput.text)
        }

        Flickable {
            id: settingsContent
            anchors.fill: parent
            anchors {
                topMargin: appWindow.inPortrait?
                               UIConstants.HEADER_DEFAULT_TOP_SPACING_PORTRAIT :
                               UIConstants.HEADER_DEFAULT_TOP_SPACING_LANDSCAPE
                leftMargin: UIConstants.DEFAULT_MARGIN
                rightMargin: UIConstants.DEFAULT_MARGIN
            }
            width: parent.width
            contentHeight: settingsColumnContent.height
            flickableDirection: Flickable.VerticalFlick

            Column {
                id: settingsColumnContent
                width: parent.width
                spacing: UIConstants.DEFAULT_MARGIN

                ButacaHeader {
                    id: settingsHeader
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    text: 'Settings'
                    showDivider: false
                }

                ListSectionDelegate {
                    id: showtimesSection
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    sectionName: 'Showtimes'
                }

                Row {
                    id: showtimesLocation
                    spacing: UIConstants.DEFAULT_MARGIN
                    width: parent.width

                    Text {
                        id: locationText
                        text: 'Default location'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                        anchors.verticalCenter: locationInput.verticalCenter
                    }

                    TextField {
                        id: locationInput
                        placeholderText: 'Try automatically'
                        width: parent.width - locationText.width - parent.spacing
                        text: Storage.getSetting('location')
    //                        onAccepted: {
    //                            Storage.setSetting('location', text)
    //                        }

                        Image {
                            id: clearLocationText
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            source: 'image://theme/icon-m-input-clear'
                            visible: locationInput.activeFocus
                        }

                        MouseArea {
                            id: locationInputMouseArea
                            anchors.fill: clearLocationText
                            onClicked: {
                                inputContext.reset()
                                locationInput.text = ''
                            }
                        }
                    }
                }

                ListSectionDelegate {
                    id: browsingSection
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    sectionName: 'Browsing'
                }

                Item {
                    id: orderCriteria
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        id: criteriaText
                        anchors.top:  parent.top
                        text: 'Order criteria'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    }

                    ButtonColumn {
                        id: criteriaOptions
                        anchors { top: criteriaText.bottom; right: parent.right }
                        anchors.topMargin: UIConstants.DEFAULT_MARGIN / 2

                        Button {
                            id: byRating
                            text: 'Rating'
                            onClicked: Storage.setSetting('orderBy', 'rating')
                        }
                        Button {
                            id: byRelease
                            text: 'Release'
                            onClicked: Storage.setSetting('orderBy', 'release')
                        }
                        Button {
                            id: byTitle
                            text: 'Title'
                            onClicked: Storage.setSetting('orderBy', 'title')
                        }
                    }
                }

                Item {
                    id: sortOrder
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        id: sortOrderText
                        anchors.top:  parent.top
                        text: 'Order criteria'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    }

                    ButtonColumn {
                        id: sortOrderOptions
                        anchors { top: sortOrderText.bottom; right: parent.right }
                        anchors.topMargin: UIConstants.DEFAULT_MARGIN / 2

                        Button {
                            id: sortAscending
                            text: 'Ascending'
                            onClicked: Storage.setSetting('order', 'asc')
                        }
                        Button {
                            id: sortDescending
                            text: 'Descending'
                            onClicked: Storage.setSetting('order', 'desc')
                        }
                    }
                }

                Item {
                    id: resultsPerPage
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        id: resultsPerPageText
                        text: 'Results per page'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                        anchors.verticalCenter: resultsPerPageInput.verticalCenter
                        anchors.left: parent.left
                    }

                    TextField {
                        id: resultsPerPageInput
                        anchors.right: parent.right
                        text: Storage.getSetting('perPage')
                        width: 100
                        inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
    //                        onAccepted: {
    //                            Storage.setSetting('perPage', text)
    //                        }
                    }
                }

                Item {
                    id: minVotes
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        id: minVotesText
                        text: 'Minimum votes'
                        font.pixelSize: UIConstants.FONT_DEFAULT
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                        anchors.verticalCenter: minVotesInput.verticalCenter
                        anchors.left: parent.left
                    }

                    TextField {
                        id: minVotesInput
                        anchors.right: parent.right
                        text: Storage.getSetting('minVotes')
                        width: 100
                        inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
    //                        onAccepted: {
    //                            Storage.setSetting('minVotes', text)
    //                        }
                    }
                }
            }
        }
    }
}
