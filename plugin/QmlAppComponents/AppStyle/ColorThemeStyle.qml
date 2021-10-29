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

QtObject {
    id: root

    property color mainTextColor: root.privateObject.mainTextColor
    property color subTextColor: root.privateObject.subTextColor

    property color borderlineColor: root.privateObject.borderlineColor
    property color vsKeyColor: root.privateObject.vsKeyColor
    property color grayBGColor: root.privateObject.grayBGColor
    property color seekBGColor: root.privateObject.seekBGColor
    property color vsGradientStart1: root.privateObject.vsGradientStart1
    property color vsGradientEnd1: root.privateObject.vsGradientEnd1

    property QtObject privateObject: QtObject {

        property color mainTextColor: colorObj[currentColorIndex].textColor5
        property color subTextColor: colorObj[currentColorIndex].textColor1
        property color borderlineColor: colorObj[currentColorIndex].objectColor1
        property color seekBGColor: colorObj[currentColorIndex].objectColor1
        property color vsKeyColor: colorObj[currentColorIndex].keyColor1

        property color grayBGColor: colorObj[currentColorIndex].bgColor2

        property color vsGradientStart1: colorObj[currentColorIndex].vsGradientStart1
        property color vsGradientEnd1: colorObj[currentColorIndex].vsGradientEnd1

        property int currentColorIndex: 0
        property var colorObj: [
            nightColor,
            dayColor
        ]

        property QtObject dayColor: QtObject {

        }
        property QtObject nightColor: QtObject {
            property color keyColor1: "#ff2d55"
            property color objectColor1: "white"
            property color bgColor1: "#333333"
            property color bgColor2: "#aaaaaa"
            property color bgColor3: "black"
            property color bgColor4: "#555555"
            property color bgColor5: "#aaaaaa"
            property color textColor1: "#aaaaaa"
            property color textColor2: "#888888"
            property color textColor3: "#222222"
            property color textColor4: "black"
            property color textColor5: "white"

            property color vsGradientStart1: "#9e00d8"
            property color vsGradientEnd1: "#f1304f"
        }
    }
}
