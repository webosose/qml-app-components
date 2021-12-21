#!/bin/bash

# Purpose : to mount tmpfs in target , and copy current files into target, and test it
# How : 1. backup QmlAppComponents in target. 2. mount tmpfs in target. 3. recover backuped in 1. 4. Copy it.

echo -ne '\n' | "test"

# Modify as your target ip
TARGET_IP="192.168.0.94"
TARGET_APP_NAME="QmlAppComponents"
TARGET_DIR_NAME="/usr/lib/qml/$TARGET_APP_NAME"

mount=n
if [ $# -eq 1 ]
then
    echo ".."
    echo "Note : It will proceed MOUNT job... Be careful (or just reboot target to reset to init)"
    echo ".."
    mount=y
else
    echo ".."
    echo "Without parameter 1, it will work 'nomount' mode. please set parameter 1 as true or whatever if you want mount."
    echo ".."
    mount=n
fi

answer="n"
while true; do
    read -p "Proceed? (y/N) ==> " input
    case ${input} in
        Y | y)
            answer="y"
            break
            ;;
        N | n | "")
            answer="n"
            break
            ;;
    esac
done

if [ "$answer" == "n" ]
then
    exit 1;
fi

CMDBASE="ssh root@$TARGET_IP"
TARGET_APP=$TARGET_APP_NAME
TARGET_DIR=$TARGET_DIR_NAME
COPY_BACKUP="cp -a $TARGET_DIR ~/;"
MOUNT="mount -t tmpfs /dev/null $TARGET_DIR;"
RECOVER="cp -a ~/$TARGET_APP/* $TARGET_DIR;"

#CMD=$TARGET_DIR_SET
if [ $mount == y ]
then
echo "MOUNT JOB~"
    CMD="$CMDBASE $COPY_BACKUP"
    echo `$CMD`
    CMD="$CMDBASE $MOUNT"
    echo `$CMD`
    CMD="$CMDBASE $RECOVER"
    echo `$CMD`
#    CMD="$CMDBASE \"$COPY_BACKUP$MOUNT$RECOVER\""
else
echo "NOMOUNT~"
    CMD="$CMDBASE $RECOVER"
    echo `$CMD`
fi
