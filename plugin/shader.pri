# @@@LICENSE
#
# Copyright (c) 2021 LG Electronics, Inc.
#
# Confidential computer software. Valid license from LG Electronics required for
# possession, use or copying. Consistent with FAR 12.211 and 12.212,
# Commercial Computer Software, Computer Software Documentation, and
# Technical Data for Commercial Items are licensed to the U.S. Government
# under vendor's standard commercial license.
#
# LICENSE@@@

versionAtLeast(QT_VERSION, 6.0.0) {
    FILES = $$system($$PWD/shaderconversion.sh 6 \"$$PWD/Shaders\" \"$$shadowed($$PWD/Shaders)\")
} else {
    FILES = $$system($$PWD/shaderconversion.sh 5 \"$$PWD/Shaders\" \"$$shadowed($$PWD/Shaders)\")
}

SHADER_FILES = $$FILES
