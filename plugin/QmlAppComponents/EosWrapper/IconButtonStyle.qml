/* @@@LICENSE
 *
 * Copyright (c) <2017> LG Electronics, Inc.
 *
 * Confidential computer software. Valid license from LG required for
 * possession, use or copying. Consistent with FAR 12.211 and 12.212,
 * Commercial Computer Software, Computer Software Documentation, and
 * Technical Data for Commercial Items are licensed to the U.S. Government
 * under vendor's standard commercial license.
 *
 * LICENSE@@@ */

import QtQuick 2.4
import Eos.Style 0.1

ButtonStyle {
    id: root
    buttonFontSize: 20
    buttonHorizontalPadding: 1
    buttonVerticalPadding: 1

    buttonBackgroundColor: "transparent"
    buttonBorderColor: "transparent"

    buttonBackgroundFocusedColor: "transparent"
    buttonBorderFocusedColor: "transparent"

    buttonBackgroundPressedColor: "#40B3Ccf8"
    buttonBorderPressedColor: "transparent"

    property real radius: 0

    backgroundItem: Rectangle {
        property Item controlRoot: (parent && parent.parent) ? parent.parent : null

        color: controlRoot != null ? controlRoot.color : "transparent"
        border.width: controlRoot != null ? controlRoot.border.width : 0
        border.color: controlRoot != null ? controlRoot.border.color : "transparent"

        anchors.fill: parent
        antialiasing: true
        radius: root.radius

        //radius: height / 2
    }
}
