import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/components/button.dart';
import 'package:cupertino_native/style/button_style.dart';
import 'package:cupertino_native/style/sf_symbol.dart';

/// A container with two native liquid glass icon buttons arranged horizontally.
///
/// Each icon has native iOS liquid glass interactivity (wobble/stretch effect)
/// using CNButton.icon with CNButtonStyle.glass.
class LiquidGlassIconContainer extends StatelessWidget {
  /// Creates a liquid glass icon container with two icons.
  const LiquidGlassIconContainer({
    super.key,
    this.icon1Name = 'gearshape',
    this.icon1Size = 24.0,
    this.icon1Color,
    this.onIcon1Pressed,
    this.icon2Name = 'message',
    this.icon2Size = 24.0,
    this.icon2Color,
    this.onIcon2Pressed,
    this.buttonSize = 48.0,
    this.spacing = 8.0,
  });

  /// SF Symbol name for the first icon (e.g., "gearshape", "message").
  final String icon1Name;

  /// Size of the first icon.
  final double icon1Size;

  /// Color of the first icon.
  final Color? icon1Color;

  /// Callback when the first icon is pressed.
  final VoidCallback? onIcon1Pressed;

  /// SF Symbol name for the second icon.
  final String icon2Name;

  /// Size of the second icon.
  final double icon2Size;

  /// Color of the second icon.
  final Color? icon2Color;

  /// Callback when the second icon is pressed.
  final VoidCallback? onIcon2Pressed;

  /// Size of each glass button.
  final double buttonSize;

  /// Spacing between the two buttons.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final defaultColor = CupertinoColors.label.resolveFrom(context);
    final icon1Color = this.icon1Color ?? defaultColor;
    final icon2Color = this.icon2Color ?? defaultColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon 1 - Native glass button
        CNButton.icon(
          style: CNButtonStyle.glass,
          size: buttonSize,
          icon: CNSymbol(
            icon1Name,
            size: icon1Size,
            color: icon1Color,
          ),
          onPressed: onIcon1Pressed,
        ),
        SizedBox(width: spacing),
        // Icon 2 - Native glass button
        CNButton.icon(
          style: CNButtonStyle.glass,
          size: buttonSize,
          icon: CNSymbol(
            icon2Name,
            size: icon2Size,
            color: icon2Color,
          ),
          onPressed: onIcon2Pressed,
        ),
      ],
    );
  }
}
