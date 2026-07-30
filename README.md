# H69K KWRT 定制配置

目标设备：HINLINK OPC-H69K（RK3568），RM520N-GL，MT7916。

本配置基于 KWRT 的 `devices/rockchip_armv8` 构建流程。该流程会导入 Lean 的 Rockchip 目标，其中已包含 `hinlink_opc-h69k` 设备定义和设备树。

## 已固化的策略

- MT7916 的 mt76/mt7915e 驱动、固件与 WPA OpenSSL 组件。
- PCIe/MHI/MBIM 为首选蜂窝 WAN：`/dev/wwan0mbim0`。
- USB/QMI 为备用蜂窝 WAN：`/dev/cdc-wdm0`。
- 每 30 秒检测一次：PCIe MBIM 节点存在则使用 PCIe；不存在才使用 USB QMI。两个接口不会同时拨号。
- APN 留空以允许自动配置；运营商或物联网卡需要固定 APN 时，在 LuCI/SSH 将值写入 `h69kcellular.main.preferred_apn`，服务会同步给两个蜂窝接口。
- 编入 OpenClash、ZeroTier、QoSmate、SQM、sqm-autorate、蜂窝信息/锁频界面、CPU/风扇管理界面。已核对 H69K DTS：风扇为 `pwm0` 上的 `pwm-fan`，并已有 40/50/60/70°C 的四级散热图；风扇界面将控制这一节点。

## 编译接入

1. 取得 KWRT 并选择 `devices/rockchip_armv8`。
2. 用本目录的 `h69k-kwrt.config` 替换/合并设备 `.config`。
3. 在 KWRT 的设备 `diy.sh` 末尾调用本目录 `diy.sh`，或复制其中的外部包拉取与 overlay 步骤。
4. 执行 feeds 更新、`make defconfig`，确认第三方包名后再正式编译。
5. 在 OpenWrt 根目录执行 `sh custom/verify-config.sh`；只有该校验通过才执行正式编译。

外部包名和 Makefile 已审计。特别地，原始 `sqm-autorate` 项目仅提供安装脚本，不是可直接纳入固件的 OpenWrt 包；本工程改用 OpenMPTCProuter 维护的 `sqm-autorate`、`luci-app-sqm-autorate` 与 `tsping` 包定义。

## GitHub Actions

把本目录作为一个新 GitHub 仓库的根目录后，Actions 页面会出现 `Build H69K Custom KWRT`。手动运行该工作流即可下载 `h69k-kwrt-custom-*` 构件。工作流会在编译前执行 `verify-config.sh`；配置或第三方包不匹配时会直接失败，不会上传不完整固件。

## 重要说明

RM520N-GL 的 PCIe QMI 虽在硬件层面存在，但当前上游 OpenWrt 的 MHI 路径实际稳定的是 MBIM。故本配置将 **PCIe 作为主连接总线**，以 MBIM 协议拨号；USB 以 QMI 备用。PCIe QMI 仅建议作为实测后的实验选项，不应作为无人值守自动联网的默认路径。

QoSmate 与 SQM/autorate 都能编译进固件，但只能启用其中一个 WAN 整形器。
