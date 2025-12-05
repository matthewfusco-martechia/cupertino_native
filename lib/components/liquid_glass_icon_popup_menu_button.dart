import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A liquid glass icon popup menu button.
///
/// Displays a round glass button with an icon that opens a native popup menu.
/// This widget is pre-configured to use the native liquid glass style.
class LiquidGlassIconPopupMenuButton extends StatelessWidget {
  const LiquidGlassIconPopupMenuButton({
    super.key,
    required this.iconName,
    required this.items,
    required this.onSelected,
    this.iconSize = 20.0,
    this.iconColor,
    this.buttonSize = 44.0,
    this.tint,
  });

  /// SF Symbol name for the button icon (e.g. "ellipsis", "gearshape.fill").
  final String iconName;

  /// Size of the icon symbol. Defaults to 20.0.
  final double iconSize;

  /// Color of the icon symbol.
  final Color? iconColor;

  /// Diameter of the circular button. Defaults to 44.0.
  final double buttonSize;

  /// Tint color for the glass effect.
  final Color? tint;

  /// Menu items to display.
  final List<CNPopupMenuEntry> items;

  /// Callback when an item is selected.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return CNPopupMenuButton.icon(
      buttonIcon: CNSymbol(
        iconName,
        size: iconSize,
        color: iconColor, // Allow tint to style the icon if no color provided
      ),
      size: buttonSize,
      items: items,
      onSelected: onSelected,
      tint: tint,
      buttonStyle: CNButtonStyle.plain,
    );
  }
}
