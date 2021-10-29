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
