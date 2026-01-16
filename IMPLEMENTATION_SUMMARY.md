# SM6375 BPF Kernel Version Override - Implementation Summary

## Overview

This implementation provides comprehensive documentation and configuration for the BPF kernel version override functionality specifically for Qualcomm SM6375-based devices (Moto G82, Moto G72, etc.).

## What Was Implemented

### The Core Feature

The BPF kernel version override functionality **already existed** in the codebase:
- Located in: `src/bpf/headers/include/bpf/KernelUtils.h`
- System property: `ro.bpf.kver_override`
- Format: `MAJOR.MINOR.PATCH` (e.g., "5.4.0")

This implementation adds **documentation and configuration** to make it usable for SM6375 devices.

## Files Added

### 1. README_SM6375.md
Comprehensive technical documentation covering:
- Feature description and implementation details
- Usage instructions for SM6375 devices
- Configuration methods (device.mk, system.prop, vendor.prop)
- Kernel version format and encoding
- Troubleshooting guide
- SM6375-specific recommendations

### 2. INTEGRATION_SM6375.md
Quick start guide for device maintainers:
- Step-by-step integration instructions
- Common SM6375 device configurations
- Testing checklist
- Example commit messages

### 3. sm6375_config.prop
Example system properties file showing:
- Property syntax
- Recommended values for SM6375
- Device-specific examples
- Integration notes

### 4. sm6375_uprobestats.mk
Device tree Makefile snippet:
- Ready-to-include configuration
- PRODUCT_PROPERTY_OVERRIDES example
- Alternative configurations
- Usage instructions

## Files Modified

### src/bpf/headers/include/bpf/KernelUtils.h
Added inline documentation:
- Explanation of the override feature
- System property reference
- Link to SM6375 documentation

## How to Use

### For Device Maintainers

1. **Add to device.mk:**
   ```makefile
   PRODUCT_PROPERTY_OVERRIDES += \
       ro.bpf.kver_override=5.4.0
   ```

2. **Or include the provided Makefile:**
   ```makefile
   $(call inherit-product, packages/modules/UprobeStats/sm6375_uprobestats.mk)
   ```

3. **Build and flash:**
   ```bash
   mka systemimage vendorimage
   ```

4. **Verify:**
   ```bash
   adb shell getprop ro.bpf.kver_override
   ```

## SM6375 Device Support

### Typical Configuration
Most SM6375 devices run kernel 5.4.x:
```properties
ro.bpf.kver_override=5.4.0
```

### Supported Devices
- Moto G82 (rhode)
- Moto G72 (austin)
- Moto G62 (devonf)
- Other SM6375-based devices

## Technical Details

### How It Works

1. **Kernel Version Detection:**
   - Normal: Reads from `uname()` system call
   - Override: Reads from `ro.bpf.kver_override` property

2. **Version Encoding:**
   ```cpp
   #define KVER(a, b, c) (((a) << 24) + ((b) << 16) + (c))
   // Example: KVER(5, 4, 0) = 0x05040000
   ```

3. **Usage Points:**
   - BPF map creation (version requirements check)
   - BPF program loading (min/max version validation)

### Why This Matters for SM6375

- SM6375 devices may have backported BPF features
- Kernel version reported may not match actual capabilities
- Override allows proper BPF program/map loading

## Documentation Quality

### Verification Done
- ✓ All file paths verified to exist
- ✓ Code snippets tested for syntax
- ✓ Configuration examples validated
- ✓ Relative paths used for maintainability
- ✓ Generic terminology for broad applicability
- ✓ No hardcoded line numbers

### Review Feedback Addressed
- Removed specific line number references
- Updated to use relative file paths
- Made terminology more generic
- Improved function references
- Fixed markdown link paths

## Commit History

1. **Initial plan** - Outlined the implementation approach
2. **Add SM6375 kernel version override documentation and configuration**
   - Created README_SM6375.md
   - Created sm6375_config.prop
   - Created sm6375_uprobestats.mk

3. **Add documentation references and integration guide for SM6375**
   - Created INTEGRATION_SM6375.md
   - Modified KernelUtils.h with docs

4. **Address code review feedback**
   - Improved documentation accuracy
   - Removed line number references
   - Made terminology more generic

5. **Fix documentation references**
   - Fixed markdown links
   - Improved maintainability

## Testing

### Pre-Integration
- Configuration examples validated
- File paths verified
- Documentation reviewed

### Post-Integration Testing Needed
Device maintainers should verify:
1. Property is set correctly
2. BPF programs load without errors
3. UprobeStats service starts
4. No SELinux denials

## Future Maintenance

### When to Update
- If kernel version requirements change
- If new SM6375 devices are released
- If implementation location changes

### What to Maintain
- Keep SM6375 device list updated
- Verify kernel version recommendations
- Update troubleshooting as needed

## Support

- For SM6375-specific issues: Report to sm6375-fogos project
- For general BPF questions: See Android BPF documentation
- For implementation details: See KernelUtils.h

## Conclusion

This implementation successfully documents the BPF kernel version override feature for SM6375 devices, making it easy for device maintainers to configure and use. The documentation is comprehensive, accurate, and maintainable.
