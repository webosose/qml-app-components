/* @@@LICENSE
 *
 * Copyright (c) <2019-2020> LG Electronics, Inc.
 *
 * Confidential computer software. Valid license from LG required for
 * possession, use or copying. Consistent with FAR 12.211 and 12.212,
 * Commercial Computer Software, Computer Software Documentation, and
 * Technical Data for Commercial Items are licensed to the U.S. Government
 * under vendor's standard commercial license.
 *
 * LICENSE@@@ */

import QtQuick 2.4
import Eos.Controls 0.1

Item {
    id: root

    property var scrollChild
    property real maxHeight: appStyle.app.height
    property real maxWidth: appStyle.app.width
    property bool isVerticalScroll: true

    //clip: true

    Component.onCompleted: {
        if (isVerticalScroll) {
            height = Qt.binding(
                        function() {
                            if (scrollChild.childrenRect.height > (maxHeight - y))
                                return (maxHeight - y);
                            else
                                return scrollChild.childrenRect.height;
                        }
                    );
            scrollChild.flickableDirection = Flickable.VerticalFlick
        } else  {
            width = Qt.binding(
                        function() {

                            if (scrollChild.childrenRect.width > (maxWidth - x))
                                return (maxWidth - x);
                            else
                                return scrollChild.childrenRect.width;
                        }
                    );
            scrollChild.flickableDirection = Flickable.HorizontalFlick;
        }

    }

//    Button {
//        id: upButton
//        anchors.right: parent.right
//        anchors.top: parent.top
//        anchors.topMargin: 20
//        anchors.rightMargin: 60
//        width: 35
//        height: 35
//        iconSource: imageDir + "renderTemplate/scroll-up-nor.png"
//        style: IconButtonStyle {}
//        z: scrollChild.z + 1
//        visible: scrollChild.childrenRect.height > maxHeight
//        onClicked: {
////            scrollChild.contentY -= 30
//        }
//    }

//    Button {
//        id: downButton
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 50
//        anchors.rightMargin: 60
//        width: 35
//        height: 35
//        iconSource: imageDir + "renderTemplate/scroll-down-nor.png"
//        style: IconButtonStyle {}
//        z: scrollChild.z + 1
//        visible: scrollChild.childrenRect.height > maxHeight
//        onClicked: {
////            scrollChild.contentY += 30
//        }
//    }

    Item {
        id: scrollBarClipper
        anchors.right: parent.right
        anchors.rightMargin: 74
        width: 6
        height: parent.height - endYOffset - startYOffset
        y: startYOffset
        property real startYOffset: 63
        property real endYOffset: 98
        clip: true

        Rectangle {
            id: scrollbar
            visible: scrollChild.childrenRect.height > maxHeight
            y: scrollChild.visibleArea.yPosition * (scrollChild.height - scrollBarClipper.startYOffset - scrollBarClipper.endYOffset)
            width: 6
            radius: 3
            height: scrollChild.visibleArea.heightRatio * (scrollChild.height - scrollBarClipper.startYOffset - scrollBarClipper.endYOffset)
            color: "#373737"
        }
    }
}
