import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/components/glass_effect_container.dart';

/// A glass-style container with one row of text.
class LiquidGlassContainer1Row extends StatelessWidget {
  const LiquidGlassContainer1Row({
    super.key,
    this.containerRadius = 16.0,
    required this.text,
    this.fontSize = 20.0,
    this.textColor = CupertinoColors.label,
    this.tintColor,
    this.glassStyle = CNGlassStyle.regular,
    this.onPressed,
  });

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
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

