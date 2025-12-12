// FlutterFlow compatible
import 'package:flutter/material.dart';

// ============================================================================
// IMPORTANT: You MUST add the cupertino_native package to your FlutterFlow project!
// 
// In FlutterFlow:
// 1. Go to Settings (gear icon) > Project Dependencies
// 2. Click "Add Dependency"
// 3. Select "Git" source
// 4. URL: https://github.com/matthewfusco-martechia/cupertino_native.git
// 5. Ref: main
// 6. Click "Add" and wait for rebuild
//
// Without this package, the widget will NOT compile!
// ============================================================================
import 'package:cupertino_native/cupertino_native.dart' as cn;

/// Display a native Cupertino SF Symbol icon.
///
/// Simply provide the SF Symbol name (like "mic", "star.fill", "heart")
/// and optional color. The icon will render using native iOS SF Symbols.
///
/// ## Common SF Symbol Names:
/// - "mic", "mic.fill"
/// - "star", "star.fill"
/// - "heart", "heart.fill"
/// - "person", "person.fill"
/// - "bell", "bell.fill"
/// - "camera", "camera.fill"
/// - "paperplane", "paperplane.fill"
/// - "arrow.up", "arrow.down", "arrow.left", "arrow.right"
/// - "checkmark", "checkmark.circle"
/// - "plus", "minus"
/// - "gear", "gear.circle"
///
/// Find more at: https://developer.apple.com/sf-symbols/
///
/// ## Parameters:
/// - [width]: Required width of the widget (FlutterFlow requirement)
/// - [height]: Required height of the widget (FlutterFlow requirement)
/// - [iconName]: SF Symbol name (required)
/// - [color]: Icon color (optional, defaults to theme color)
/// - [iconSize]: Icon size in pixels (optional, defaults to smaller of width/height)
class CupertinoIcon extends StatelessWidget {
  const CupertinoIcon({
    super.key,
    required this.width,
    required this.height,
    required this.iconName,
    this.color,
    this.iconSize,
  });

  /// The width of the widget (required by FlutterFlow).
  final double width;

  /// The height of the widget (required by FlutterFlow).
  final double height;

  /// The SF Symbol name (e.g., "mic", "star.fill", "heart")
  final String iconName;

  /// The color of the icon. If null, uses the current theme color.
  final Color? color;

  /// The size of the icon in pixels. If null, uses smaller of width/height.
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = iconSize ?? (width < height ? width : height);
    
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: cn.CNIcon(
          symbol: cn.CNSymbol(
            iconName,
            size: effectiveSize,
            color: color,
          ),
        ),
      ),
    );
  }
}

