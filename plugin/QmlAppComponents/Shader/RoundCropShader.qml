/* @@@LICENSE
 *
 * Copyright (c) 2017-2021 LG Electronics, Inc.
 *
 * Confidential computer software. Valid license from LG required for
 * possession, use or copying. Consistent with FAR 12.211 and 12.212,
 * Commercial Computer Software, Computer Software Documentation, and
 * Technical Data for Commercial Items are licensed to the U.S. Government
 * under vendor's standard commercial license.
 *
 * LICENSE@@@ */

import QtQuick 2.4

ShaderEffect {
    property real multiplier: 5.0
    //property real multiplier: 1.3
    //property real multiplier: 0.4
    property real x_multiplier: multiplier// * appStyle.app.width/appStyle.app.height
    property real y_multiplier: multiplier

    fragmentShader: Qt.resolvedUrl("RoundCropShader.frag")
}
