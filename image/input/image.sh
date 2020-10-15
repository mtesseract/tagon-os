#!/bin/sh

echo
echo "** Tagon Modifications **"
echo

touch ${ROOTFS_PATH}/tagon
apk --root ${ROOTFS_PATH} add wireless-tools wpa_supplicant docker 

WLAN_FIRMWARE_DIR="$(mktemp -d)"
git clone --depth 1 https://github.com/RPi-Distro/firmware-nonfree.git "$WLAN_FIRMWARE_DIR"
mkdir -p "${ROOTFS_PATH}/firmware/brcm" || true
cp $WLAN_FIRMWARE_DIR/brcm/* "${ROOTFS_PATH}/firmware/brcm"
rm -rf "$WLAN_FIRMWARE_DIR"

# Bug Workaround (https://github.com/bestouff/genext2fs/issues/19)
# genext2fs needs to be updated.
for file in $(find "${ROOTFS_PATH}" -type l); do
    dest="$(readlink "$file")"
    if [ $(echo "$dest" | tr -d '\n' | wc -c) -ne 60 ]; then
        continue
    fi
    orig_dest="$dest"
    if echo "$dest" | grep -q "^/"; then
        dest="/.$dest"
    else
        $dest="./$dest"
    fi
    echo "[!!] Temporary workaround: changing link destination for \"$file\" from \"$orig_dest\" to \"$dest\""
    ln -sf "$dest" "$file"
done
