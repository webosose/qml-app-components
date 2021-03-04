/* @@@LICENSE
 *
 * Copyright (c) <2020> LG Electronics, Inc.
 *
 * Confidential computer software. Valid license from LG required for
 * possession, use or copying. Consistent with FAR 12.211 and 12.212,
 * Commercial Computer Software, Computer Software Documentation, and
 * Technical Data for Commercial Items are licensed to the U.S. Government
 * under vendor's standard commercial license.
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
