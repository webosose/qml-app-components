
import QtQuick 2.4

LunaService {
    id: root

    signal appDataReceived();
    signal appDataUpdated();

    serviceName: "com.webos.settingsservice"

    property string category: "avnApp" // customize it
    property var appData: {"_noData": true}
    property DefaultSettingsValue defaultValue
    property int initializeToken: -1
    property int subscribeToken: -1
    property bool retryEnabled: true
    property var retryFunction
    property var retryDelay: 10000
    //property string

    Component.onCompleted: {
        var temp = defaultValue.applyScheme(defaultValue);
        appData = JSON.parse(JSON.stringify(temp));
    }
    onAppDataChanged: console.warn(JSON.stringify(appData));

    property ServiceStateNotifier serviceStateNotifier: ServiceStateNotifier {
        appId: root.appId
        targets: [root]
    }

    onConnected: {
        subscribe();
    }

    // flow
    /*
      connect
      -> try get data
      ---> if exists, establish connection.
      ---> if not exists, push initial value.
      */

    property Timer retryTimer: Timer {
        id: _retryTimer
        interval: retryDelay < 3000 ? 3000 : retryDelay
        onTriggered: {
            root.retryFunction();
        }
    }

    function updateData() {
        //var obj = defaultValue;
        var obj;

        console.info("trying update data");

        if (defaultValue === undefined) {
            console.warn("defaultValue is undefined, settings service unable");
            return;
        }

        obj = defaultValue.applyScheme(root.appData);

        return call("luna://" + serviceName + "/",
             "setSystemSettings",
             JSON.stringify({
                                "category":category,
                                "settings": obj
                            }));
    }

    function subscribe() {
        subscribeToken = call("luna://" + serviceName + "/",
             "getSystemSettings",
             JSON.stringify({"category":category, "subscribe":true}));
    }



    function initializeData() {
        //var obj = defaultValue;
        var obj;

        console.info("trying initialize data");

        if (defaultValue === undefined) {
            console.warn("defaultValue is undefined, settings service unable");
            return;
        }

        obj = defaultValue.applyScheme(defaultValue);

        return call("luna://" + serviceName + "/",
             "setSystemSettings",
             JSON.stringify({
                                "category":category,
                                "settings": obj
                            }));
    }

    onResponse: {
        var response = JSON.parse(payload);
        var _data;

        console.log(payload);

        switch (token) {
        case initializeToken:
            subscribe();
            break;
        case subscribeToken:
            if (response.settings !== undefined) {
                var previousData;
                var updatedData;

                _data = response.settings;
                previousData = JSON.stringify(appData);
                updatedData = JSON.stringify(defaultValue.applyScheme(_data));

                if (previousData !== updatedData) {
                    appData = JSON.parse(updatedData);
                    root.appDataUpdated();
                }
                root.appDataReceived();
            }
            else if (response.category === category && response.method === "getSystemSettings" &&
                              response.returnValue === false) {
                retryFunction = function() {
                    console.warn("initialize start...");
                    initializeToken = initializeData();
                }
                if ( root.retryEnabled === false ) {
                    retryTimer.restart();
                } else {
                    root.retryEnabled = false;
                    retryFunction();
                }
            }
            break;
        }
    }
}
