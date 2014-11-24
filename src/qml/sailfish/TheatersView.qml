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
import "storage.js" as Storage
import "butacautils.js" as Util

Page {
    id: cinemasView

    allowedOrientations: Orientation.Portrait

    property string extendedSection: ''
    property string location
    property string daysAhead
    property bool showShowtimesFilter: false
    property real contentYPos: list.visibleArea.yPosition *
                               Math.max(list.height, list.contentHeight)

    Component.onCompleted: {
        var date = new Date(Storage.getSetting('showtimesDate', Date.now().toString()))
        if (date < new Date())
            date = new Date() // now

        location = Storage.getSetting('location', '')
        daysAhead = Util.dateDiffInDays(new Date(), date)
        theaterModel.setFilterWildcard('')
        if (list.model.count === 0 ||
                location.localeCompare(controller.currentLocation()) !== 0 ||
                daysAhead.localeCompare(controller.currentDaysAhead()) !== 0) {
            controller.fetchTheaters(location, daysAhead)
            cinemasView.state = 'Loading'
        } else {
            cinemasView.state = 'Ready'
        }
    }

    function handleTheatersFetched(ok) {
        if (ok) {
            cinemasView.state = 'Ready'
        } else {
            cinemasView.state = 'Failed'
        }
    }

    Connections {
        target: controller
        onTheatersFetched: handleTheatersFetched(ok)
    }

    state: 'Loading'

    Component { id: showtimesView; ShowtimesView { } }

    SilicaListView {
        id: list
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        model: theaterModel
        clip: true
        currentIndex: -1
        header: Column {
            width: parent.width
            visible: height !== 0

            PageHeader {
                //: Header shown in the showtimes view
                title: qsTr('In theaters')
            }

            SearchField {
                width: parent.width
                placeholderText:
                    //: Placeholder text for the search field in the showtimes view
                    qsTr('Search')
                onTextChanged: {
                    theaterModel.setFilterWildcard(text)
                }
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }
        }
        delegate: MyListDelegate {
            width: list.width
            title: model.name
            subtitle: model.playing
            subtitleSize: Theme.fontSizeSmall

            onClicked: {
                appWindow.pageStack.push(showtimesView,
                                         {
                                             cinemaName: model.name,
                                             cinemaInfo: model.info,
                                             showtimesModel: theaterModel.showtimes(index)
                                         })
            }
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh")
                visible: cinemasView.state !== 'Loading'
                onClicked: {
                    var date = new Date(Storage.getSetting('showtimesDate', Date.now().toString()))
                    if (date < new Date())
                        date = new Date() // now

                    location = Storage.getSetting('location', '')
                    daysAhead = Util.dateDiffInDays(new Date(), date)
                    if (location.localeCompare(controller.currentLocation()) !== 0 ||
                            daysAhead.localeCompare(controller.currentDaysAhead()) !== 0) {
                        controller.fetchTheaters(location, daysAhead)
                        cinemasView.state = 'Loading'
                    }
                }
            }

            MenuItem {
                text: qsTr("Preferences")
                onClicked: {
                    appWindow.pageStack.push(settingsView, { state: 'showShowtimesSection' })
                }
            }
        }

        ViewPlaceholder {
            id: noTheaterResults
            text: (location ?
                       //: Message shown when no results are found for a given location
                       qsTr('No results for %1').arg(location) :
                       //: Message shown when no results are found for the automatic location
                       qsTr('No results for your location'))
            enabled: list.model.count === 0
        }

        VerticalScrollDecorator { }
    }

    BusyIndicator {
        id: busyIndicator
        visible: true
        running: true
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
    }

    states: [
        State {
            name: 'Ready'
            PropertyChanges { target: busyIndicator; running: false; visible: false }
            PropertyChanges { target: list; visible: true }
            PropertyChanges { target: noTheaterResults; visible: false}
        },
        State {
            name: 'Loading'
            PropertyChanges { target: busyIndicator; running: true; visible: true }
            PropertyChanges { target: list; visible: false }
            PropertyChanges { target: noTheaterResults; visible: false }
        },
        State {
            name: 'Failed'
            PropertyChanges { target: busyIndicator; running: false; visible: false }
            PropertyChanges { target: list; visible: false }
            PropertyChanges { target: noTheaterResults; visible: true }
        }

    ]
}
