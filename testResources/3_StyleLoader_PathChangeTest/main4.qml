import QtQuick 2.4
import QmlAppComponents 0.2

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

    Component.onCompleted:  {
        var settings = {
            globalAppJsonPath: "/home/root/global/",
            globalAppJsonName: "style_global.json",
	    localAppJsonPathSuffix: "customization2/",
	    localAppJsonName: "style_myapp.json",
	    localAppJsonPath: "/home/root/customization3/",
            appPath: "/home/root/"
        }
        StyleLoader.updatePathSettings(settings);
    }
}
