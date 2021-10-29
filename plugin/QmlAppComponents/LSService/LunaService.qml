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

Service {
    id: root

    signal connected();
    signal disconnected();

    property bool serviceConnected: false
    property string serviceName: ""

    onServiceConnectedChanged: {
        if (serviceConnected)
            connected();
        else {
            cancel();
            disconnected();
        }
    }

    function commonResponseLogic(payload) {
        appLog.log("payload :",payload);

        var response = JSON.parse(payload);

        if (response.returnValue == false) {
            appLog.log("returnValue fail")
            return response;
        }
        return response;
    }
}
