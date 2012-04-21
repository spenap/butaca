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
import 'constants.js' as UIConstants

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
            //: %1's filmography
            text: qsTr('btc-person-filmography').arg(personName)
            showDivider: false
        }
        delegate: MyListDelegate {
            width: parent.width
            title: model.name
            subtitle: model.job

            onClicked: {
                pageStack.push(movieView,
                               {
                                   tmdbId: model.id,
                                   loading: true
                               })
            }
        }

        section.property: 'name'
        section.delegate: ListSectionDelegate { sectionName: section }
    }

    ScrollDecorator {
        flickableItem: filmographyList
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }
}
