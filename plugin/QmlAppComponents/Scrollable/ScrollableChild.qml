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

Flickable {
    id: root
    contentWidth: width
    contentHeight: height

    property bool limitOvershoot: true && dragging
    property real maxOvershoot: 100 // 200
    property var containerRoot

    signal itemTouched();


    // Note : qt 5.6 does not have default overshoot limitor,
    // So we need to make my own overshoot limiter logic.
    // Event flow is
    // Drag start -> drag end, flick start, flick end
    // But IF we limit contentX,Y during flick, flicking velocity fall to 0 and
    // object will be stucked in wrong coordinate.
    // To avoid that stuck, I bind limitOvershoot with dragging.
    // This limitation only works in dragging, but not flicking.

    onContentYChanged: {
        // ContentY is "scrolled".
        // If it is 100, item moved to upward 100 px
        if (contentY > contentHeight - height + maxOvershoot && limitOvershoot)
            contentY = contentHeight - height + maxOvershoot - 0.1;
        if (contentY < 0 - maxOvershoot && limitOvershoot)
            contentY = 0 - maxOvershoot;

        // Note : this itemTouched will called rapidly, not sure it can slow the performance.
        itemTouched();
    }

    onContentXChanged: {
        // ContentX is "scrolled".
        // If it is 100, item moved to upward 100 px
        if (contentX > contentWidth - width + maxOvershoot && limitOvershoot)
            contentX = contentWidth - width + maxOvershoot;
        if (contentX < 0 - maxOvershoot && limitOvershoot)
            contentX = 0 - maxOvershoot;

        itemTouched();
    }

//    Connections {
//        target: containerRoot
//        onClosed: {
//            contentX = 0;
//            contentY = 0;
//        }
//    }
}
