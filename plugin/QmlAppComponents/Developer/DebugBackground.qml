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

Rectangle {
    id: root

    property string name: parent.objectName
    anchors.fill: parent
    color: "#DDDDDD"
    objectName: "ignore"
    property string uniqueKey: root
    property int uniqueNum1: 0
    property int uniqueNum2: 0
    clip: true
    visible: appRoot.debugMode//false//true
    property bool textVisible: debugMode

    Component.onCompleted: {
        // Make random bg color.

        var red,green,blue,num1,num2 = "";
        uniqueKey = Qt.md5(root)
        red = uniqueKey.slice(0,2);
        green = uniqueKey.slice(2,4);
        blue = uniqueKey.slice(4,6);
        num1 = uniqueKey.slice(6,8);
        num2 = uniqueKey.slice(8,10);
        uniqueNum1 = parseInt(num1,16)
        uniqueNum2 = parseInt(num2,16)
        root.color = "#" + red + green + blue;
        root.color = Qt.lighter(root.color, 0.3);
    }

    border.width: 3
    border.color: "black"

    Flow {
        visible: root.textVisible
        width: parent.width + 200 + 256
        height: parent.height + 200 + 256
        x: -1 * root.uniqueNum1
        y: -1 * root.uniqueNum2
        objectName: "ignore"
        Repeater {
            model: 999
            Text {
                rotation: 45
                width: 140 + root.uniqueNum1 / 10
                height: 140 + root.uniqueNum1 / 10
                text: root.name
                font.pixelSize: 20
                color:"#00FF00"
            }
        }
    }
}
