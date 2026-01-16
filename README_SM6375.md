# BPF Kernel Version Override for SM6375

## Overview

This document describes the BPF kernel version override functionality available in the UprobeStats module, specifically adapted for devices using the Qualcomm SM6375 chipset (such as Moto G82, Moto G72, and similar devices).

## Feature Description

The BPF loader includes support for overriding the detected kernel version through a system property. This is particularly useful for devices like SM6375-based phones where:
- The actual kernel capabilities may differ from the reported kernel version
- Custom kernel builds may have backported features
- Testing and development require specific version targeting

## Implementation

The kernel version override is implemented in `/src/bpf/headers/include/bpf/KernelUtils.h`:

```cpp
static inline unsigned uncachedKernelVersion() {
    struct utsname buf;
    if (uname(&buf)) return 0;

    unsigned kver_major = 0;
    unsigned kver_minor = 0;
    unsigned kver_sub = 0;
    char kver_override[PROP_VALUE_MAX];
    int kver_override_len = __system_property_get("ro.bpf.kver_override", kver_override);
    if (kver_override_len > 0) {
        (void)sscanf(kver_override, "%u.%u.%u", &kver_major, &kver_minor, &kver_sub);
    } else {
        (void)sscanf(buf.release, "%u.%u.%u", &kver_major, &kver_minor, &kver_sub);
    }
    return KVER(kver_major, kver_minor, kver_sub);
}
```

## Usage for SM6375 Devices

### Setting the Override Property

To override the kernel version on SM6375 devices, set the `ro.bpf.kver_override` system property. This must be done at build time in your device tree.

#### Method 1: Device Makefile (device.mk)

Add the following to your device's `device.mk`:

```makefile
# Override BPF kernel version for SM6375
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bpf.kver_override=5.4.0
```

#### Method 2: System Properties File (system.prop)

Add to your device's `system.prop`:

```properties
# BPF kernel version override for SM6375
ro.bpf.kver_override=5.4.0
```

#### Method 3: Vendor Properties (vendor.prop)

Add to `vendor.prop`:

```properties
# BPF kernel version override for SM6375
ro.bpf.kver_override=5.4.0
```

### Recommended Kernel Versions for SM6375

Based on typical SM6375 kernel configurations:

- **5.4.x**: Most common for SM6375 devices (recommended: `5.4.0`)
- **5.10.x**: Some newer builds may use this version
- **4.19.x**: Older builds or specific vendor implementations

To determine your actual kernel version:
```bash
adb shell uname -r
```

### Example for Common SM6375 Devices

**Moto G82 / Moto G72 (rhode/austin):**
```properties
ro.bpf.kver_override=5.4.0
```

## Verification

After setting the override, you can verify it's working by checking the logs:

```bash
adb logcat | grep -i "bpf\|kernel\|uprobestats"
```

Look for messages related to kernel version checking in the BPF loader.

## Technical Details

### When is the Override Applied?

The override is checked during:
1. **BPF Map Creation**: When loading maps with kernel version requirements (see `createMaps()` function in `UprobeStatsBpfLoad.cpp`)
2. **BPF Program Loading**: When loading programs with version constraints (see `loadCodeSections()` function in `UprobeStatsBpfLoad.cpp`)

### Kernel Version Format

The version should be specified as `MAJOR.MINOR.PATCH`:
- MAJOR: Major kernel version (e.g., 4, 5, 6)
- MINOR: Minor version (e.g., 4, 10, 15)
- PATCH: Patch level (e.g., 0, 21, 110)

Example: `5.4.0`, `5.10.21`, `4.19.110`

### Version Checking Macros

The code uses version checking macros:
```cpp
#define KVER(a, b, c) (((a) << 24) + ((b) << 16) + (c))
```

This encodes the version as a single integer for easy comparison:
- `KVER(5, 4, 0)` = 0x05040000
- `KVER(5, 10, 0)` = 0x050A0000

## Troubleshooting

### Issue: BPF programs fail to load

**Solution**: Check if your override version matches your kernel's actual capabilities. If your kernel is 5.4.x but you've set 5.10.x, features may not be available.

### Issue: Maps are skipped during loading

**Solution**: Review the logcat output. Maps are skipped if the kernel version doesn't meet requirements:
```
skipping map <name> which requires kernel version 0x<hex> >= 0x<hex>
```

Adjust your override version accordingly.

### Issue: Override not taking effect

**Solution**: Ensure the property is set with the `ro.` prefix (read-only property) and is set during early boot. Regular properties won't work.

## SM6375 Kernel Capabilities

When setting the override version for SM6375, consider these typical capabilities:

### 5.4 Kernel Features:
- BPF ring buffers
- BPF trampolines
- BPF iterators
- BTF (BPF Type Format) support
- Enhanced BPF helpers

### 5.10 Kernel Features (if backported):
- Additional BPF program types
- Enhanced tracing capabilities
- Improved performance optimizations

## Building for SM6375

When building custom ROMs (LineageOS, FogOS, etc.) for SM6375 devices with this module:

1. Add the property to your device tree
2. Build the system/vendor image
3. Flash and test BPF functionality
4. Verify in logcat that the override is applied

## References

- Main implementation: `src/bpf/headers/include/bpf/KernelUtils.h`
- BPF loader: `src/bpfloader/UprobeStatsBpfLoad.cpp`
- Map definitions: `src/bpf/headers/include/bpf_map_def.h`

## Credits

This kernel version override functionality is part of the Android BPF loader implementation and has been documented for the SM6375 platform.

## Support

For issues specific to SM6375 devices, please report them to the sm6375-fogos project repository.
