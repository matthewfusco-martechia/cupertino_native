import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/components/glass_effect_container.dart';

/// A glass-style container with two rows of text.
class LiquidGlassContainer2Row extends StatelessWidget {
  const LiquidGlassContainer2Row({
    super.key,
    this.containerRadius = 16.0,
    required this.line1Text,
    this.line1Size = 20.0,
    this.line1Color = CupertinoColors.label,
    required this.line2Text,
    this.line2Size = 14.0,
    this.line2Color = CupertinoColors.label,
    this.tintColor,
    this.glassStyle = CNGlassStyle.regular,
    this.onPressed,
  });

  /// Rounded corner radius of the glass container.
  final double containerRadius;

  /// The main title text.
  final String line1Text;

  /// Font size for line 1.
  final double line1Size;

  /// Text color for line 1.
  final Color line1Color;

  /// The subtitle text.
  final String line2Text;

  /// Font size for line 2.
  final double line2Size;

  /// Text color for line 2.
  final Color line2Color;

  /// Tint color for the glass effect.
  final Color? tintColor;

  /// The style of the glass effect.
  final CNGlassStyle glassStyle;

  /// Optional action when the container is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // Use a Stack so the container sizes itself to the text content,
    // but let the CNGlassEffectContainer handle the interaction and background.
    return Stack(
      children: [
        Positioned.fill(
          child: CNGlassEffectContainer(
            cornerRadius: containerRadius,
            glassStyle: glassStyle,
            tint: tintColor,
            interactive: onPressed != null,
            onTap: onPressed,
            child: const SizedBox(),
          ),
        ),
        // Pass touches through the text layer to the glass container below
        IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  line1Text,
                  style: TextStyle(
                    fontSize: line1Size,
                    fontWeight: FontWeight.bold,
                    color: line1Color,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  line2Text,
                  style: TextStyle(
                    fontSize: line2Size,
                    fontWeight: FontWeight.normal,
                    color: line2Color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

