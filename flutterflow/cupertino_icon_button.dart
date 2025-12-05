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

/// Cupertino Icon Button Widget for FlutterFlow
///
/// Displays just the icon without any background container.
/// Triggers a callback action when pressed.
class CupertinoIconButton extends StatefulWidget {
  const CupertinoIconButton({
    super.key,
    this.width,
    this.height,
    required this.iconSymbolName,
    this.onPressed,
    this.iconSize,
    this.iconColor,
  });

  final double? width;
  final double? height;

  /// SF Symbol name for the icon (e.g., "heart", "star.fill", "gearshape")
  final String iconSymbolName;

  /// Callback when the button is pressed
  final Future<dynamic> Function()? onPressed;

  /// Size of the icon symbol (defaults to 20.0)
  final double? iconSize;

  /// Color of the icon
  final Color? iconColor;

  @override
  State<CupertinoIconButton> createState() => _CupertinoIconButtonState();
}

class _CupertinoIconButtonState extends State<CupertinoIconButton> {
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
    final defaultButtonSize = widget.height ?? widget.width ?? 44.0;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CNButton.icon(
        style: CNButtonStyle.plain,
        size: defaultButtonSize,
        icon: CNSymbol(
          widget.iconSymbolName,
          size: defaultIconSize,
          color: defaultIconColor,
        ),
        onPressed: widget.onPressed != null ? () => widget.onPressed!() : null,
      ),
    );
  }
}

