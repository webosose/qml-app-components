/* @@@LICENSE
 *
 * Copyright (c) <2019-2020> LG Electronics, Inc.
 *
 * Confidential computer software. Valid license from LG required for
 * possession, use or copying. Consistent with FAR 12.211 and 12.212,
 * Commercial Computer Software, Computer Software Documentation, and
 * Technical Data for Commercial Items are licensed to the U.S. Government
 * under vendor's standard commercial license.
 *
 * LICENSE@@@ */

import QtQuick 2.4

QtObject {
    id: root

    readonly property var styleRoot: root

    // Not sure but I hope this readonly may better than just binding formula.
    readonly property real scale: width / baseWidth
    readonly property real widthScale: width / baseWidth
    readonly property real heightScale: height / baseHeight

    property int baseWidth: 1920
    property int baseHeight: 720
    property int width: baseWidth * 1.5
    property int height: baseHeight * 1.5


    function bindScale(value) {
        return Qt.binding(
                    function() {
                        return root.adjScale(value)
                    }
                    );
    }

    function adjScale(value) {
        return value * root.scale
    }

    function relativeXBasedOnFHD(value) {
        return relativeX(value / baseWidth);
    }

    function relativeYBasedOnFHD(value) {
        return relativeY(value / baseHeight);
    }

    function relativeX(value) {
        return value * width
    }

    function relativeY(value) {
        return value * height
    }

    property QtObject app: QtObject {
        property color bgColor: "gray"
    }

    //property SubStyle font: SubStyle{}
    property FontStyle engFont: FontStyle {}

    property ColorThemeStyle colors: ColorThemeStyle {}


}
