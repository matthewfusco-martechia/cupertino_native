# Cupertino Colors Reference

This document outlines the available color constants from `CupertinoColors` in Flutter, which map to standard iOS system colors.

## Standard System Colors (Light/Dark Adaptive)
These colors automatically adjust based on the user's Light or Dark mode setting.

| Color Name | Constant | Description |
| :--- | :--- | :--- |
| **Red** | `CupertinoColors.systemRed` | Standard Red |
| **Orange** | `CupertinoColors.systemOrange` | Standard Orange |
| **Yellow** | `CupertinoColors.systemYellow` | Standard Yellow |
| **Green** | `CupertinoColors.systemGreen` | Standard Green |
| **Mint** | `CupertinoColors.systemMint` | Standard Mint |
| **Teal** | `CupertinoColors.systemTeal` | Standard Teal |
| **Cyan** | `CupertinoColors.systemCyan` | Standard Cyan |
| **Blue** | `CupertinoColors.systemBlue` | Standard Blue (Default Tint) |
| **Indigo** | `CupertinoColors.systemIndigo` | Standard Indigo |
| **Purple** | `CupertinoColors.systemPurple` | Standard Purple |
| **Pink** | `CupertinoColors.systemPink` | Standard Pink |
| **Brown** | `CupertinoColors.systemBrown` | Standard Brown |
| **Gray** | `CupertinoColors.systemGrey` | Standard Gray |

## Destructive Colors
| Color Name | Constant | Description |
| :--- | :--- | :--- |
| **Destructive Red** | `CupertinoColors.destructiveRed` | Used for destructive actions (e.g., Delete) |

## Label & Text Colors (Dynamic)
Use these for text to ensure it is visible on both light and dark backgrounds.

| Color Name | Constant | Description |
| :--- | :--- | :--- |
| **Label** | `CupertinoColors.label` | Primary text color (Black in Light, White in Dark) |
| **Secondary Label** | `CupertinoColors.secondaryLabel` | Less prominent text |
| **Tertiary Label** | `CupertinoColors.tertiaryLabel` | Even less prominent text |
| **Quaternary Label** | `CupertinoColors.quaternaryLabel` | Least prominent text |
| **Placeholder Text** | `CupertinoColors.placeholderText` | For input placeholders |
| **Link** | `CupertinoColors.link` | For clickable links |

## Backgrounds (Dynamic)
| Color Name | Constant | Description |
| :--- | :--- | :--- |
| **System Background** | `CupertinoColors.systemBackground` | Standard page background |
| **Secondary Background** | `CupertinoColors.secondarySystemBackground` | Slightly layered background |
| **Tertiary Background** | `CupertinoColors.tertiarySystemBackground` | More layered background |
| **Grouped Background** | `CupertinoColors.systemGroupedBackground` | For grouped lists (grayish in light mode) |

## Grays (Fixed/Adaptive)
| Color Name | Constant | Description |
| :--- | :--- | :--- |
| **System Grey** | `CupertinoColors.systemGrey` | Base Gray |
| **System Grey 2** | `CupertinoColors.systemGrey2` | Slightly lighter/darker |
| **System Grey 3** | `CupertinoColors.systemGrey3` | ... |
| **System Grey 4** | `CupertinoColors.systemGrey4` | ... |
| **System Grey 5** | `CupertinoColors.systemGrey5` | ... |
| **System Grey 6** | `CupertinoColors.systemGrey6` | Very subtle gray |

## Separators & Fills
| Color Name | Constant | Description |
| :--- | :--- | :--- |
| **Separator** | `CupertinoColors.separator` | Thin lines between list items |
| **Opaque Separator** | `CupertinoColors.opaqueSeparator` | Solid version of separator |
| **System Fill** | `CupertinoColors.systemFill` | For filling shapes |
| **Secondary Fill** | `CupertinoColors.secondarySystemFill` | ... |

## Active Colors
| Color Name | Constant | Description |
| :--- | :--- | :--- |
| **Active Blue** | `CupertinoColors.activeBlue` | Often same as systemBlue, used for active states |
| **Active Green** | `CupertinoColors.activeGreen` | Often same as systemGreen |
| **Active Orange** | `CupertinoColors.activeOrange` | Often same as systemOrange |

## Usage Example
```dart
Container(
  color: CupertinoColors.systemBackground,
  child: Text(
    'Hello World',
    style: TextStyle(
      color: CupertinoColors.label, // Adaptive Black/White
    ),
  ),
)
```

