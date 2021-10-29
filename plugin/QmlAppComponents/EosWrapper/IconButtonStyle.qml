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
import Eos.Style 0.1

ButtonStyle {
    id: root
    buttonFontSize: 20
    buttonHorizontalPadding: 1
    buttonVerticalPadding: 1

    buttonBackgroundColor: "transparent"
    buttonBorderColor: "transparent"

    buttonBackgroundFocusedColor: "transparent"
    buttonBorderFocusedColor: "transparent"

    buttonBackgroundPressedColor: "#40B3Ccf8"
    buttonBorderPressedColor: "transparent"

    property real radius: 0

    backgroundItem: Rectangle {
        property Item controlRoot: (parent && parent.parent) ? parent.parent : null

        color: controlRoot != null ? controlRoot.color : "transparent"
        border.width: controlRoot != null ? controlRoot.border.width : 0
        border.color: controlRoot != null ? controlRoot.border.color : "transparent"

        anchors.fill: parent
        antialiasing: true
        radius: root.radius

        //radius: height / 2
    }
}
