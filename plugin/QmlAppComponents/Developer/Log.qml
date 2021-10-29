/* @@@LICENSE
*
*      Copyright (c) 2019-2021 LG Electronics, Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
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
