import QtQuick 2.4
import Eos.Controls 0.1

Button {
    id: root
    // Note : be careful that EOS has IconButtonStyle!
    style: IconButtonStyle {radius: root.radius}

    implicitHeight: height
    implicitWidth: width

    property real forceIconWidth: 0
    property real forceIconHeight: 0
    property real radius: 0


    // Temporary for button Object bug
    Component.onCompleted: {
        if (forceIconWidth > 0)
            root.children[3].children[0].width = Qt.binding(function() {return root.forceIconWidth});
        else
            root.children[3].children[0].width = Qt.binding(function() {return appStyle.adjScale(root.children[3].children[0].sourceSize.width)});

        if (forceIconHeight > 0)
            root.children[3].children[0].height = Qt.binding(function() {return root.forceIconHeight});
        else
            root.children[3].children[0].height = Qt.binding(function() {return appStyle.adjScale(root.children[3].children[0].sourceSize.height)});
    }
}
