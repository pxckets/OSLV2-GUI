pragma Singleton

import QtQuick 2.5

QtObject {
    property QtObject fontMedium: FontLoader { id: _fontMedium; source: "qrc:/fonts/Roboto-Medium.ttf"; }
    property QtObject fontBold: FontLoader { id: _fontBold; source: "qrc:/fonts/Roboto-Bold.ttf"; }
    property QtObject fontLight: FontLoader { id: _fontLight; source: "qrc:/fonts/Roboto-Light.ttf"; }
    property QtObject fontRegular: FontLoader { id: _fontRegular; source: "qrc:/fonts/Roboto-Regular.ttf"; }

    property string grey: "#404040"

    property string heroBlue: "#080085"
    property string heroBlueHovered: "#00006E"

    property string lightBlue: "#2220BE"
    property string lightBlueHovered: "#1E6BAC"

    property string darkTurquoise: "#00207C"
    property string darkNavy: "#00143A"

    property string backgroundColor: "#1A1A1A"

    property string defaultFontColor: "white"
    property string dimmedFontColor: "#BBBBBB"
    property string inputBoxBackground: "black"
    property string inputBoxBackgroundError: "#FFDDDD"
    property string inputBoxColor: "white"

    property string legacy_placeholderFontColor: "#BABABA"
    property string inputBorderColorActive: Qt.rgba(255, 255, 255, 0.38)
    property string inputBorderColorInActive: Qt.rgba(255, 255, 255, 0.32)
    property string inputBorderColorInvalid: Qt.rgba(255, 0, 0, 0.40)

    property string buttonBackgroundColor: heroBlue
    property string buttonBackgroundColorHover: heroBlueHovered

    property string buttonBackgroundColorDisabled: "#707070"
    property string buttonBackgroundColorDisabledHover: "#808080"
    property string buttonTextColor: "white"
    property string buttonTextColorDisabled: "white"
    property string dividerColor: heroBlue
    property real dividerOpacity: 1.00
}
