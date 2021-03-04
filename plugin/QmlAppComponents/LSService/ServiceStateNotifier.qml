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
