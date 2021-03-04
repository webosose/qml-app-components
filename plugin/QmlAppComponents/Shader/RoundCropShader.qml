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

ShaderEffect {
    property real multiplier: 5.0
    //property real multiplier: 1.3
    //property real multiplier: 0.4
    property real x_multiplier: multiplier// * appStyle.app.width/appStyle.app.height
    property real y_multiplier: multiplier

    fragmentShader: "
    uniform lowp sampler2D source;
    varying highp vec2 qt_TexCoord0;
    uniform highp float qt_Opacity;
    uniform highp float x_multiplier;
    uniform highp float y_multiplier;

    void main(void) {
        lowp float x, y;
        x = (qt_TexCoord0.x - 0.5) * 1.0 * x_multiplier;
        y = (qt_TexCoord0.y - 0.5) * 1.0 * y_multiplier;
        gl_FragColor = texture2D(source, qt_TexCoord0).rgba
            * step(x * x + y * y, 0.25)
            //* smoothstep((x * x + y * y) , 0.25 + 0.005, 0.25)
            * qt_Opacity;
    }"
}
