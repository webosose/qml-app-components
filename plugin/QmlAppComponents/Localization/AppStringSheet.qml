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
