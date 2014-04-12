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
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import 'constants.js' as UIConstants
import 'butacautils.js' as Util
import 'moviedbwrapper.js' as TheMovieDb
import 'storage.js' as Storage

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
        text: qsTr('Search')
    }

    TextField {
        id: searchInput
        //: Placeholder text shown in the search input field
        placeholderText: qsTr('Enter search terms')

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
            text: qsTr('Movies')
        }

        Button {
            id: peopleSearch
            //: Shown in the button selecting celebrities search
            text: qsTr('Celebrities')
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

    JSONListModel {
        id: peopleModel
        property string personName: ''
        property int page: 1
        source: personName ? TheMovieDb.search('person', personName, {
                                                   app_locale: appLocale,
                                                   'page_value': page,
                                                   'includeAdult_value': Storage.getSetting('includeAdult', 'true')
                                               }) : ''
        query: TheMovieDb.query_path(TheMovieDb.SEARCH)
        onJsonChanged: {
            if (json !== "")
                loading = false
            Util.populateModelFromModel(peopleModel.model, localModel, Util.TMDbPerson)
        }
    }

    JSONListModel {
        id: moviesModel
        property string movieName: ''
        property int page: 1
        source: movieName ? TheMovieDb.search('movie', movieName, {
                                                  app_locale: appLocale,
                                                  'page_value': page,
                                                  'includeAdult_value': Storage.getSetting('includeAdult', 'true')
                                              }) : ''
        query: TheMovieDb.query_path(TheMovieDb.SEARCH)
        onJsonChanged: {
            if (json !== "")
                loading = false
            if (count !== 0)
                Util.populateModelFromModel(moviesModel.model, localModel, Util.TMDbMovie)
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

                onMovementEnded: {
                    if (atYEnd)
                        peopleModel.page++
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
                    iconSource: model.poster_path
                    name: model.title
                    rating: model.vote_average
                    votes: model.vote_count
                    year: Util.getYearFromDate(model.release_date)

                    onClicked: searchView.handleClicked(index)
                }

                onMovementEnded: {
                    if (atYEnd)
                        moviesModel.page++
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
            when: (peopleModel.source != '' && peopleModel.json == '') ||
                  (moviesModel.source != '' && moviesModel.json == '')
            PropertyChanges {
                target: busyIndicator
                running: true
            }
        },
        State {
            name: 'notFoundState'
            when: ((peopleModel.source != '' && peopleModel.json != '' ) ||
                   (moviesModel.source != '' && moviesModel.json != '')) &&
                  localModel.count === 0
            PropertyChanges {
                target: noResults
                visible: true
                //: Shown in the search results area when no results were found
                text: qsTr('No results found')
            }
        },
        State {
            name: 'emptyState'
            when: peopleModel.source  == '' && moviesModel.source == '' &&
                  !searchInput.text
            PropertyChanges {
                target: noResults
                visible: true
                //: Shown in the search results area when no terms have been introduced
                text: qsTr('Introduce search terms')
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
                moviesModel.page = 1
                moviesModel.movieName = searchTerm
            } else if (searchCategory.checkedButton === peopleSearch) {
                peopleModel.page = 1
                peopleModel.personName = searchTerm
            }
            resultsListLoader.forceActiveFocus()
        }
    }
}
