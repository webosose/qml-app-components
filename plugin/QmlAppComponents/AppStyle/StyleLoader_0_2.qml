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

pragma Singleton
import QtQuick 2.4
import QmlAppComponents 0.1

Item {
    id: root
    // private. underbar(_) in front of variable name may prevent to redefine from outside of this file.

    // Other setting values
    readonly property string _logHeader: "[QmlAppComponents][StyleLoader] "
    readonly property color _defaultColor: "transparent"
    readonly property int _defaultNumber: 0
    readonly property string _defaultString: ""
    readonly property string _defaultImage: "./noimage.png"
    readonly property string _defaultQmlComponent: "./NoComponent.qml"
    readonly property string _baseStyleId: "default" // BaseStyleId -> common style Id, base name of styleId obj

    // Change-able setting values.
    property string _defaultStyleId: _baseStyleId // styleId that if user does not requested specific styleId

    // Paths
    readonly property url _defaultGlobalStyleJsonUrl: Qt.resolvedUrl("/home/root/");
    readonly property url _defaultLocalAppJsonPath: _appPath + _localJsonPathSuffix
    readonly property url _emptyUrl: Qt.resolvedUrl("");
    readonly property string _defaultAppJsonName: "style.json"
    readonly property string _defaultLocalJsonPathSuffix: "customization/"

    readonly property string _globalAppJsonUrl: _globalAppJsonPath + _globalAppJsonName;
    readonly property string _localAppJsonUrl: Qt.resolvedUrl(_localAppJsonPath) + _localAppJsonName;

    // Change-able paths. Can changed by updatePathSettings,
    // And also appPath can be changed by setAppPathas a legacy support.
    // resourcePath can be changed by setResourcePath

    property string _globalAppJsonName: _defaultAppJsonName
    property string _localAppJsonName: _defaultAppJsonName
    property string _localJsonPathSuffix: _defaultLocalJsonPathSuffix

    property url _globalAppJsonPath: _defaultGlobalStyleJsonUrl
    property url _localAppJsonPath: _defaultLocalAppJsonPath
    // _localAppJsonPath will be "/usr/palm/applications/appId/customization/", for default qml-runner based app

    // Note : Tricky way to find application path
    // Note : This will not works to LSM loaded apps like quicksettings.
    property url _appPath: getQmlRunnerDependentAppPath()

    // ResourcePath : path for image, qmlComponent.
    property url _resourcePath: _appPath



    // Signal to update data.
    signal moduleSettingsUpdated()
    signal localAppJsonPathUpdated()

    // About 'baseObject'
    // common and local is just for reserve, and unified is the one that prepared for user.
    // object ----- common : {styleId...color1...color2...}
    //          I
    //          --- local : {localStyleId...color1-1...color2-1
    //          I
    //          --- unified ----- default(_baseStyleId) : copy common to here
    //                        I
    //                        --- localStyleId : copy common to here, and overrite local to here
    property var baseObject: {"common":"", "local":{}, "unified": {}}

    // unifiedObject : reserved for future
    property var unifiedObject: {"empty":true}

    // Loaded is necessary to return default value if json is not loaded yet.
    readonly property bool loaded: jsonLoader_common.isLoaded() && jsonLoader_app.isLoaded()
    onLoadedChanged: { console.debug(_logHeader + "loaded changed to", loaded); }

    JsonLoader {
        id: jsonLoader_common
        Component.onCompleted: {
            // Trigger common json loader
            if (_globalAppJsonUrl !== _emptyUrl) {
                requestJsonObject(_globalAppJsonUrl);
            }
        }
        onJsonObjectReceived: {
            baseObject["common"] = result;
            baseObject["unified"] = {};
            // Trigger app json loader
            // App json loader always need to be triggered after common json loader
            jsonLoader_app.initStyleObjectBeforeMerge(); // Make initial one for if app local json not available
            console.debug(_logHeader + "Common style object set,", JSON.stringify(baseObject));
            jsonLoader_app.requestJsonObject(_localAppJsonUrl);
        }
        onError: {
            console.warn(_logHeader + "Got error during read common json", errString);

            console.warn(_logHeader + "Try to read local app style json");
            baseObject["common"] = {};
            baseObject["unified"] = {};
            jsonLoader_app.initStyleObjectBeforeMerge(); // Make initial one for if app local json not available
            console.debug(_logHeader + "Common style object set,", JSON.stringify(baseObject));
            jsonLoader_app.requestJsonObject(_localAppJsonUrl);
        }

        // Re-trigger json loader if json path, filename changed.
        Connections {
            target: root
            onModuleSettingsUpdated: {
                if (_globalAppJsonUrl !== _emptyUrl) {
                    jsonLoader_common.requestJsonObject(_globalAppJsonUrl);
                }
            }
        }
    }

    JsonLoader {
        id: jsonLoader_app

        function initStyleObjectBeforeMerge(_styleId) {
            // roll back merged 'unified/common' to 'common', it means
            // initialize unified(merged) area -> styleId
            // "common" is reserved for default style.

            var styleId = _styleId;

            // initialize styleId object as default one, for fall-back logic.
            if (styleId === undefined || styleId === "")
                styleId = _baseStyleId;
            baseObject["unified"][styleId] = {};
            baseObject["unified"][styleId] = baseObject["common"];
        }
        onJsonObjectReceived: {
            // styleId is mandatory in json file

            var styleId = result.styleId;
            if (styleId === undefined || styleId === "")
                styleId = _baseStyleId;

            jsonLoader_app.initStyleObjectBeforeMerge(styleId); // TODO : this routine has conflict with Object.assign routine.

            // local is reserved for keep original value of app local json file.
            // Currently, allows one style json per 1 application process.
            baseObject["local"] = result;
            baseObject["unified"][styleId] = {}; //initialize object
            Object.assign(baseObject["unified"][styleId], baseObject["common"], baseObject["local"]);
            console.debug(_logHeader + "Style object set,", JSON.stringify(baseObject));
        }
        onError: {
            console.warn(_logHeader + "Got error during read app local json", errString);
        }

        // Re-trigger json loader if json path, filename changed.
        Connections {
            target: root
            onLocalAppJsonPathUpdated: {
                baseObject["unified"] = {};
                jsonLoader_app.initStyleObjectBeforeMerge(); // Make initial one for if app local json not available
                jsonLoader_app.requestJsonObject(_localAppJsonUrl);
            }
        }
    }

    // get Value By Key, internal API
    function _getValue(key, styleId, objectName) {
        var targetObject
        // check common json if app json not available
        if (styleId !== undefined) {
            targetObject = baseObject["unified"][styleId]
        } else {
            targetObject = baseObject["unified"][_baseStyleId]
        }

        // fall back managed by json merging - check "assign" function.
        return targetObject[key];
    }

    // to prevent error/warning, make functionfor each supported type.
    // following APIs are opened to developer

    function color(_key, _styleId, _objectName) { return getColor(_key, _styleId, _objectName); }
    function getColor(_key, _styleId, _objectName) {
        var styleId = _styleId;
        var defaultValue = _defaultColor;
        if (!loaded)
            return defaultValue;
        if (_defaultStyleId !== "" && styleId === undefined)
            styleId = _defaultStyleId;
        var result = _getValue(_key, styleId, _objectName)
        if (result === undefined)
            return defaultValue;
        else
            return result;
    }

    function number(_key, _styleId, _objectName) { return getNumber(_key, _styleId, _objectName); }
    function getNumber(_key, _styleId, _objectName) {
        var styleId = _styleId;
        var defaultValue = _defaultNumber;
        if (!loaded)
            return defaultValue;
        if (_defaultStyleId !== "" && styleId === undefined)
            styleId = _defaultStyleId;
        var result = _getValue(_key, styleId, _objectName)
        if (result === undefined)
            return defaultValue;
        else
            return result;
    }

    function string(_key, _styleId, _objectName) { return getString(_key, _styleId, _objectName); }
    function getString(_key, _styleId, _objectName) {
        var styleId = _styleId;
        var defaultValue = _defaultString;
        if (!loaded)
            return defaultValue;
        if (_defaultStyleId !== "" && styleId === undefined)
            styleId = _defaultStyleId;
        var result = _getValue(_key, styleId, _objectName)
        if (result === undefined)
            return defaultValue;
        else
            return result;
    }

    /*
      image / getImage function
      default return : noimage.png in component location.
      */
    function image(_key, _styleId, _objectName) { return getImage(_key, _styleId, _objectName); }
    function getImage(_key, _styleId, _objectName) {
        var styleId = _styleId;
        // Note : Be careful when use Qt.resolvedUrl or 'url' type,
        // because it points the location that this file is in.
        var defaultValue = Qt.resolvedUrl(_defaultImage);
        if (!loaded)
            return defaultValue;
        if (_defaultStyleId !== "" && styleId === undefined)
            styleId = _defaultStyleId;
        var result = _getValue(_key, styleId, _objectName)
        if (result === undefined)
            return defaultValue;
        else
            return _resourcePath + result;
    }

    function qmlFile(_key, _styleId, _objectName) { return getQmlFile(_key, _styleId, _objectName); }
    function getQmlFile(_key, _styleId, _objectName) {
        var styleId = _styleId;
        // Note : Be careful when use Qt.resolvedUrl or 'url' type,
        // because it points the location that this file is in.
        var defaultValue = Qt.resolvedUrl(_defaultQmlComponent);

        if (!loaded)
            return defaultValue;
        if (_defaultStyleId !== "" && styleId === undefined)
            styleId = _defaultStyleId;
        var result = _getValue(_key, styleId, _objectName)
        if (result === undefined)
            return defaultValue;
        else
            return _resourcePath + result;
    }

    // Note : for future 1. - return delegate (component)
    // Note : for future 2. - return object itself. param - container (for anchors.fill)
    property var qmlObjectList: []

    // Just return component, and let user to use it.
    function qmlComponent(_key, _styleId, _objectName) {
        var qmlFileUrl = getQmlFile(_key, _styleId, _objectName);
        var component = Qt.createComponent(qmlFileUrl);

        return component;
    }

    // Return completed qml object.
    function qmlObject(_key, _parent, _styleId, _objectName) {
        var qmlFileUrl = getQmlFile(_key, _styleId, _objectName);
        var component = Qt.createComponent(qmlFileUrl);
        var childObjet = null

        var obj = {"id":qmlObjectList.length + 1, "component":component, "parent":_parent, "obj": childObjet, "purpose": "object"};
        qmlObjectList.push(obj);

        if (component.status === Component.Ready)
            finalizeQmlCreation(component);
        else
            component.statusChanged.connect(finalizeQmlCreation);

        return childObjet; // Note : this should be binded into property
    }

    function finalizeQmlCreation(component) {
        // search
        var i;
        var result;
        var obj;
        for (i = 0 ; i < qmlObjectList.length ; i++) {
            if (qmlObjectList[i].component === component)
                break;
        }

        if (i >= qmlObjectList.length) {
            console.warn(_logHeader + "Component list not matching");
            return;
        }
        obj = qmlObjectList[i];

        if (component.status === Component.Ready) {
            result = component.createObject(obj.parent);
            result.width = result.parent.width
            result.height = result.parent.height
            obj.obj = result;
            qmlObjectList.splice(i, 1); // pop created component
            // Even if we popped, object may already binded into parent's property.
            // Ex) property Item childObj: qmlObject(...);
        } else if (component.status === Component.Error) {
            // Error Handling
            console.warn(_logHeader + "Error creating customized qml object", component.errorString(), qmlObjectList[i].parent, qmlObjectList[i].id);
        }
    }

    // From here, module setup functions.
    // setup-targets
    /*
      _defaultStyleId : set "styleId", by default, it set as "default"
      _localJsonPathSuffix : default value is "customization/" and it means path-suffix for localAppJson
      _appPath : default app installed path. for qml-runner app, receive path from sam (so sam dependent)
                 but for native application, we need to set this as manually
      _resourcePath : same as default app installed path. separated from apppath to manage resource path.

    _defaultAppJsonName: "style.json"
         - default filename
    _localAppJsonName: _defaultAppJsonName
         - default filename for local app json.
    _globalAppJsonName: _defaultAppJsonName
         - default filename for common style json.
    _globalAppJsonPath
    _localAppJsonPath
      */

    function updatePathSettings(settingsObj) {
        var globalStyleModified = false;
        var localAppStyleModified = false;

        if (settingsObj.localAppJsonName !== undefined) {
            _localAppJsonName = settingsObj.localAppJsonName;
            localAppStyleModified = true;
        }
        if (settingsObj.globalAppJsonName !== undefined) {
            _globalAppJsonName = settingsObj.globalAppJsonName;
            globalStyleModified = true;
        }
        if (settingsObj.globalAppJsonPath !== undefined) {
            _globalAppJsonPath = settingsObj.globalAppJsonPath;
            globalStyleModified = true;
        }

        if (settingsObj.localAppJsonPath !== undefined) {
            _localAppJsonPath = settingsObj.localAppJsonPath;
            localAppStyleModified = true;
        }

        if (settingsObj.localAppJsonPathSuffix !== undefined) {
            var suffix = settingsObj.localAppJsonPathSuffix;
            if (suffix[suffix.length - 1] !== "/") {
                console.warn(_logHeader + "Suffix MUST formatted as 'suffix/'. your suffix is", suffix);
            }
            if (suffix.includes(' ')) {
                console.warn(_logHeader + "Suffix DO NOT allow space. your suffix is", suffix);
            }
            _localJsonPathSuffix = suffix;
            localAppStyleModified = true;
        }

        if (settingsObj.appPath !== undefined) {
            var appPath = Qt.resolvedUrl(settingsObj.appPath);
            if (appPath[appPath.length - 1] !== "/")
                appPath += "/";
            console.log(_logHeader + "App path set to", appPath);
            _appPath = appPath;
            localAppStyleModified = true;
        }

        if (globalStyleModified)
            moduleSettingsUpdated();
        else if (localAppStyleModified)
            localAppJsonPathUpdated();
    }

    // Not available now
    function addAppStyleJson(styleId, url) {
        appJsonUrlList.push({"url":Qt.resolvedUrl(url)})
    }

    // Not recommended now
    function setDefaultStyleId(styleId) {
        _defaultStyleId = styleId;
    }

    // Now it became legacy, becuase we released 'one shot' path setup method, updateModuleSettings()
    function setAppPath(url) {
        var appPath = Qt.resolvedUrl(url);
        if (appPath[appPath.length - 1] !== "/")
            appPath += "/";
        console.log(_logHeader + "App path set to", appPath);
        console.warn(_logHeader + "setAppPath deprecated. We support it as legacy, but ARE NOT PROMISE this function always keep working.");
        _appPath = appPath;

        // We used "~changed" option before, but now changed as separated signal.
        // To support legacy code working, I put this signal call here.
        localAppJsonPathUpdated();
    }

    function setResourcePath(url) {
        var resourcePath = Qt.resolvedUrl(url);
        if (resourcePath[resourcePath.length - 1] !== "/")
            resourcePath += "/";
        console.log(_logHeader + "Resource path set to", resourcePath);
        _resourcePath = resourcePath;
    }

    function getQmlRunnerDependentAppPath() {
        if (Qt.application == undefined) {
            console.warn(_logHeader + "appPath not available. Please set manually, by Style.setAppPath()");
            return Qt.resolvedUrl("./");
        }
        if (Qt.application.arguments == undefined) {
            console.warn(_logHeader + "appPath not available. Please set manually, by Style.setAppPath()");
            return Qt.resolvedUrl("./");
        }
        if (Qt.application.arguments.length < 2) { // Normally, it means it's system ui loaded by LSM, or some "special" native Qt based application.
            console.warn(_logHeader + "appPath not available. (Not a qml-runner based app?) Please set manually, by Style.setAppPath()");
            return Qt.resolvedUrl("./");
        }

        // Note : Because of this logic, this module has dependency toward SAM <-> qml-runner interface.
        var mainFilePath;
        try {
            mainFilePath = JSON.parse(Qt.application.arguments[1]).main;
        } catch (e) {
            console.warn(_logHeader + "AppPath parsing for qml-runner failed.", e);
        }
        // mainFilePath will be "/usr/palm/applications/appId/main.qml"

        if (mainFilePath === undefined) {// argument is not matching with qml-runner based app.
            console.warn(_logHeader + "appPath not available. (Not a qml-runner based app?) Please set manually, by Style.setAppPath()");
            return Qt.resolvedUrl("./");
        }

        var appPath = mainFilePath.substring(0, mainFilePath.lastIndexOf("/") + 1);
        // appPath will be "/usr/palm/applications/appId/"
        return appPath;
    }
}
