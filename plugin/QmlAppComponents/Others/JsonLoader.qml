/* @@@LICENSE
 *
 * Copyright (c) <2021> LG Electronics, Inc.
 *
 * Confidential computer software. Valid license from LG required for
 * possession, use or copying. Consistent with FAR 12.211 and 12.212,
 * Commercial Computer Software, Computer Software Documentation, and
 * Technical Data for Commercial Items are licensed to the U.S. Government
 * under vendor's standard commercial license.
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
