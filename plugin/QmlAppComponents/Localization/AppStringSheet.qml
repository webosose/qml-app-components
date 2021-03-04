/* @@@LICENSE
 *
 * Copyright (c) <2020> LG Electronics, Inc.
 *
 * Confidential computer software. Valid license from LG required for
 * possession, use or copying. Consistent with FAR 12.211 and 12.212,
 * Commercial Computer Software, Computer Software Documentation, and
 * Technical Data for Commercial Items are licensed to the U.S. Government
 * under vendor's standard commercial license.
 *
 * LICENSE@@@ */

import QtQuick 2.4
import QmlAppComponents 0.1

QtObject {
    id: root

    property LocaleServiceWrapper localeService: LocaleServiceWrapper {
        appId: appIdForLSService

        // note that this should be "com.webos.app.sample" not "com.webos.app.sample-1"
        l10nDirName: "/usr/share/qml/locales/" + root.appId
        l10nFileNameBase: {
            var temp = root.appId;
            temp = temp.replace("com.", "")
            temp = temp.replace("webos.", "")
            temp = temp.replace("app.", "")
            temp = temp.replace("avn.", "")
            return temp;
        }
    }

    //System Textd
    property string appId: "com.webos.app.sample"
    property string appIdForLSService: appId + displayId
    property string displayId: "-1"

    //Localization Texts
    property bool isRTL: localeService.isRTLLocale
    property string rtlCode: isRTL ? "\u200F" : ""

    // Not sure why emptyString not works.
    property string es: localeService.emptyStringTemp

    property string appTitle: rtlCode + qsTr("Sample") + es
}
