import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A simple Cupertino icon button widget.
///
/// Displays just the icon without any background container.
/// Triggers a callback when pressed.
class CupertinoIconButton extends StatelessWidget {
  const CupertinoIconButton({
    super.key,
    required this.iconName,
    required this.onPressed,
    this.iconSize = 20.0,
    this.iconColor,
    this.buttonSize = 44.0,
  });

  /// SF Symbol name for the icon (e.g. "heart", "star.fill", "gearshape").
  final String iconName;

  /// Callback when the button is pressed.
  final VoidCallback onPressed;

  /// Size of the icon symbol. Defaults to 20.0.
  final double iconSize;

  /// Color of the icon symbol.
  final Color? iconColor;

  /// Diameter of the circular button. Defaults to 44.0.
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return CNButton.icon(
      style: CNButtonStyle.plain,
      size: buttonSize,
      icon: CNSymbol(
        iconName,
        size: iconSize,
        color: iconColor,
      ),
      onPressed: onPressed,
    );
  }
}

