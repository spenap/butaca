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
