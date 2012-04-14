import QtQuick 1.1
import com.nokia.meego 1.0
import 'constants.js' as UIConstants

Item {
    id: galleryPreviewer
    height: 140

    property ListModel galleryPreviewerModel
    property string previewerDelegateIcon: ''
    property string previewerDelegateSize: ''
    property int previewedItems: 4

    property int previewerDelegateIconWidth: 92
    property int previewerDelegateIconHeight: 138

    signal clicked()

    BorderImage {
        id: galleryPreviewerBackground
        anchors.fill: parent
        visible: galleryPreviewerMouseArea.pressed
        source: 'image://theme/meegotouch-list-fullwidth-inverted-background-pressed-vertical-center'
    }

    Flow {
        id: galleryPreviewerFlow
        anchors {
            left: parent.left
            leftMargin: UIConstants.PADDING_LARGE
            verticalCenter: parent.verticalCenter
        }
        width: parent.width - galleryPreviewerMoreIndicator.width
        height: parent.height
        spacing: UIConstants.PADDING_LARGE

        Repeater {
            id: galleryPreviewerRepeater
            model: Math.min(previewedItems, galleryPreviewerModel.count)
            delegate: Image {
                id: previewerDelegate
                width: previewerDelegateIconWidth; height: previewerDelegateIconHeight
                opacity: galleryPreviewerMouseArea.pressed ? 0.5 : 1
                fillMode: Image.PreserveAspectFit
                source: galleryPreviewerModel.get(index).sizes[previewerDelegateSize][previewerDelegateIcon]
            }
        }
    }

    MyMoreIndicator {
        id: galleryPreviewerMoreIndicator
        anchors {
            right: parent.right
            rightMargin: UIConstants.DEFAULT_MARGIN
            verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: galleryPreviewerMouseArea
        anchors.fill: parent
        onClicked: galleryPreviewer.clicked()
    }
}
