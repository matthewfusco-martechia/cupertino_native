// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cupertino_native/cupertino_native.dart';

// IMPORTANT: This package must be added as a dependency
// in your FlutterFlow project settings (Custom Code -> Dependencies).

/// Liquid Glass Icon Popup Menu Button Widget for FlutterFlow
///
/// Displays a plain icon that opens a native popup menu when pressed.
/// Similar to the text-only popup button but with an icon instead.
class LiquidGlassIconPopupMenuButton extends StatefulWidget {
  const LiquidGlassIconPopupMenuButton({
    super.key,
    this.width,
    this.height,
    required this.iconSymbolName,
    required this.menuItemLabels,
    this.menuItemIcons,
    this.onItemSelected,
    this.iconSize,
    this.iconColor,
    this.tintColor,
    this.menuIconSize,
  });

  final double? width;
  final double? height;

  /// SF Symbol name for the button icon (e.g., "ellipsis.circle", "gearshape")
  final String iconSymbolName;

  /// List of menu item labels
  final List<String> menuItemLabels;

  /// Optional list of SF Symbol names for each menu item.
  /// Must match length of [menuItemLabels] if provided.
  /// Use empty string "" to skip an icon for a specific item.
  final List<String>? menuItemIcons;

  /// Callback when a menu item is selected (returns the index)
  final Future<dynamic> Function(int index)? onItemSelected;

  /// Size of the button icon symbol (defaults to 20.0)
  final double? iconSize;

  /// Color of the button icon
  final Color? iconColor;

  /// Tint color for the button
  final Color? tintColor;

  /// Size of menu item icons (defaults to 18.0)
  final double? menuIconSize;

  @override
  State<LiquidGlassIconPopupMenuButton> createState() =>
      _LiquidGlassIconPopupMenuButtonState();
}

class _LiquidGlassIconPopupMenuButtonState
    extends State<LiquidGlassIconPopupMenuButton> {
  bool _isHidden = false;

  void _checkModalStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      final shouldHide = route != null && !route.isCurrent;
      if (shouldHide != _isHidden) {
        setState(() {
          _isHidden = shouldHide;
        });
      }
    });
  }

  List<CNPopupMenuEntry> _buildMenuItems() {
    final entries = <CNPopupMenuEntry>[];
    final defaultMenuIconSize = widget.menuIconSize ?? 18.0;

    for (var i = 0; i < widget.menuItemLabels.length; i++) {
      final label = widget.menuItemLabels[i];

      // Check if this is a divider
      if (label.trim() == '---') {
        entries.add(const CNPopupMenuDivider());
        continue;
      }

      // Get icon if available
      CNSymbol? icon;
      if (widget.menuItemIcons != null &&
          i < widget.menuItemIcons!.length &&
          widget.menuItemIcons![i].isNotEmpty) {
        icon = CNSymbol(
          widget.menuItemIcons![i],
          size: defaultMenuIconSize,
        );
      }

      entries.add(CNPopupMenuItem(
        label: label,
        icon: icon,
        enabled: true,
      ));
    }
    // Reverse to fix native menu display order
    return entries.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    _checkModalStatus();

    if (_isHidden) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }

    final defaultIconColor =
        widget.iconColor ?? FlutterFlowTheme.of(context).primaryText;
    final defaultIconSize = widget.iconSize ?? 20.0;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CNPopupMenuButton.icon(
        buttonIcon: CNSymbol(
          widget.iconSymbolName,
          size: defaultIconSize,
          color: defaultIconColor,
        ),
        items: _buildMenuItems(),
        onSelected: (index) {
          if (widget.onItemSelected != null) {
            widget.onItemSelected!(index);
          }
        },
        tint: widget.tintColor,
        buttonStyle: CNButtonStyle.plain,
      ),
    );
  }
}
