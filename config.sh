#!/bin/bash

export PBRP_BRANCH="android-11.0"

# Device
export DT_LINK="https://github.com/GunjanSkry/android_device_realme_nicky-pbrp.git -b android-11"

export DEVICE="nicky"
export OEM="realme"
export DT_PATH="device/$OEM/$DEVICE"

export TARGET="recoveryimage"

export OUTPUTZIP="recovery*.zip"
export OUTPUTIMG="recovery*.img"

# Kernel Source
# Uncomment the next line if you want to clone a kernel source.
#export KERNEL_SOURCE="https://gitlab.com/OrangeFox/kernel/mojito.git"
#export PLATFORM="sm6150" # Leave it commented if you want to clone the kernel to kernel/$OEM/$DEVICE

# Extra Command
#export EXTRA_CMD="git clone https://github.com/OrangeFoxRecovery/Avatar.git misc"
export EXTRA_CMD="export OF_MAINTAINER=gunskry"

# Not Recommended to Change
export SYNC_PATH="$HOME/work" # Full (absolute) path.
export USE_CCACHE=1
export CCACHE_SIZE="50G"
export CCACHE_DIR="$HOME/work/.ccache"
export J_VAL=16

#if [ ! -z "$PLATFORM" ]; then
#    export KERNEL_PATH="kernel/$OEM/$PLATFORM"
#else
#   export KERNEL_PATH="kernel/$OEM/$DEVICE"
#fi

