# UprobeStats Module Configuration for SM6375 Devices
#
# Include this file in your device's device.mk to enable the BPF kernel
# version override for SM6375-based devices
#
# Usage in device.mk:
# $(call inherit-product, packages/modules/UprobeStats/sm6375_uprobestats.mk)
# OR manually add the properties below to your PRODUCT_PROPERTY_OVERRIDES

# =============================================================================
# BPF KERNEL VERSION OVERRIDE FOR SM6375
# =============================================================================
# This override ensures BPF programs and maps load correctly on SM6375 devices
# by overriding the kernel version detection with the correct version
#
# Default configuration for SM6375 devices (kernel 5.4.x)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bpf.kver_override=5.4.0

# =============================================================================
# DEVICE-SPECIFIC OVERRIDES
# =============================================================================
# Uncomment and adjust if your SM6375 device uses a different kernel version:
#
# For 5.10 kernel:
# PRODUCT_PROPERTY_OVERRIDES += \
#     ro.bpf.kver_override=5.10.0
#
# For 4.19 kernel:
# PRODUCT_PROPERTY_OVERRIDES += \
#     ro.bpf.kver_override=4.19.0
#
# For custom kernel builds, set the version that matches your BPF capabilities

# =============================================================================
# ADDITIONAL NOTES
# =============================================================================
# - This property is read during BPF program/map loading
# - Verify your kernel version with: adb shell uname -r
# - The override affects:
#   * BPF program loading (min/max kernel version checks)
#   * BPF map creation (min/max kernel version requirements)
# - See README_SM6375.md for detailed documentation
