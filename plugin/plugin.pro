# @@@LICENSE
#
#      Copyright (c) 2020-2021 LG Electronics, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# LICENSE@@@

TEMPLATE = lib
CONFIG += qt plugin c++11
QT += qml quick
TARGET = qmlappcomponentsplugin
#TARGET = $$qtLibraryTarget($$TARGET)

include($$PWD/shader.pri)

uri = com.webos.qmlappcomponents

MOC_DIR = .moc
OBJECTS_DIR = .obj

# Input
HEADERS += \
    qmlappcomponentsplugin.h

SOURCES += \
    qmlappcomponentsplugin.cpp

DISTFILES = qmldir \
               qmlappcomponentsplugindescription.json
OTHER_FILES += qmldir \
               qmlappcomponentsplugindescription.json
other_files.files = qmldir \
                    qmlappcomponentsplugindescription.json
qml_files.files = QmlAppComponents/*
shader.files = $$SHADER_FILES

CONFIG += link_pkgconfig
PKGCONFIG = glib-2.0 #luna-service2

defined(WEBOS_INSTALL_QML, var) {
    message("qml-app-components : WebOS Build")
    DEFINES += WEBOS_PLATFORM
    PKGCONFIG += luna-service2
    target.path = $$WEBOS_INSTALL_QML/QmlAppComponents
    other_files.path = $$WEBOS_INSTALL_QML/QmlAppComponents
    qml_files.path = $$WEBOS_INSTALL_QML/QmlAppComponents
    shader.path = $$WEBOS_INSTALL_QML/QmlAppComponents/Shader
} else {
    # For desktop dev environment
    message("qml-app-components : Desktop Build")
    DEFINES += NO_WEBOS_PLATFORM

    target.path = $$OUT_PWD/QmlAppComponents/
    other_files.path = $$OUT_PWD/QmlAppComponents/
    qml_files.path = $$OUT_PWD/QmlAppComponents/
    message($$other_files.path)
    shader.path = $$OUT_PWD/QmlAppComponents/Shader

    !equals(_PRO_FILE_PWD_, $$OUT_PWD) {
        copy_qmldir.target = $$OUT_PWD/qmldir
        copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
        copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
        QMAKE_EXTRA_TARGETS += copy_qmldir
        PRE_TARGETDEPS += $$copy_qmldir.target
    }
}



INSTALLS += target other_files qml_files shader

#defined(WEBOS_INSTALL_WEBOS_APPLICATIONSDIR, var) {
#    INSTALL_APPDIR = $$WEBOS_INSTALL_WEBOS_APPLICATIONSDIR/com.webos.app.fridge.clova
#    INSTALL_JSONDIR = $$INSTALL_APPDIR
#    INSTALL_QMLDIR = $$INSTALL_APPDIR/qml/Clova

#    json.path = $$INSTALL_JSONDIR
#    json.files += appinfo/*
#    qml.path = $$INSTALL_QMLDIR
#    qml.files = qml/Clova/*

#    INSTALLS += json qml
#}
