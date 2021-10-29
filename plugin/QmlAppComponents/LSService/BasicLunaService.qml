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
