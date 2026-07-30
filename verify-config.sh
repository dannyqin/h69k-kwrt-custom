#!/bin/sh
# Run from the OpenWrt build root after this project's diy.sh has completed.
set -eu

make defconfig

required='\
CONFIG_TARGET_rockchip_armv8_DEVICE_hinlink_opc-h69k=y
CONFIG_PACKAGE_kmod-mt7915e=y
CONFIG_PACKAGE_kmod-mt7916-firmware=y
CONFIG_PACKAGE_kmod-mhi-pci-generic=y
CONFIG_PACKAGE_kmod-mhi-wwan-mbim=y
CONFIG_PACKAGE_luci-proto-mbim=y
CONFIG_PACKAGE_kmod-usb-net-qmi-wwan=y
CONFIG_PACKAGE_luci-proto-qmi=y
CONFIG_PACKAGE_luci-app-openclash=y
CONFIG_PACKAGE_luci-app-qosmate=y
CONFIG_PACKAGE_luci-app-sqm-autorate=y
CONFIG_PACKAGE_luci-app-modeminfo=y
CONFIG_PACKAGE_luci-app-modemband=y
CONFIG_PACKAGE_luci-app-3ginfo-lite=y
CONFIG_PACKAGE_luci-app-cpufreq=y
CONFIG_PACKAGE_luci-app-fancontrol=y'

missing=0
for entry in $required; do
	if ! grep -qx "$entry" .config; then
		echo "MISSING: $entry" >&2
		missing=1
	fi
done

[ "$missing" -eq 0 ] || exit 1
echo 'H69K custom configuration: package resolution passed.'
