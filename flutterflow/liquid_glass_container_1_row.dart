// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A glass-style container with one row of text for FlutterFlow.
class FFLiquidGlassContainer1Row extends StatelessWidget {
  const FFLiquidGlassContainer1Row({
    super.key,
    this.width,
    this.height,
    this.containerRadius = 16.0,
    required this.text,
    this.fontSize = 20.0,
    this.textColor = Colors.black,
    this.tintColor,
    this.glassStyle = 'regular',
    this.onPressed,
  });

  /// The width of the widget (optional).
  final double? width;

  /// The height of the widget (optional).
  final double? height;

  /// Rounded corner radius of the glass container.
  final double containerRadius;

  /// The text to display.
  final String text;

  /// Font size for the text.
  final double fontSize;

  /// Text color.
  final Color textColor;

  /// Tint color for the glass effect.
  final Color? tintColor;

  /// The style of the glass effect (e.g., 'regular', 'prominent', 'clear').
  final String glassStyle;

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
    return SizedBox(
      width: width,
      height: height,
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
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'SF Pro Text',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

