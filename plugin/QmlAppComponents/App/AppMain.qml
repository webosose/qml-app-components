/* @@@LICENSE
*
*      Copyright (c) 2020-2021 LG Electronics, Inc.
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
import Eos.Window 0.1
import QmlAppComponents 0.1

WebOSWindow {
    id: root

    // global variables.
    property bool isDesktopMode: false
    property bool debugMode: false// || isDesktopMode
    property url imageDir: ""

    property Log appLog: Log {logContext: root.appId}

    // window settings
    windowType: "_WEBOS_WINDOW_TYPE_CARD"
    visible: true
    color: "transparent"

    property var paramRedirector: params

    // application settings
//    // Service
//    property ServiceRoot service: _service
//    ServiceRoot {
//        id: _service
//        appId: appRoot.appId
//        appSuffix: "-1"
//    }

//    // Application
//    UIRoot {
//        id: uiRoot
//        anchors.fill: parent
//    }

//    Text {
//        id:dbgWindow
//        anchors.fill:parent
//        font.pixelSize: 25
//        color:"red"
//        text:"DBGTexts "
//        wrapMode: Text.Wrap
//        visible: debugMode

//        opacity: 0.7
//        onTextChanged: {
//            if (dbgWindow.truncated)
//                dbgWindow.text = dbgWindow.text.slice(500 * (appRoot.height / 1080),dbgWindow.text.length - 1)
//        }
//    }

//    Component.onCompleted: {
//        params = {"desc":"initial"}
//    }

//    onParamRedirectorChanged: {
//        if (paramRedirector == undefined)
//            return;
//        if (paramRedirector.desc == undefined)
//            return;
//        if (paramRedirector.desc == "initial")
//            return;

//        appLog.log("App relaunch Param came", appRoot.appId, "["+JSON.stringify(params)+"]");

//        // Do parse param and what you want to do in app

//        params = {"desc":"initial"};
//    }
}
