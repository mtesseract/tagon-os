#!/bin/sh

USB_MOUNT=/mnt/usb

echo
echo "** Tagon Modifications **"
echo

echo "Prepare USB Storage"
chroot_exec mkdir -p /mnt/usb

cp /artifacts/bin/mgmtd ${ROOTFS_PATH}/sbin/tagon-os-mgmtd
echo $VERSION | tee ${ROOTFS_PATH}/tagon

echo "Prepare WLAN"
apk --root ${ROOTFS_PATH} add wireless-tools wpa_supplicant dhcpcd

# Move wpa_supplicant configuration to USB

# Install Raspberry Pi Firmware
# apk add linux-firmware-brcm
# apk add raspberrypi-libs
WLAN_FIRMWARE_DIR="$(mktemp -d)"
git clone --depth 1 https://github.com/RPi-Distro/firmware-nonfree.git "$WLAN_FIRMWARE_DIR"
mkdir -p "${ROOTFS_PATH}/firmware/brcm" || true
cp $WLAN_FIRMWARE_DIR/brcm/* "${ROOTFS_PATH}/firmware/brcm"
rm -rf "$WLAN_FIRMWARE_DIR"

chroot_exec rc-update add wpa_supplicant
chroot_exec rc-update add dhcpcd default

chroot_exec rm -f /etc/wpa_supplicant/wpa_supplicant.conf
chroot_exec ln -sf "${USB_MOUNT}/wpa_supplicant/wpa_supplicant.conf" /etc/wpa_supplicant/wpa_supplicant.conf

echo "Setup Docker"

apk --root ${ROOTFS_PATH} add docker



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

ROOTFS_SIZE="$(du -sm "$ROOTFS_PATH")"
echo "** Root FS ($ROOTFS_PATH) size: $ROOTFS_SIZE"
