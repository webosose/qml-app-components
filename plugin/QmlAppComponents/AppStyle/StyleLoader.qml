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

pragma Singleton
import QtQuick 2.4
import QmlAppComponents 0.1

Item {
    // private
    readonly property url testUrl: "/home/root/style.json"
    readonly property url _defaultJsonUrl: Qt.resolvedUrl(testUrl);
    readonly property url styleJsonUrl: Qt.resolvedUrl(_defaultJsonUrl);
    readonly property url _emptyUrl: Qt.resolvedUrl("");
    property string appJsonUrl: Qt.resolvedUrl("/home/root/localstyle.json");
    property var appJsonUrlList: [
        {
            "url":Qt.resolvedUrl("/home/root/localstyle.json")
        }
    ]
    property var baseObject: {"common":"", "local":{}, "unified": {}}
    property var unifiedObject: {"empty":true}
    readonly property string defaultAppId: "common"
    readonly property bool loaded: jsonLoader_common.isLoaded()// && jsonLoader_app.isLoaded()
    onLoadedChanged: { console.info("[QmlAppComponents][StyleLoader] loaded changed to", loaded); }
    property color _defaultColor: "transparent"
    property int _defaultNumber: 0
    property string _defaultString: ""
    property string defaultStyleId: ""

    // public
    // N/A

    JsonLoader {
        id: jsonLoader_common
        Component.onCompleted: {
            // Trigger common json loader
            if (styleJsonUrl !== _emptyUrl) {
                requestJsonObject(styleJsonUrl);
            }
        }
        onJsonObjectReceived: {
            baseObject["common"] = result;
            baseObject["unified"]["common"] = baseObject["common"];
            // Trigger app json loader
            // App json loader always triggered after common json loader
            if (appJsonUrlList.length > 0) {
                for (var i = 0 ; i < appJsonUrlList.length; i++) {
                    // currently, multiple app json load is not working properly, only for 1.
                    // This routine will not work for list more than 1 app/url pair.
                    jsonLoader_app.requestJsonObject(appJsonUrlList[i].url);
                }
            }
        }
        onError: {
            console.warn("[QmlAppComponents][StyleLoader] Got error during read common json", errString);
        }
    }

    //Dynamic change not provided for current version.
//    onAppJsonUrlChanged: {
//        // Always common json is first, app is next.
//        if (loaded)
//            jsonLoader_app.requestJsonObject(appJsonUrl);
//    }

    JsonLoader {
        id: jsonLoader_app
        onJsonObjectReceived: {
            // styleId is mandatory
            var styleId = result.styleId;
            baseObject["local"][styleId] = result;
            baseObject["unified"][styleId] = {}; //initialize object
            Object.assign(baseObject["unified"][styleId], baseObject["common"], baseObject["local"][styleId]);
        }
        onError: {
            console.warn("[QmlAppComponents][StyleLoader] Got error during read app local json", errString);
        }
    }

    // get Value By Key, internal API
    function _getValue(key, styleId, objectName) {
        var targetObject
        // check common json if app json not available
        if (styleId !== undefined) {
            targetObject = baseObject["unified"][styleId]
        } else {
            targetObject = baseObject["unified"][defaultAppId]
        }

        // fall back managed by json merging - check "assign" function.
        return targetObject[key];
    }

    // to prevent error/warning, make functionfor each supported type.
    // following APIs are opened to developer

    function addAppStyleJson(styleId, url) {
        appJsonUrlList.push({"url":Qt.resolvedUrl(url)})
    }

    function setDefaultStyleId(styleId) {
        defaultStyleId = styleId;
    }

    function color(_key, _styleId, _objectName) { getColor(_key, _styleId, _objectName); }
    function getColor(_key, _styleId, _objectName) {
        var styleId = _styleId;
        var defaultValue = _defaultColor;
        if (!loaded)
            return defaultValue;
        if (defaultStyleId !== "" && styleId === undefined)
            styleId = defaultStyleId;
        var result = _getValue(_key, styleId, _objectName)
        if (result === undefined)
            return defaultValue;
        else
            return result;
    }

    function number(_key, _styleId, _objectName) { getNumber(_key, _styleId, _objectName); }
    function getNumber(_key, _styleId, _objectName) {
        var styleId = _styleId;
        var defaultValue = _defaultNumber;
        if (!loaded)
            return defaultValue;
        if (defaultStyleId !== "" && styleId === undefined)
            styleId = defaultStyleId;
        var result = _getValue(_key, styleId, _objectName)
        if (result === undefined)
            return defaultValue;
        else
            return result;
    }

    function string(_key, _styleId, _objectName) { getString(_key, _styleId, _objectName); }
    function getString(_key, _styleId, _objectName) {
        var styleId = _styleId;
        var defaultValue = _defaultString;
        if (!loaded)
            return defaultValue;
        if (defaultStyleId !== "" && styleId === undefined)
            styleId = defaultStyleId;
        var result = _getValue(_key, styleId, _objectName)
        if (result === undefined)
            return defaultValue;
        else
            return result;
    }
}
