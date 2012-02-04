import QtQuick 1.0
import 'constants.js' as UIConstants

Item {
    property alias text: noContentText.text

    Text {
        id: noContentText
        anchors.centerIn: parent
        font.pixelSize: UIConstants.FONT_XLARGE
        font.family: UIConstants.FONT_FAMILY
        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
        opacity: 0.5
    }
}
