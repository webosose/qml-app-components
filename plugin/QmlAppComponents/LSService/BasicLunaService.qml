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
import WebOSServices 1.0

LunaService {
    id: root
    objectName: "basicLunaService"

    function callSimpleToast(msg) {
        call("luna://com.webos.notification/",
             "createToast",
             JSON.stringify({"message":msg}));
    }

    function openWebPage(url) {
        call("luna://com.webos.applicationManager/",
             "launch",
             JSON.stringify({"id":"com.webos.app.browser", "params":{"target":url}}));
    }

    function launchApp(appId) {
        call("luna://com.webos.applicationManager/",
             "launch",
             JSON.stringify({"id":appId, "params":{}}));
    }

    onResponse: {
        var response = commonResponseLogic(payload);
    }
}
