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
    // private
    readonly property url testUrl: "/home/root/style.json"
    readonly property url _defaultJsonUrl: Qt.resolvedUrl(testUrl);
    readonly property url styleJsonUrl: Qt.resolvedUrl(_defaultJsonUrl);
    readonly property url _emptyUrl: Qt.resolvedUrl("");
    property string appJsonUrl: Qt.resolvedUrl(appCustomizationPath) + "style.json";

    // About 'baseObject'
    // common and local is just for reserve, and unified is the one that prepared for user.
    // object ----- common : {styleId...color1...color2...}
    //          I
    //          --- local : {localStyleId...color1-1...color2-1
    //          I
    //          --- unified ----- default(baseStyleId) : copy common to here
    //                        I
    //                        --- localStyleId : copy common to here, and overrite local to here
    property var baseObject: {"common":"", "local":{}, "unified": {}}

    // unifiedObject : reserved for future
    property var unifiedObject: {"empty":true}

    // baseStyleId is default styleId for all case. In normal case, user do not need to change this.
    readonly property string baseStyleId: "default" // BaseStyleId -> common style Id, base name of styleId obj

    // Loaded is necessary to return default value if json is not loaded yet.
    readonly property bool loaded: jsonLoader_common.isLoaded() && jsonLoader_app.isLoaded()
    onLoadedChanged: { console.debug("[QmlAppComponents][StyleLoader] loaded changed to", loaded); }
    property color _defaultColor: "transparent"
    property int _defaultNumber: 0
    property string _defaultString: ""
    property string defaultStyleId: baseStyleId // styleId that if user does not requested specific styleId
    property string _defaultImage: "./noimage.png"
    property string _defaultQmlComponent: "./NoComponent.qml"

    // Note : Tricky way to find application path
    // Note : This will not works to LSM loaded apps like quicksettings.
    property url _appPath: getQmlRunnerDependentAppPath()

    // ResourcePath : path for image, qmlComponent.
    property url _resourcePath: _appPath

    readonly property url appCustomizationPath: _appPath + "customization/"
    onAppCustomizationPathChanged: console.log("[QmlAppComponents][StyleLoader] App customization path changed into", appCustomizationPath);
    // appCustomizationPath will be "/usr/palm/applications/appId/customization/", for default qml-runner based app

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
            baseObject["unified"] = {};
            // Trigger app json loader
            // App json loader always need to be triggered after common json loader
            jsonLoader_app.initStyleObjectBeforeMerge(); // Make initial one for if app local json not available
            console.debug("[QmlAppComponents][StyleLoader] Common style object set,", JSON.stringify(baseObject));
            jsonLoader_app.requestJsonObject(appJsonUrl);
        }
        onError: {
            console.warn("[QmlAppComponents][StyleLoader] Got error during read common json", errString);

            console.warn("[QmlAppComponents][StyleLoader] Try to read local app style json");
            baseObject["common"] = {};
            baseObject["unified"] = {};
            jsonLoader_app.initStyleObjectBeforeMerge(); // Make initial one for if app local json not available
            console.debug("[QmlAppComponents][StyleLoader] Common style object set,", JSON.stringify(baseObject));
            jsonLoader_app.requestJsonObject(appJsonUrl);
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
                styleId = baseStyleId;
            baseObject["unified"][styleId] = {};
            baseObject["unified"][styleId] = baseObject["common"];
        }
        onJsonObjectReceived: {
            // styleId is mandatory in json file

            var styleId = result.styleId;
            if (styleId === undefined || styleId === "")
                styleId = baseStyleId;

            jsonLoader_app.initStyleObjectBeforeMerge(styleId); // TODO : this routine has conflict with Object.assign routine.

            // local is reserved for keep original value of app local json file.
            // Currently, allows one style json per 1 application process.
            baseObject["local"] = result;
            baseObject["unified"][styleId] = {}; //initialize object
            Object.assign(baseObject["unified"][styleId], baseObject["common"], baseObject["local"]);
            console.debug("[QmlAppComponents][StyleLoader] Style object set,", JSON.stringify(baseObject));
        }
        onError: {
            console.warn("[QmlAppComponents][StyleLoader] Got error during read app local json", errString);
        }

        // Re-trigger json loader if appJson path changed.
        Connections {
            target: root
            onAppCustomizationPathChanged: {
                baseObject["unified"] = {};
                jsonLoader_app.initStyleObjectBeforeMerge(); // Make initial one for if app local json not available
                jsonLoader_app.requestJsonObject(appJsonUrl);
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
            targetObject = baseObject["unified"][baseStyleId]
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

    function color(_key, _styleId, _objectName) { return getColor(_key, _styleId, _objectName); }
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

    function number(_key, _styleId, _objectName) { return getNumber(_key, _styleId, _objectName); }
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

    function string(_key, _styleId, _objectName) { return getString(_key, _styleId, _objectName); }
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
        if (defaultStyleId !== "" && styleId === undefined)
            styleId = defaultStyleId;
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
        if (defaultStyleId !== "" && styleId === undefined)
            styleId = defaultStyleId;
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
            console.warn("[QmlAppComponents][StyleLoader] Component list not matching");
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
            console.warn("[QmlAppComponents][StyleLoader] Error creating customized qml object", component.errorString(), qmlObjectList[i].parent, qmlObjectList[i].id);
        }
    }

    function setAppPath(url) {
        var appPath = Qt.resolvedUrl(url);
        if (appPath[appPath.length - 1] !== "/")
            appPath += "/";
        console.log("[QmlAppComponents][StyleLoader] App path set to", appPath);
        _appPath = appPath;
    }

    function setResourcePath(url) {
        var resourcePath = Qt.resolvedUrl(url);
        if (resourcePath[resourcePath.length - 1] !== "/")
            resourcePath += "/";
        console.log("[QmlAppComponents][StyleLoader] Resource path set to", resourcePath);
        _resourcePath = resourcePath;
    }

    function getQmlRunnerDependentAppPath() {
        if (Qt.application == undefined) {
            console.warn("[QmlAppComponents][StyleLoader] appPath not available. Please set manually, by Style.setAppPath()");
            return Qt.resolvedUrl("./");
        }
        if (Qt.application.arguments == undefined) {
            console.warn("[QmlAppComponents][StyleLoader] appPath not available. Please set manually, by Style.setAppPath()");
            return Qt.resolvedUrl("./");
        }
        if (Qt.application.arguments.length < 2) { // Normally, it means it's system ui loaded by LSM, or some "special" native Qt based application.
            console.warn("[QmlAppComponents][StyleLoader] appPath not available. (Not a qml-runner based app?) Please set manually, by Style.setAppPath()");
            return Qt.resolvedUrl("./");
        }

        // Note : Because of this logic, this module has dependency toward SAM <-> qml-runner interface.
        var mainFilePath = JSON.parse(Qt.application.arguments[1]).main
        // mainFilePath will be "/usr/palm/applications/appId/main.qml"

        if (mainFilePath == undefined) {// argument is not matching with qml-runner based app.
            console.warn("[QmlAppComponents][StyleLoader] appPath not available. (Not a qml-runner based app?) Please set manually, by Style.setAppPath()");
            return Qt.resolvedUrl("./");
        }

        var appPath = mainFilePath.substring(0, mainFilePath.lastIndexOf("/") + 1);
        // appPath will be "/usr/palm/applications/appId/"
        return appPath;
    }
}
