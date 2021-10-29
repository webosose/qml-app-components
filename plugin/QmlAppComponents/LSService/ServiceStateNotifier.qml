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

import QtQuick 2.0
import WebOSServices 1.0

Service {
    id: serviceStatusNotifier

    property var targets: []

    readonly property string palmBusUri: "luna://com.palm.bus"
    readonly property string serverStatusMethod: "/signal/registerServerStatus"

    Component.onCompleted: {
        appLog.info("Service: Starts watching bus");

        for (var i = 0 ; i < targets.length; i++) {
            appLog.info("...Watching", targets[i]);
            call(palmBusUri, serverStatusMethod, JSON.stringify({"serviceName": targets[i].serviceName, "subscribe": true}));
        }
    }

    onResponse: {
        var response = JSON.parse(payload);

        for (var i = 0 ; i < targets.length; i++) {
            if (response.serviceName === targets[i].serviceName) {
                targets[i].serviceConnected = response.connected;
            }
        }
    }
}
