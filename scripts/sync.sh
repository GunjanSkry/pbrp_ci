#!/bin/bash

# Source Vars
source $CONFIG

# Change to the Home Directory
cd ~

# Create Folder
mkdir twrp
cd ~/twrp

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

echo -e \
"
🦊 PBRP Recovery CI

✔️ The Syncing has been started!

📱 Device: "${DEVICE}"
🖥 Build System: "${PBRP_BRANCH}"
🌲 Logs: <a href=\"https://cirrus-ci.com/build/${CIRRUS_BUILD_ID}\">Here</a>
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "${TG_TEXT}"
echo " "

# Clone the Sync Repo
repo init $MANIFEST -b $PBRP_BRANCH

# Sync the Sources
repo sync || { echo "ERROR: Failed to TWRP source!" && exit 1; }

# Clone Trees
git clone $DT_LINK $DT_PATH || { echo "ERROR: Failed to Clone the Device Trees!" && exit 1; }

# Exit
exit 0
