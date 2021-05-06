#!/bin/sh
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

qtVersion=$1
sourceDir=$2
destDir=$3

mkdir -p "$destDir"
shaderFiles=""
if [ $qtVersion -eq 6 ]; then
    for shader in $sourceDir/*.qt6
    do
        qsbShader="$destDir/$(basename ${shader} .qt6)"
        cp "${shader}" "$qsbShader" > /dev/null 2>&1
        qsb --glsl "100 es,120,150" --hlsl 50 --msl 12 "$qsbShader" -o "$qsbShader" > /dev/null 2>&1
        shaderFiles="$shaderFiles $qsbShader"
    done
else
    for shader in $sourceDir/*.qt5
    do
        qsbShader="$destDir/$(basename ${shader} .qt5)"
        cp "${shader}" "$qsbShader" > /dev/null 2>&1
        shaderFiles="$shaderFiles $qsbShader"
    done
fi

echo "$shaderFiles"
