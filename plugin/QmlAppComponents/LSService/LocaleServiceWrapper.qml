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
