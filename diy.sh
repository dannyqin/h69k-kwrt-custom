#!/bin/bash
# Run after KWRT has applied its Rockchip H69K device-tree integration.

set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Feeds whose packages are selected in h69k-kwrt.config.
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/openclash
git clone --depth=1 https://github.com/hudra0/qosmate.git package/qosmate
git clone --depth=1 https://github.com/hudra0/luci-app-qosmate.git package/luci-app-qosmate
git clone --depth=1 https://github.com/koshev-msk/modemfeed.git package/modemfeed
git clone --depth=1 https://github.com/4IceG/luci-app-modemband.git package/luci-app-modemband
git clone --depth=1 https://github.com/4IceG/luci-app-3ginfo-lite.git package/luci-app-3ginfo-lite
git clone --depth=1 https://github.com/openwrt-xiaomi/luci-app-cpufreq.git package/luci-app-cpufreq
git clone --depth=1 https://github.com/bigmalloy/luci-app-fancontrol.git package/luci-app-fancontrol

# The upstream sqm-autorate project supplies a setup script, not an OpenWrt
# Makefile. Use the OpenMPTCProuter-maintained OpenWrt packages instead.
OMR_TMP="$(mktemp -d)"
trap 'rm -rf "$OMR_TMP"' EXIT
git clone --depth=1 --filter=blob:none --sparse https://github.com/Ysurac/openmptcprouter-feeds.git "$OMR_TMP"
git -C "$OMR_TMP" sparse-checkout set sqm-autorate luci-app-sqm-autorate tsping
cp -a "$OMR_TMP"/sqm-autorate package/sqm-autorate
cp -a "$OMR_TMP"/luci-app-sqm-autorate package/luci-app-sqm-autorate
cp -a "$OMR_TMP"/tsping package/tsping

# Overlay first-boot configuration and the cellular failover service.
cp -a "$ROOT_DIR/files/." files/
chmod 0755 files/etc/uci-defaults/99-h69k-cellular-defaults
chmod 0755 files/etc/init.d/h69k-cellular
chmod 0755 files/usr/libexec/h69k-cellular-failover
