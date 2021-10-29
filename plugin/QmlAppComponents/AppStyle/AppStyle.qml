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

    readonly property var styleRoot: root

    // Not sure but I hope this readonly may better than just binding formula.
    readonly property real scale: width / baseWidth
    readonly property real widthScale: width / baseWidth
    readonly property real heightScale: height / baseHeight

    property int baseWidth: 1920
    property int baseHeight: 720
    property int width: baseWidth * 1.5
    property int height: baseHeight * 1.5


    function bindScale(value) {
        return Qt.binding(
                    function() {
                        return root.adjScale(value)
                    }
                    );
    }

    function adjScale(value) {
        return value * root.scale
    }

    function relativeXBasedOnFHD(value) {
        return relativeX(value / baseWidth);
    }

    function relativeYBasedOnFHD(value) {
        return relativeY(value / baseHeight);
    }

    function relativeX(value) {
        return value * width
    }

    function relativeY(value) {
        return value * height
    }

    property QtObject app: QtObject {
        property color bgColor: "gray"
    }

    //property SubStyle font: SubStyle{}
    property FontStyle engFont: FontStyle {}

    property ColorThemeStyle colors: ColorThemeStyle {}


}
