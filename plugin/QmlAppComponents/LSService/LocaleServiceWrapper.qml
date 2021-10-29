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
import WebOSServices 1.0


LocaleService {
    id: root

//    l10nDirName: "/usr/share/qml/locales/" + root.appId // note that this should be "com.webos.app.sample" not "com.webos.app.sample-1"
//    l10nFileNameBase: root.appId // note that this should be "com.webos.app.sample" not "com.webos.app.sample-1"

    property string defaultLocaleFont: ""
    property bool isRTLLocale: false

    property bool serviceConnected: false
    property bool connected: serviceConnected
    property string serviceName: "com.webos.settingsservice"
    property string emptyStringTemp: ""

    property ServiceStateNotifier serviceStateNotifier: ServiceStateNotifier {
        appId: root.appId
        targets: [root]
    }

    onConnectedChanged: {
        if (connected)
            subscribe();
        else
            cancel();
    }

    onError: {
        appLog.debug("localeService.onError:errorText=" + errorText);
    }

    onL10nLoadSucceeded: {
        appLog.debug("localeService.onL10nLoadSucceeded");
    }

    onL10nLoadFailed: {
        appLog.debug("localeService.onL10nLoadFailed");
    }

    onL10nInstallSucceeded: {
        appLog.debug("localeService.onL10nInstallSucceeded");
        emptyStringTemp = " "
        emptyStringTemp = ""
    }

    onL10nInstallFailed: {
        appLog.debug("localeService.onL10nInstallFailed");
    }

    onCurrentLocaleChanged: {
        if(currentLocale && (currentLocale.indexOf("he-") > -1 || currentLocale.indexOf("ar-") > -1 || currentLocale.indexOf("ur-") > -1 ||
                             currentLocale.indexOf("ku-") > -1 || currentLocale.indexOf("fa-") > -1))
            isRTLLocale = true;
        else
            isRTLLocale = false;
        appLog.warn("localeService.onCurrentLocaleChanged: "+currentLocale);
    }
}
