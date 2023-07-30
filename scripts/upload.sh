 
 #!/bin/bash

# Source Vars
source $CONFIG

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

# Change to the Source Directory
cd ~/twrp

# Color
ORANGE='\033[0;33m'

# Display a message
echo "============================"
echo "Uploading the Build..."
echo "============================"

# Change to the Output Directory
cd out/target/product/${DEVICE}

# Set FILENAME var
ZIPFILENAME=$(echo $OUTPUTZIP)
IMGFILENAME=$(echo $OUTPUTIMG)

# Upload to oshi.at
if [ -z "$TIMEOUT" ];then
    TIMEOUT=20160
fi

# Upload to WeTransfer
# NOTE: the current Docker Image, "registry.gitlab.com/sushrut1101/docker:latest", includes the 'transfer' binary by Default
# transfer wet $ZIPFILENAME > link.txt || { echo "ERROR: Failed to Upload the ZIP Build!" && exit 1; }
# transfer wet $IMGFILENAME > link1.txt || { echo "ERROR: Failed to Upload the IMG Build!" && exit 1; }
# Mirror to oshi.at
curl -T $ZIPFILENAME https://oshi.at/${ZIPFILENAME}/${TIMEOUT} > mirror.txt || { echo "WARNING: Failed to Mirror the ZIP Build!"; }
curl -T $IMGFILENAME https://oshi.at/${IMGFILENAME}/${TIMEOUT} > mirror1.txt || { echo "WARNING: Failed to Mirror the IMG Build!"; }

ZIP_DL_LINK=$(cat link.txt | grep Download | cut -d\  -f3)
ZIP_MIRROR_LINK=$(cat mirror.txt | grep Download | cut -d\  -f1)

IMG_DL_LINK=$(cat link1.txt | grep Download | cut -d\  -f3)
IMG_MIRROR_LINK=$(cat mirror1.txt | grep Download | cut -d\  -f1)

# Show the Download Link
echo "=============================================="
echo "ZIP Download Link: ${ZIP_DL_LINK}" || { echo "ERROR: Failed to Upload the ZIP Build!"; }
echo "ZIP Mirror: ${ZIP_MIRROR_LINK}" || { echo "WARNING: Failed to Mirror the ZIP Build!"; }
echo "                                              "
echo "                                              "
echo "                                              "
echo "IMG Download Link: ${IMG_DL_LINK}" || { echo "ERROR: Failed to Upload the IMG Build!"; }
echo "IMG Mirror: ${IMG_MIRROR_LINK}" || { echo "WARNING: Failed to Mirror the IMG Build!"; }
echo "=============================================="

DATE_L=$(date +%d\ %B\ %Y)
DATE_S=$(date +"%T")

# Send the Message on Telegram
echo -e \
"
PBRP Recovery CI

✅ Build Completed Successfully!

📱 Device: "${DEVICE}"
🖥 Build System: "${PBRP_BRANCH} Recovery Project"
⬇️ ZIP Download Link: <a href=\"${ZIP_DL_LINK}\">Here</a>
⬇️ IMG Download Link: <a href=\"${IMG_DL_LINK}\">Here</a>
⬇️ ZIP Mirror Link: <a href=\"${ZIP_MIRROR_LINK}\">Here</a>
⬇️ IMG Mirror Link: <a href=\"${IMG_MIRROR_LINK}\">Here</a>
📅 Date: "$(date +%d\ %B\ %Y)"
⏱ Time: "$(date +%T)"
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "$TG_TEXT"

echo " "

# Exit
exit 0
