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
