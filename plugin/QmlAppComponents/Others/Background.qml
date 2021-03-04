import QtQuick 2.4

Rectangle {
    id: root
    objectName: parent.objectName + "_background"
    anchors.fill: parent
    color: "black"
    property string name: parent.objectName

    DebugBackground {
        id: debugBG
        anchors.fill: parent
        name: root.name
    }

}
