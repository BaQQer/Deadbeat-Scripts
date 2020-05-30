#!/bin/bash
MOUNTPOINT=<path>
if grep -qs "$MOUNTPOINT " /proc/mounts; then
        true
else
        umount $MOUNTPOINT > /dev/null 2>&1
        mount -a  > /dev/null 2>&1
        if [ $? -eq 0 ]; then
                true
        else
                false
        fi
fi
