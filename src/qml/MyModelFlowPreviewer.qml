import QtQuick 1.1
import com.nokia.meego 1.0
import 'constants.js' as UIConstants

Flow {
    id: flowPreviewer

    property ListModel flowModel
    property int previewedItems: flowModel.count
    property string previewedField: ''

    Repeater {
        model: previewedItems
        delegate: Label {
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_LSMALL
                    fontFamily: UIConstants.FONT_FAMILY_LIGHT
                }
                text: flowModel.get(index)[previewedField] + (index !== previewedItems - 1 ? ', ' : '')
            }
    }
}
