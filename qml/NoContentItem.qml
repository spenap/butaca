import QtQuick 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Item {
    property alias text: noContentText.text

    Text {
        id: noContentText
        anchors.centerIn: parent
        font.pixelSize: UIConstants.FONT_XLARGE
        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
        opacity: 0.5
    }
}
