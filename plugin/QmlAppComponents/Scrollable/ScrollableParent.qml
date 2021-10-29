/* @@@LICENSE
*
*      Copyright (c) 2019-2021 LG Electronics, Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
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
