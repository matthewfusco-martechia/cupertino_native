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

import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// Popup Menu Text Button Widget for FlutterFlow
///
/// Displays a simple text label with chevron icon that opens a native popup menu.
/// Combines custom visual styling (text + chevron) with native popup menu behavior.
class PopupMenuTextButton extends StatefulWidget {
  const PopupMenuTextButton({
    super.key,
    this.width,
    this.height,
    required this.buttonLabel,
    required this.menuItemLabels,
    this.menuItemIcons,
    this.onItemSelected,
    this.buttonTextColor,
    this.chevronIconName = 'chevron.down',
    this.chevronIconColor,
    this.fontSize,
  });

  final double? width;
  final double? height;

  /// Text label for the button (e.g., "Actions")
  final String buttonLabel;

  /// List of menu item labels
  final List<String> menuItemLabels;

  /// Optional list of SF Symbol names for each menu item.
  /// Must match length of [menuItemLabels] if provided.
  /// Use empty string "" to skip an icon for a specific item.
  /// Use "---" as a label to insert a divider.
  final List<String>? menuItemIcons;

  /// Callback when a menu item is selected (returns the index)
  final Future<dynamic> Function(int index)? onItemSelected;

  /// Color of the button text
  final Color? buttonTextColor;

  /// SF Symbol name for the chevron icon (defaults to "chevron.down")
  /// Common options: "chevron.down", "chevron.up", "chevron.right", "chevron.left"
  final String chevronIconName;

  /// Color of the chevron icon (defaults to button text color)
  final Color? chevronIconColor;

  /// Font size for the button text (defaults to 17.0)
  final double? fontSize;

  @override
  State<PopupMenuTextButton> createState() => _PopupMenuTextButtonState();
}

class _PopupMenuTextButtonState extends State<PopupMenuTextButton> {
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

    for (var i = 0; i < widget.menuItemLabels.length; i++) {
      final label = widget.menuItemLabels[i];

      // Check for divider
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
          size: 18,
        );
      }

      entries.add(CNPopupMenuItem(
        label: label,
        icon: icon,
        enabled: true,
      ));
    }

    return entries;
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

    final defaultTextColor = widget.buttonTextColor ??
        CupertinoColors.activeBlue;
    final defaultChevronColor = widget.chevronIconColor ?? defaultTextColor;
    final defaultFontSize = widget.fontSize ?? 17.0;

    final totalHeight = (widget.height ?? 44.0) + 20.0; // Add 20px for menu spacing
    
    return SizedBox(
      width: widget.width,
      height: widget.height ?? 44.0,
      child: Stack(
        clipBehavior: Clip.none, // Allow overflow
        children: [
          // Invisible native button - extended below to push menu down
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: -20.0, // Extend 20px below the visible area
            child: Opacity(
              opacity: 0.01,
              child: CNPopupMenuButton(
                buttonLabel: widget.buttonLabel,
                items: _buildMenuItems(),
                onSelected: (index) {
                  if (widget.onItemSelected != null) {
                    widget.onItemSelected!(index);
                  }
                },
                buttonStyle: CNButtonStyle.plain,
                shrinkWrap: true,
                height: totalHeight,
              ),
            ),
          ),
          // Visual text + chevron overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: (widget.width ?? 200.0) - 8.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            widget.buttonLabel,
                            style: TextStyle(
                              color: defaultTextColor,
                              fontSize: defaultFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        CNIcon(
                          symbol: CNSymbol(
                            widget.chevronIconName,
                            size: 14,
                            color: defaultChevronColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

