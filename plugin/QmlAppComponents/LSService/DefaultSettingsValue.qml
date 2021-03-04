import QtQuick 2.4

QtObject {
    id: root

    property var ignoreList: {"objectName":true, "ignoreList":true}

    // cut value by scheme
    function applyScheme(value) {
        var i;
        var temp = JSON.parse(JSON.stringify(value))
        var keys = [];
        var data = {};

        for (var k in temp) {
            if (ignoreList[k] === undefined || ignoreList[k] === false)
                data[k] = temp[k];
        }

        return data;
    }
}
