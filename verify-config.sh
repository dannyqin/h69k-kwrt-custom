#!/bin/sh
# Run from the OpenWrt build root after this project's diy.sh has completed.
set -eu

make defconfig

required='
CONFIG_TARGET_rockchip_armv8_DEVICE_hinlink_opc-h69k=y
CONFIG_PACKAGE_kmod-mt7915e=y
CONFIG_PACKAGE_kmod-mt76-connac=y
CONFIG_PACKAGE_kmod-mt7916-firmware=y
CONFIG_PACKAGE_wpad-mbedtls=y
CONFIG_PACKAGE_kmod-mhi-bus=y
CONFIG_PACKAGE_kmod-mhi-pci-generic=y
CONFIG_PACKAGE_kmod-mhi-wwan-ctrl=y
CONFIG_PACKAGE_kmod-mhi-wwan-mbim=y
CONFIG_PACKAGE_umbim=y
CONFIG_PACKAGE_luci-proto-mbim=y
CONFIG_PACKAGE_kmod-usb-net-qmi-wwan=y
CONFIG_PACKAGE_kmod-usb-net-cdc-mbim=y
CONFIG_PACKAGE_kmod-usb-net-cdc-ncm=y
CONFIG_PACKAGE_kmod-usb-net-cdc-ether=y
CONFIG_PACKAGE_kmod-usb-net-rndis=y
CONFIG_PACKAGE_kmod-usb-acm=y
CONFIG_PACKAGE_kmod-usb-serial-option=y
CONFIG_PACKAGE_kmod-usb-serial-qualcomm=y
CONFIG_PACKAGE_uqmi=y
CONFIG_PACKAGE_luci-proto-qmi=y
CONFIG_PACKAGE_comgt-ncm=y
CONFIG_PACKAGE_luci-proto-ncm=y
CONFIG_PACKAGE_luci-app-openclash=y
CONFIG_PACKAGE_zerotier=y
CONFIG_PACKAGE_luci-app-zerotier=y
CONFIG_PACKAGE_qosmate=y
CONFIG_PACKAGE_luci-app-qosmate=y
CONFIG_PACKAGE_sqm-scripts=y
CONFIG_PACKAGE_luci-app-sqm=y
CONFIG_PACKAGE_sqm-autorate=y
CONFIG_PACKAGE_luci-app-sqm-autorate=y
CONFIG_PACKAGE_tsping=y
CONFIG_PACKAGE_luci-app-modeminfo=y
CONFIG_PACKAGE_modeminfo=y
CONFIG_PACKAGE_luci-app-modemband=y
CONFIG_PACKAGE_modemband=y
CONFIG_PACKAGE_luci-app-3ginfo-lite=y
CONFIG_PACKAGE_luci-app-atinout=y
CONFIG_PACKAGE_atinout=y
CONFIG_PACKAGE_comgt=y
CONFIG_PACKAGE_cpufreq=y
CONFIG_PACKAGE_luci-app-cpufreq=y
CONFIG_PACKAGE_kmod-hwmon-core=y
CONFIG_PACKAGE_kmod-hwmon-pwmfan=y
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
