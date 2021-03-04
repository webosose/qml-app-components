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
