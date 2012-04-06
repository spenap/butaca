import QtQuick 1.1
import com.nokia.meego 1.0
import 'constants.js' as UIConstants

Item {
    id: delegate

    property int tileWidth: 140
    property int tileHeight: 210

    property real labelBackgroundOpacity: 0.8
    property color labelBackgroundColor: 'grey'

    property alias text: delegateLabel.text
    property alias source: delegateImage.source

    property int labelMaximumLineCount: 3

    signal clicked()

    width: tileWidth
    height: tileHeight
    opacity: delegateMouseArea.pressed ? 0.5 : 1

    Image {
        id: delegateImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    Rectangle {
        id: delegateLabelBackground
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: delegateLabel.height
        color: labelBackgroundColor
        opacity: labelBackgroundOpacity
    }

    Label {
        id: delegateLabel
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        elide: Text.ElideRight
        platformStyle: LabelStyle {
            fontPixelSize: UIConstants.FONT_LSMALL
            fontFamily: UIConstants.FONT_FAMILY_LIGHT
        }
        anchors {
            verticalCenter: delegateLabelBackground.verticalCenter
            left: parent.left
            leftMargin: UIConstants.PADDING_XSMALL
            right: parent.right
            rightMargin: UIConstants.PADDING_XSMALL
        }
        color: UIConstants.COLOR_INVERTED_FOREGROUND
        maximumLineCount: labelMaximumLineCount
    }

    MouseArea {
        id: delegateMouseArea
        anchors.fill: parent
        onClicked: delegate.clicked()
    }
}
