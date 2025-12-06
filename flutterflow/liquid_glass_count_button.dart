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

/// Liquid Glass Count Button (Back Button with Count)
///
/// A pill-shaped glass button with a chevron icon and count number.
/// Perfect for navigation back buttons showing unread counts.
class LiquidGlassCountButton extends StatefulWidget {
  const LiquidGlassCountButton({
    super.key,
    this.width,
    this.height,
    required this.count,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.symbolName,
    this.borderRadius,
  });

  final double? width;
  final double? height;

  /// The count to display (e.g., unread messages)
  final int count;

  /// Callback when the button is pressed
  final Future Function()? onTap;

  /// Color for the chevron icon
  final Color? iconColor;

  /// Color for the count text
  final Color? textColor;

  /// SF Symbol name for the icon (defaults to "chevron.left")
  final String? symbolName;

  /// Border radius for the button (defaults to height/2 for pill shape)
  final double? borderRadius;

  @override
  State<LiquidGlassCountButton> createState() => _LiquidGlassCountButtonState();
}

class _LiquidGlassCountButtonState extends State<LiquidGlassCountButton> {
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

    final iconColor =
        widget.iconColor ?? FlutterFlowTheme.of(context).primaryText;
    final textColor =
        widget.textColor ?? FlutterFlowTheme.of(context).primaryText;
    final buttonHeight = widget.height ?? 44.0;
    final symbolName = widget.symbolName ?? 'chevron.left';
    final radius = widget.borderRadius ?? (buttonHeight / 2);

    // GestureDetector handles tap, CNGlassEffectContainer handles liquid glass physics
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (widget.onTap != null) {
          await widget.onTap!();
        }
      },
      child: CNGlassEffectContainer(
        glassStyle: CNGlassStyle.regular,
        cornerRadius: radius,
        height: buttonHeight,
        interactive: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Chevron Icon
              CNIcon(
                symbol: CNSymbol(
                  symbolName,
                  size: 18,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 8),
              // Count Text
              Text(
                widget.count > 99 ? '99+' : widget.count.toString(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

