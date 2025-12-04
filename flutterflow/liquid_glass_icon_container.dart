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

import 'index.dart'; // Imports other custom widgets

import 'package:cupertino_native/cupertino_native.dart';

// IMPORTANT: This package must be added as a dependency
// in your FlutterFlow project settings (Custom Code -> Dependencies).

/// Liquid Glass Icon Container Widget for FlutterFlow
///
/// Two native liquid glass icon buttons side by side with full iOS 26+
/// liquid glass interactivity (wobble/stretch effect).
class LiquidGlassIconContainer extends StatefulWidget {
  const LiquidGlassIconContainer({
    super.key,
    this.width,
    this.height,
    this.icon1SymbolName,
    this.icon1Action,
    this.icon1Color,
    this.icon1Size,
    this.icon2SymbolName,
    this.icon2Action,
    this.icon2Color,
    this.icon2Size,
    this.buttonSize,
    this.spacing,
  });

  final double? width;
  final double? height;

  /// SF Symbol name for the first icon (e.g., "gearshape", "message")
  final String? icon1SymbolName;
  final Future Function()? icon1Action;
  final Color? icon1Color;
  final double? icon1Size;

  /// SF Symbol name for the second icon
  final String? icon2SymbolName;
  final Future Function()? icon2Action;
  final Color? icon2Color;
  final double? icon2Size;

  /// Size of each glass button
  final double? buttonSize;

  /// Spacing between the two buttons
  final double? spacing;

  @override
  State<LiquidGlassIconContainer> createState() =>
      _LiquidGlassIconContainerState();
}

class _LiquidGlassIconContainerState extends State<LiquidGlassIconContainer> {
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

    final defaultIconColor = FlutterFlowTheme.of(context).primaryText;
    final defaultIconSize = 24.0;
    final defaultButtonSize = widget.buttonSize ?? 48.0;
    final defaultSpacing = widget.spacing ?? 8.0;

    final icon1Symbol = widget.icon1SymbolName ?? "gearshape";
    final icon2Symbol = widget.icon2SymbolName ?? "message";

    final icon1Color = widget.icon1Color ?? defaultIconColor;
    final icon2Color = widget.icon2Color ?? defaultIconColor;

    final icon1Size = widget.icon1Size ?? defaultIconSize;
    final icon2Size = widget.icon2Size ?? defaultIconSize;

    if (_isHidden) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon 1 - Native glass button with full interactivity
          CNButton.icon(
            style: CNButtonStyle.glass,
            size: defaultButtonSize,
            icon: CNSymbol(
              icon1Symbol,
              size: icon1Size,
              color: icon1Color,
            ),
            onPressed: widget.icon1Action != null
                ? () => widget.icon1Action!()
                : null,
          ),
          SizedBox(width: defaultSpacing),
          // Icon 2 - Native glass button with full interactivity
          CNButton.icon(
            style: CNButtonStyle.glass,
            size: defaultButtonSize,
            icon: CNSymbol(
              icon2Symbol,
              size: icon2Size,
              color: icon2Color,
            ),
            onPressed: widget.icon2Action != null
                ? () => widget.icon2Action!()
                : null,
          ),
        ],
      ),
    );
  }
}
