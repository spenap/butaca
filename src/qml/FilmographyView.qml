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
import 'constants.js' as UIConstants
import 'butacautils.js' as Util
import 'moviedbwrapper.js' as TMDB

Page {
    id: filmographyView
    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
    }

    property string personName: ''
    property ListModel filmographyModel

    ListView {
        id: filmographyList
        anchors {
            fill: parent
            margins: UIConstants.DEFAULT_MARGIN
        }
        model: filmographyModel
        header: Header {
            //: This appears in the filmography view header
            text: qsTr('%1\'s filmography').arg(personName)
            showDivider: false
        }
        delegate: MyListDelegate {
            width: filmographyList.width
            title: model.name +
                   (model.date ? ' (' + Util.getYearFromDate(model.date) + ')' : '')
            subtitle: model.subtitle
            iconSource: model.img ?
                            TMDB.image(TMDB.IMAGE_POSTER, 0, model.img, { app_locale: appLocale }) :
                            'qrc:/resources/movie-placeholder.svg'

            onClicked: {
                pageStack.push(movieView,
                               {
                                   movie: model,
                                   loading: true
                               })
            }
        }

        section.property: 'department'
        section.delegate: ListSectionDelegate { sectionName: section }
    }

    ScrollDecorator {
        flickableItem: filmographyList
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }
}
