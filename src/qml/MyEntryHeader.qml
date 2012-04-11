import QtQuick 1.1
import com.nokia.meego 1.0
import 'constants.js' as UIConstants

Label {
    id: entryHeader

    property string headerText: ''
    property int headerFontWeight: Font.Bold
    property int headerFontSize: UIConstants.FONT_DEFAULT
    property string headerFontFamily: UIConstants.FONT_FAMILY_BOLD
    property int headerWrapMode: Text.WordWrap

    platformStyle: LabelStyle {
        fontPixelSize: headerFontSize
        fontFamily: headerFontFamily
    }
    font.weight: headerFontWeight
    wrapMode: headerWrapMode
    text: headerText
}
