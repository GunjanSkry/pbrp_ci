#!/bin/bash

source $CONFIG

telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Change to the Source Directry
cd ~/twrp

# Send the Telegram Message

echo -e \
"
✨ PBRP Recovery CI

✔️ The Build has been Triggered!!!!

📱 Device: "${DEVICE}"
🖥 Build System: "${PBRP_BRANCH}"
🌲 Logs: <a href=\"https://cirrus-ci.com/build/${CIRRUS_BUILD_ID}\">Here</a>
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "${TG_TEXT}"
echo " "

# Prepare the Build Environment
source build/envsetup.sh

# export some Basic Vars
export ALLOW_MISSING_DEPENDENCIES=true
#export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
#export LC_ALL="C"

# lunch the target
lunch omni_${DEVICE}-eng   || { echo "ERROR: Failed to lunch the target!" && exit 1; }
mka -j$(nproc --all) pbrp
# Exit
exit 0
