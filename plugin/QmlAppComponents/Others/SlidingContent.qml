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

Item {
    id: root

    property var nextSource: ""
    property var currentSource: ""
    property var source: ""
    property bool invertAnimation: false
    property alias content: clipper.content
    property int animationDuration: 150

    signal contentHided()

    function open() {
        state = "opening";
        currentSource = source;
    }

    function close() {
        state = "closing";
    }

    function change(_source) {
        state = "opened";
        state = "changing_closing";
        currentSource = nextSource
        nextSource = _source;
    }

    onSourceChanged: {
        change(source);
    }

    state: "closed"
    states: [
        State {
            name: "opening"
            PropertyChanges {
                target: content
                y: 0
            }
        },
        State {
            name: "opened"
            PropertyChanges {
                target: content
                y: 0
            }
        },
        State {
            name: "changing_closing"
            PropertyChanges {
                target: content
                y: height * (invertAnimation ? -1 : 1)
            }
        },
        State {
            name: "closing"
            PropertyChanges {
                target: content
                y: height * (invertAnimation ? -1 : 1)
            }
        },
        State {
            name: "closed"
            PropertyChanges {
                target: content
                y: height * (invertAnimation ? -1 : 1)
            }
        }
    ]

    transitions: [
        Transition {
            to: "closing"
            SequentialAnimation {
                NumberAnimation { properties: "y"; easing.type: Easing.OutQuart; duration: animationDuration }
                ScriptAction { script: {state = "closed";}}
            }
        },
        Transition {
            to: "opening"
            SequentialAnimation {
                NumberAnimation { properties: "y"; easing.type: Easing.OutQuart; duration: animationDuration }
                ScriptAction { script: {state = "opened";}}
            }
        },
        Transition {
            to: "changing_closing"
            SequentialAnimation {
                NumberAnimation { properties: "y"; easing.type: Easing.OutQuart; duration: animationDuration }
                ScriptAction {
                    script: {
                        currentSource = nextSource;
                        root.contentHided();
                        open();
                    }
                }
            }
        }
    ]

    Item {
        id: clipper

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: content.height
        clip: true
        property Item content

        onContentChanged: {
            content.parent = clipper
        }
    }
}
