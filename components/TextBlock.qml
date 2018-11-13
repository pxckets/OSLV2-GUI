import QtQuick 2.0

import "../components" as ArqmaComponents

TextEdit {
    color: ArqmaComponents.Style.defaultFontColor
    font.family: ArqmaComponents.Style.fontRegular.name
    selectionColor: ArqmaComponents.Style.dimmedFontColor
    wrapMode: Text.Wrap
    readOnly: true
    selectByMouse: true
    // Workaround for https://bugreports.qt.io/browse/QTBUG-50587
    onFocusChanged: {
        if(focus === false)
            deselect()
    }
}
