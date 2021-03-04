/* @@@LICENSE
 *
 * Copyright (c) 2020 LG Electronics, Inc.
 *
 * Confidential computer software. Valid license from LG required for
 * possession, use or copying. Consistent with FAR 12.211 and 12.212,
 * Commercial Computer Software, Computer Software Documentation, and
 * Technical Data for Commercial Items are licensed to the U.S. Government
 * under vendor's standard commercial license.
 *
 * LICENSE@@@ */

import QtQuick 2.4

QtObject {
    id: root

    property string mainFont: "Museo Sans"
    property font chrome: mainFont35
    property font title: mainFont60
    property font subTitle: mainFont36
    property font description: mainFont40
    property font listElement: mainFont50
    property font listNumber: mainFont44
    property font musicTitle: mainFont75
    property font musicSubTitle: mainFont45

    function getFont(pixelSize, weight, letterSpacing) {
        var fontObject = {};

        if (pixelSize < 1)
            pixelSize = 1;

        fontObject.family = mainFont;
        if (weight !== undefined && weight !== null) {
            if (weight > 800)
                fontObject.weight = Font.Black
            else if (weight > 700)
                fontObject.weight = Font.ExtraBold
            else if (weight > 600)
                fontObject.weight = Font.Bold
            else if (weight > 500)
                fontObject.weight = Font.DemiBold
            else if (weight > 400)
                fontObject.weight = Font.Medium
            else if (weight > 300)
                fontObject.weight = Font.Normal
            else if (weight > 200)
                fontObject.weight = Font.ExtraLight
            else if (weight > 100)
                fontObject.weight = Font.Light
            else// if (weight > 100)
                fontObject.weight = Font.Thin
        }

        fontObject.pixelSize = Math.floor(styleRoot.relativeXBasedOnFHD(pixelSize));
        if (letterSpacing !== undefined && letterSpacing !== null)
            fontObject.letterSpacing = styleRoot.relativeXBasedOnFHD(letterSpacing);

        return Qt.font(fontObject);
    }

    //    https://htmldog.com/references/css/properties/font-weight/
    //    Font.Thin 100
    //    Font.Light 200
    //    Font.ExtraLight 300
    //    Font.Normal 400
    //    Font.Medium 500
    //    Font.DemiBold 600
    //    Font.Bold 700
    //    Font.ExtraBold 800
    //    Font.Black 900

    property font mainFont18: getFont(18)
    property font mainFont24: getFont(24)
    property font mainFont28: getFont(28)
    property font mainFont28Bold: getFont(28,700)
    property font mainFont28Thin: getFont(28,100)
    property font mainFont32: getFont(32)
    property font mainFont35: getFont(35)
    property font mainFont36: getFont(36)
    property font mainFont40: getFont(40,200)
    property font mainFont42: getFont(40,200)
    property font mainFont40Thin: getFont(40,100)
    property font mainFont44: getFont(44)
    property font mainFont45: getFont(45)
    property font mainFont50: getFont(50)
    property font mainFont60: getFont(60,700)
    property font mainFont70: getFont(70,700)
    property font mainFont75: getFont(75)
    property font mainFont84: getFont(84,100)
    property font mainFont140: getFont(140,100)
    property font mainFont230: getFont(230,100)
}
