# Text Scaling

## Overview

Text scaling allows you to adjust the size of all text throughout SKeys for better readability and comfort. This is an accessibility feature that helps ensure the application is usable for people with different vision needs.

## How It Works

Text scaling multiplies all text sizes in the application by a scale factor:

- **Small** (85%): All text is 85% of normal size
- **Normal** (100%): Default text size
- **Large** (115%): All text is 15% larger than normal
- **Extra Large** (130%): All text is 30% larger than normal

Changes take effect immediately and apply throughout the entire application.

## What Text Scaling Affects

Text scaling affects:

- **List items**: SSH keys, hosts, and server entries
- **Dialogs and windows**: Settings, confirmations, and information dialogs
- **Buttons and labels**: All interactive elements and their labels
- **Menu items**: Context menus and dropdown menus
- **Status messages**: Notifications and status bar text
- **Tooltips**: Hover text and help information
- **Form fields**: Input labels and placeholder text

## What Text Scaling Does NOT Affect

Text scaling does not change:

- **Icons**: Icons remain the same size for visual consistency
- **Window chrome**: System title bars and window decorations
- **Monospace fonts**: SSH keys and fingerprints maintain their fixed-width formatting
- **System UI**: Operating system dialogs and notifications

## Choosing the Right Scale

### Small (85%)
- **Best for**: Users who want to see more content at once
- **Use when**: You have a large display and good vision
- **Trade-off**: Text may be harder to read for extended periods

### Normal (100%)
- **Best for**: Most users and general use
- **Use when**: The default size is comfortable
- **Trade-off**: None - this is the designed baseline

### Large (115%)
- **Best for**: Improved readability on high-resolution displays
- **Use when**: You find yourself squinting at normal text
- **Trade-off**: Slightly less content visible at once

### Extra Large (130%)
- **Best for**: Accessibility needs and users with vision impairments
- **Use when**: Maximum readability is required
- **Trade-off**: May cause layout issues in some dialogs (see Limitations)

## Limitations and Known Issues

### Layout Overflow

**Warning**: Large text sizes (especially Extra Large at 130%) may cause text overflow or layout issues in some constrained spaces.

This can happen in:
- **Narrow dialogs**: Text may wrap unexpectedly or exceed available space
- **Buttons**: Very long button labels may be truncated
- **Tables and lists**: Column headers may overlap
- **Fixed-width containers**: Some layouts have minimum size constraints

**If you experience layout issues**:
1. Select a smaller text scale
2. Resize the application window to be larger
3. Report the specific dialog or screen where issues occur

### Reset to Normal

If text scaling makes the UI difficult to use:

1. **Quick reset**: Click the "Normal" option in Display Settings
2. **Keyboard navigation**: Use Tab to navigate to the Normal option if UI is broken
3. **Full reset**: Go to Settings → General → Reset to restore all defaults

### Performance Considerations

Extra large text scales may have minor performance impacts on:
- Initial window rendering
- Scrolling through very long lists
- Complex dialogs with many text elements

For most users and typical use cases, performance impact is negligible.

## Interaction with System Settings

### Desktop Environment Scaling

SKeys text scaling is **independent** of your system's display scaling:

- System scaling affects the entire application window size and all elements
- SKeys text scaling only affects text sizes within the application
- Both can be used together for maximum customization

**Example**: If your desktop is set to 125% scaling and you choose Large (115%) in SKeys, text will effectively be scaled to approximately 144% of the original design size.

### System Accessibility Settings

SKeys text scaling provides in-app control and does not override system-level accessibility features. Both can work together:

- Use system scaling for all applications
- Use SKeys text scaling for fine-tuned control within SKeys

## Best Practices

### For General Use

1. Start with **Normal** and adjust up or down based on comfort
2. Give each setting a few minutes of use before deciding
3. Consider your typical viewing distance and display size
4. Use the preview in Display Settings to test before applying

### For Accessibility

1. **Extra Large** provides maximum readability
2. Combine with your system's accessibility features for best results
3. Ensure your application window is large enough to prevent layout issues
4. Report any UI problems so they can be fixed

### For High-Resolution Displays

1. **Large** or **Extra Large** often works better on 4K displays
2. Higher resolution allows larger text without layout issues
3. Adjust based on your physical screen size and viewing distance

## Testing Your Selection

After changing text size:

1. Navigate through different screens (Keys, Hosts, Settings)
2. Open a few dialogs (Add Key, Server Config, etc.)
3. Check that all text is readable and layouts look correct
4. Use the application for typical tasks to ensure comfort
5. Adjust if needed - your preference may change over time

## Troubleshooting

### Text appears blurry

- **Cause**: May be related to system display scaling or font rendering
- **Solution**: This is typically a system-level issue. Check your desktop environment's font rendering settings.

### Some text didn't change size

- **Cause**: A few specific UI elements may have fixed sizes
- **Solution**: This is usually intentional (e.g., monospace SSH keys). If it seems wrong, please report it.

### Dialog buttons are cut off

- **Cause**: Extra large text in a small window
- **Solution**:
  1. Resize the application window larger
  2. Choose a smaller text scale
  3. Report the specific dialog for potential fix

### Application feels slow after increasing text size

- **Cause**: Rendering more complex text layouts
- **Solution**:
  1. Try the next smaller size
  2. Close and reopen the application
  3. Check system resources (CPU/memory)

## Tips

- **Preview before committing**: Use the preview box to see exactly how text will appear
- **Consider your workflow**: If you mostly read lists, larger text helps. If you manage many keys, smaller text shows more at once.
- **Adjust over time**: Your preference may change based on time of day, fatigue, or ambient lighting
- **Combine with theme**: Dark mode with large text can reduce eye strain in low-light conditions
- **No wrong choice**: The best text size is the one that's most comfortable for you

## Related Settings

- [Display Settings](skeys://settings/display) - Overall display settings including theme
- [General Settings](skeys://settings/system) - Reset all settings to defaults

---

[Back to Display Settings](skeys://help/settings-display)
[Open Display Settings](skeys://settings/display)
