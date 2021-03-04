import QtQuick 2.4

Rectangle {
    id: root
    z:99

    anchors.fill:parent;color:"transparent";border.width:3;border.color:"red"

    Text {
        anchors.fill: parent
        color:"red"
        font.pixelSize: 30
        text: "coordinate: " + root.x / appStyle.scale + " " + root.y / appStyle.scale + "\n" + "width: " + root.width / appStyle.scale + "\nheight: " + root.height / appStyle.scale
    }
}
