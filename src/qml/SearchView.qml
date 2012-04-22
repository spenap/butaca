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
import 'constants.js' as UIConstants
import 'butacautils.js' as Util
import 'moviedbwrapper.js' as TheMovieDb
import "storage.js" as Storage

Page {
    id: searchView
    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: appWindow.pageStack.pop()
        }
    }

    orientationLock: PageOrientation.LockPortrait

    property alias searchTerm: searchInput.text
    property bool useSimpleDelegate : searchCategory.checkedButton !== movieSearch
    property bool loading: false

    property ListModel localModel: ListModel { }

    Component.onCompleted: {
        searchInput.forceActiveFocus()
    }

    Header {
        id: header
        //: Header shown in the search view
        //% "Search"
        text: qsTrId('btc-search-header')
    }

    TextField {
        id: searchInput
        //: Placeholder text shown in the search input field and the result area
        //% "Enter search terms"
        placeholderText: qsTrId('btc-search-placeholder')

        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            margins: UIConstants.DEFAULT_MARGIN
        }

        platformSipAttributes: SipAttributes {
            actionKeyIcon: '/usr/share/themes/blanco/meegotouch/icons/icon-m-toolbar-search-selected.png'
        }

        Keys.onReturnPressed: {
            doSearch()
        }

        Image {
            id: clearText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: searchInput.text ?
                        'image://theme/icon-m-input-clear' :
                        ''
        }

        MouseArea {
            id: searchInputMouseArea
            anchors.fill: clearText
            onClicked: {
                inputContext.reset()
                searchInput.text = ''
            }
        }
    }

    ButtonRow {
        id: searchCategory
        anchors {
            top: searchInput.bottom
            left: parent.left
            right: parent.right
            margins: UIConstants.DEFAULT_MARGIN
        }

        Button {
            id: movieSearch
            //: Shown in the button selecting movie search
            //% "Movies"
            text: qsTrId('btc-search-movies')
        }

        Button {
            id: peopleSearch
            //: Shown in the button selecting people search
            //% "People"
            text: qsTrId('btc-search-people')
        }

        onCheckedButtonChanged: {
            doSearch()
        }
    }

    Loader {
        id: resultsListLoader
        sourceComponent: useSimpleDelegate ? peopleListWrapper : moviesListWrapper
        anchors {
            topMargin: UIConstants.DEFAULT_MARGIN
            top: searchCategory.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    PeopleModel {
        id: peopleModel
        onStatusChanged: {
            if (status == XmlListModel.Ready) {
                Util.populateModelFromModel(peopleModel, localModel, Util.TMDbPerson)
            }
        }
    }

    MultipleMoviesModel {
        id: moviesModel
        property string movieName: ''
        source: movieName ? TheMovieDb.movie_search(movieName, { app_locale: appLocale }) : ''
        query: TheMovieDb.query_path(TheMovieDb.MOVIE_SEARCH)
        onStatusChanged: {
            if (status == XmlListModel.Ready) {
                Util.populateModelFromModel(moviesModel, localModel, Util.TMDbMovie)
                loading = false
            }
        }
    }

    Component {
        id: peopleListWrapper

        Item {
            id: innerWrapper

            ListView {
                id: peopleList
                clip: true
                anchors.fill: parent
                model: searchView.localModel
                delegate: MyListDelegate {
                    width: parent.width
                    title: model.title
                    onClicked: searchView.handleClicked(index)
                }
            }

            ScrollDecorator {
                id: scrollDecorator
                flickableItem: peopleList
            }
        }
    }

    Component {
        id: moviesListWrapper

        Item {
            id: innerWrapper

            ListView {
                id: moviesList
                clip: true
                anchors.fill: parent
                model: searchView.localModel
                delegate: MultipleMoviesDelegate {
                    onClicked: searchView.handleClicked(index)
                }
            }

            ScrollDecorator {
                id: scrollDecorator
                flickableItem: moviesList
            }
        }
    }

    NoContentItem {
        id: noResults
        anchors {
            top: searchCategory.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: UIConstants.DEFAULT_MARGIN
        }
        visible: false
        text: ''
    }

    BusyIndicator {
        id: busyIndicator
        visible: running
        running: loading
        platformStyle: BusyIndicatorStyle { size: 'large' }
        anchors.centerIn: noResults
    }

    states: [
        State {
            name: 'loadingState'
            when: peopleModel.status == XmlListModel.Loading ||
                  moviesModel.status == XmlListModel.Loading
            PropertyChanges {
                target: busyIndicator
                running: true
            }
        },
        State {
            name: 'errorState'
            when: peopleModel.status == XmlListModel.Error ||
                  moviesModel.status == XmlListModel.Error
            PropertyChanges {
                target: noResults
                visible: true
                //: Shown in the search results area when an error ocurred
                //% "There was an error performing the search
                text: qsTrId('btc-search-error')
            }
        },
        State {
            name: 'notFoundState'
            when: (peopleModel.status == XmlListModel.Ready ||
                   moviesModel.status == XmlListModel.Ready) &&
                  (peopleModel.source != '' || moviesModel.source != '') &&
                  localModel.count === 0
            PropertyChanges {
                target: noResults
                visible: true
                //: Shown in the search results area when no results were found
                //% "No results found"
                text: qsTrId('btc-search-not-found')
            }
        },
        State {
            name: 'emptyState'
            when: (peopleModel.status == XmlListModel.Ready ||
                   moviesModel.status == XmlListModel.Ready) &&
                  (peopleModel.source  == '' && moviesModel.source == '') &&
                  !searchInput.text
            PropertyChanges {
                target: noResults
                visible: true
                //: Shown in the search results area when no terms have been introduced
                //% "Enter search terms"
                text: qsTrId('btc-search-extendedplaceholder')
            }
        }
    ]

    function handleClicked(index) {
        var element = localModel.get(index)
        switch (element.type) {
        case 'TMDbMovie':
            pageStack.push(movieView,
                           {
                               movie: element
                           })
            break
        case 'TMDbPerson':
            pageStack.push(personView,
                           {
                               person: element
                           })
            break
        }
    }

    function doSearch() {
        peopleModel.personName = ''
        moviesModel.movieName = ''
        localModel.clear()
        if (searchTerm) {
            loading = true
            if (searchCategory.checkedButton === movieSearch) {
                moviesModel.movieName = searchTerm
            } else if (searchCategory.checkedButton === peopleSearch) {
                peopleModel.personName = searchTerm
            }
            resultsListLoader.forceActiveFocus()
        }
    }
}
