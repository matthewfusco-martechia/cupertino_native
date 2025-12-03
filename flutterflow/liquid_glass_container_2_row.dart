// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A glass-style container with two rows of text for FlutterFlow.
class FFLiquidGlassContainer2Row extends StatelessWidget {
  const FFLiquidGlassContainer2Row({
    super.key,
    this.width,
    this.height,
    this.containerRadius = 16.0,
    required this.line1Text,
    this.line1Size = 20.0,
    this.line1Color,
    required this.line2Text,
    this.line2Size = 14.0,
    this.line2Color,
    this.tintColor,
    this.glassStyle = 'regular',
    this.isDarkMode = false,
    this.onPressed,
  });

  /// The width of the widget (optional).
  final double? width;

  /// The height of the widget (optional).
  final double? height;

  /// Rounded corner radius of the glass container.
  final double containerRadius;

  /// The main title text.
  final String line1Text;

  /// Font size for line 1.
  final double line1Size;

  /// Text color for line 1 (auto-selected based on isDarkMode if not provided).
  final Color? line1Color;

  /// The subtitle text.
  final String line2Text;

  /// Font size for line 2.
  final double line2Size;

  /// Text color for line 2 (auto-selected based on isDarkMode if not provided).
  final Color? line2Color;

  /// Tint color for the glass effect.
  final Color? tintColor;

  /// The style of the glass effect (e.g., 'regular', 'prominent', 'clear').
  final String glassStyle;

  /// Whether to use dark mode styling.
  final bool isDarkMode;

  /// Action when the container is pressed.
  final Future<void> Function()? onPressed;

  CNGlassStyle _resolveGlassStyle(String style) {
    switch (style.toLowerCase()) {
      case 'regular':
        return CNGlassStyle.regular;
      case 'clear':
        return CNGlassStyle.clear;
      default:
        return CNGlassStyle.regular;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on dark mode
    final effectiveLine1Color = line1Color ?? (isDarkMode ? Colors.white : Colors.black);
    final effectiveLine2Color = line2Color ?? (isDarkMode ? Colors.white70 : Colors.black54);

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CNGlassEffectContainer(
                cornerRadius: containerRadius,
                glassStyle: _resolveGlassStyle(glassStyle),
                tint: tintColor,
                interactive: onPressed != null,
                onTap: onPressed != null ? () => onPressed?.call() : null,
                child: const SizedBox(),
              ),
            ),
            IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      line1Text,
                      style: TextStyle(
                        fontSize: line1Size,
                        fontWeight: FontWeight.bold,
                        color: effectiveLine1Color,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      line2Text,
                      style: TextStyle(
                        fontSize: line2Size,
                        fontWeight: FontWeight.normal,
                        color: effectiveLine2Color,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
