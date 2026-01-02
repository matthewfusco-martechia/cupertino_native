## 0.1.13
* **Fix**: Resolved `CNPopupMenuButton` regression causing scroll stutter (bridge spam fix).
* **Performance**: Optimized `CNInput` to prevent redundant native calls.
* **Fix/Feature**: Enabled dynamic updates for `CNSegmentedControl` (labels/icons can now change at runtime).

## 0.1.12
* **Performance**: Implemented `PlatformViewGuard` to eliminate redundant native view recreation during rebuilds.
* **Performance**: Added `active` parameter to all components to allow disabling native views when off-screen.
* **Feature**: Added global kill-switch `CupertinoNativeConfig.platformViewsEnabled` for emergency fallback to Flutter widgets.
* **Refactor**: Improved internal cleanup logic to prevent memory leaks.

## 0.1.2

* Fixed `LiquidGlassSegmentedControl` layout clipping and edge artifacts.
* Restored native `UITabBar` implementation with safety insets for perfect pill shape.
* Optimized icon and text alignment for "Two Tab Bar" aesthetic.

## 0.1.1

* Initial release of Liquid Glass components.
