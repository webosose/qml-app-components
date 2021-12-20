import QtQuick 2.4
import QmlAppComponents 0.1

Rectangle {
    width: 1920
    height: 1080
    color: StyleLoader.color("keyColor1")

    Image {
        width: 300
        height: 300
        source: StyleLoader.image("keyImage1");
        anchors.centerIn: parent
    }

    Component.onCompleted: {
        StyleLoader.setAppPath("/home/root/");
    }
}
