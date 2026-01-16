# Quick Integration Guide for SM6375 Devices

This guide provides quick steps to integrate the BPF kernel version override for SM6375-based devices.

## For Device Maintainers

### Step 1: Determine Your Kernel Version

```bash
adb shell uname -r
# Example output: 5.4.210-something
# Use 5.4.0 for the override
```

### Step 2: Add to Your Device Tree

Choose one of these methods:

#### Option A: Using the Makefile (Recommended)

In your `device.mk`, add:

```makefile
# Include UprobeStats BPF configuration for SM6375
$(call inherit-product, packages/modules/UprobeStats/sm6375_uprobestats.mk)
```

#### Option B: Direct Property Override

In your `device.mk`, add:

```makefile
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bpf.kver_override=5.4.0
```

#### Option C: Using system.prop or vendor.prop

Add this line:

```properties
ro.bpf.kver_override=5.4.0
```

### Step 3: Build and Flash

```bash
mka systemimage vendorimage
# Or full ROM build
mka bacon
```

### Step 4: Verify (After Flashing)

```bash
adb root
adb shell getprop ro.bpf.kver_override
# Should output: 5.4.0 (or your configured version)

# Check BPF loading logs
adb logcat -b all | grep -i "bpf\|uprobestats\|kern"
```

## Common SM6375 Devices

| Device | Codename | Typical Kernel | Recommended Override |
|--------|----------|----------------|---------------------|
| Moto G82 | rhode | 5.4.x | `ro.bpf.kver_override=5.4.0` |
| Moto G72 | austin | 5.4.x | `ro.bpf.kver_override=5.4.0` |
| Moto G62 | devonf | 5.4.x | `ro.bpf.kver_override=5.4.0` |

## Troubleshooting

### BPF Programs Not Loading?

1. Check property is set:
   ```bash
   adb shell getprop ro.bpf.kver_override
   ```

2. Check SELinux denials:
   ```bash
   adb shell dmesg | grep -i denied
   adb logcat -b all | grep -i denied
   ```

3. Verify BPF filesystem:
   ```bash
   adb shell ls -la /sys/fs/bpf/
   ```

### Version Mismatch Errors?

If you see "skipping map/program" messages in logcat:
- Your override version might be too low
- Try incrementing: 5.4.0 → 5.10.0
- Or check if features are actually supported in your kernel

### Need More Help?

See the detailed documentation in [README_SM6375.md](README_SM6375.md)

## For ROM Developers

If you're building LineageOS or another custom ROM for SM6375:

1. Add the override to `device/manufacturer/codename/device.mk`
2. Or create a `device/manufacturer/codename/vendor.prop` entry
3. Build and test
4. Submit to your device tree repository

## Testing Checklist

After integration:

- [ ] Property is set: `getprop ro.bpf.kver_override`
- [ ] No BPF loading errors in logcat
- [ ] UprobeStats service starts correctly
- [ ] BPF programs are pinned in `/sys/fs/bpf/uprobestats/`
- [ ] No unexpected system behavior

## Example Commit Message

When committing to your device tree:

```
device: Add BPF kernel version override for SM6375

The SM6375 chipset requires BPF kernel version override to ensure
proper loading of BPF programs and maps. This sets the version to
5.4.0 which matches the actual kernel capabilities.

This enables the UprobeStats module to function correctly on our device.

Change-Id: I... (gerrit will add this)
```

## References

- Main documentation: [README_SM6375.md](./README_SM6375.md)
- Example config: [sm6375_config.prop](./sm6375_config.prop)
- Makefile snippet: [sm6375_uprobestats.mk](./sm6375_uprobestats.mk)
- Implementation: [src/bpf/headers/include/bpf/KernelUtils.h](./src/bpf/headers/include/bpf/KernelUtils.h)
