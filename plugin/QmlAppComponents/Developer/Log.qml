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
import PmLog 1.0

Item {
    property var pmLog: _pmLog
    property string logContext: "QmlApp"

    PmLog { id: _pmLog; context: logContext }

    property var dbgText
    property bool needDrawOnDbgWindow: false

    function drawOnDbgWindow(param) {
        if( dbgText == undefined || needDrawOnDbgWindow == false)
            return;

        for (var i = 0 ; i < arguments.length; i++ )
            dbgText.text += (arguments[i] + " ");
    }

    function debug(param) {
        console.debug.apply(null, arguments);

        drawOnDbgWindow("\n[DEBUG]");
        drawOnDbgWindow.apply(null, arguments);
    }

    function log(param) {
        console.log.apply(null, arguments);
        drawOnDbgWindow("\n[INFO]");
        drawOnDbgWindow.apply(null, arguments);
    }

    function info(param) {
        console.log.apply(null, arguments);
        drawOnDbgWindow("\n[INFO]");
        drawOnDbgWindow.apply(null, arguments);
    }

    function warn(param) {
        console.warn.apply(null, arguments);
        drawOnDbgWindow("\n[WARN]");
        drawOnDbgWindow.apply(null, arguments);
    }

    function error(param) {
        console.error.apply(null, arguments);
        drawOnDbgWindow("\n[ERROR]");
        drawOnDbgWindow.apply(null, arguments);
    }
}
