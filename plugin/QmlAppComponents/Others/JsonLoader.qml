/* @@@LICENSE
*
*      Copyright (c) 2021 LG Electronics, Inc.
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

Item {
    id: root
    property var jsonObject: {"isEmpty":true} // empty object
    property string status: eInitializing

    // Internal variables
    property url _path: ""

    // Status enums
    readonly property string eInitializing: "Initializing"
    readonly property string eLoading : "Loading"
    readonly property string eLoaded : "Loaded"
    readonly property string eError : "Error"

    function isLoaded() {
        return status === eLoaded || status === eError;
    }

    signal jsonObjectReceived(var result);
    signal error(string errString);

    Timer {
        id: timeoutTimer
        interval: 200 // Is it enough?
        onTriggered: {
            console.warn("[QmlAppComponents][JsonLoader] File read - timeout", _path);
            root.status = eError
        }
    }

    function requestJsonObject(path) {
        var xhr = new XMLHttpRequest;
        _path = path;
        console.info("[QmlAppComponents][JsonLoader] Try file read", _path);
        xhr.open("GET", _path);

        xhr.onreadystatechange = (function(_this) {
            return function() {
                if(xhr.readyState === XMLHttpRequest.DONE) {
                    if(xhr.responseText.length > 0) {
                        console.info("[QMLAppComponent:JsonLoader] Json read");
                        timeoutTimer.stop();
                        try {
                            var result = JSON.parse(xhr.responseText);
                            jsonObject = result;
                            jsonObjectReceived(result);
                            console.info("[QMLAppComponent:JsonLoader] Json read successful");
                            root.status = eLoaded
                        } catch(e) {
                            console.warn("[QMLAppComponent:JsonLoader] Error parsing JSON in path");
                            error("Error parsing JSON in path");
                            root.status = eError
                        }
                    } else {
                        timeoutTimer.stop();
                        console.warn("[QMLAppComponent:JsonLoader] JSON Data not found at path");
                        error("JSON Data not found at path");
                        root.status = eError
                    }
                }
            }
        })(xhr);
        xhr.send();
        timeoutTimer.restart();
        root.status = eLoading
        console.info("[QmlAppComponents][JsonLoader] File read requested", _path);
    }
}
