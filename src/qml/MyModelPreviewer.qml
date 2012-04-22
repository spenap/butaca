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
import 'constants.js' as UIConstants

Column {
    id: modelPreviewer

    property string previewerHeaderText: ''
    property string previewerFooterText: ''
    property int previewedItems: 4
    property ListModel previewedModel
    property alias previewerDelegate: previewerRepeater.delegate

    property string previewerDelegateTitle: ''
    property string previewerDelegateSubtitle: ''
    property string previewerDelegateIcon: ''
    property string previewerDelegatePlaceholder: ''

    signal clicked(int modelIndex)
    signal footerClicked()

    MyEntryHeader {
        width: parent.width
        text: previewerHeaderText
    }

    Repeater {
        id: previewerRepeater
        width: parent.width
        model: Math.min(previewedItems, previewedModel.count)
        delegate: MyListDelegate {
            width: parent.width
            smallSize: true

            iconSource: previewedModel.get(index)[previewerDelegateIcon] ?
                            previewedModel.get(index)[previewerDelegateIcon] :
                            previewerDelegatePlaceholder

            title: previewedModel.get(index)[previewerDelegateTitle]
            titleFontFamily: UIConstants.FONT_FAMILY_BOLD
            titleSize: UIConstants.FONT_LSMALL

            subtitle: previewedModel.get(index)[previewerDelegateSubtitle]
            subtitleSize: UIConstants.FONT_XSMALL
            subtitleFontFamily: UIConstants.FONT_FAMILY_LIGHT

            onClicked: modelPreviewer.clicked(index)
        }
    }

    MyListDelegate {
        width: parent.width
        smallSize: true
        title: previewerFooterText
        titleSize: UIConstants.FONT_LSMALL
        titleFontFamily: UIConstants.FONT_FAMILY_BOLD

        onClicked: modelPreviewer.footerClicked()
    }
}
