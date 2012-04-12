import QtQuick 1.1
import com.nokia.meego 1.0
import 'butacautils.js' as BUTACA
import 'constants.js' as UIConstants

Page {
    property ListModel galleryViewModel

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
    }

    GridView {
        id: grid
        anchors.fill: parent
        cellHeight: 160
        cellWidth: 160
        model: galleryViewModel
        delegate: Rectangle {
            height: grid.cellHeight
            width: grid.cellWidth
            color: '#2d2d2d'
            clip: true

            Image {
                anchors {
                    fill: parent
                    margins: UIConstants.PADDING_XSMALL
                }
                source: sizes['w154'].url
                fillMode: Image.PreserveAspectCrop
            }

            Rectangle {
                anchors.fill: parent
                color: 'transparent'
                border.color: '#2d2d2d'
                border.width: UIConstants.PADDING_XSMALL
            }
        }
    }
}
