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

/// Liquid Glass Text Button Widget for FlutterFlow
///
/// A glass-styled text button with native iOS liquid glass effect.
/// Direct 1:1 replica of the "Glass Red" button from the demo.
class LiquidGlassTextButton extends StatefulWidget {
  const LiquidGlassTextButton({
    super.key,
    this.width,
    this.height,
    required this.buttonText,
    this.textColor,
    this.onPressed,
  });

  final double? width;
  final double? height;

  /// Text to display on the button
  final String buttonText;

  /// Color of the button text (tint color)
  final Color? textColor;

  /// Callback when button is pressed
  final Future<dynamic> Function()? onPressed;

  @override
  State<LiquidGlassTextButton> createState() => _LiquidGlassTextButtonState();
}

class _LiquidGlassTextButtonState extends State<LiquidGlassTextButton> {
  bool _isHidden = false;

  void _checkModalStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) {
        if (!_isHidden) {
          setState(() => _isHidden = true);
        }
      } else {
        if (_isHidden) {
          setState(() => _isHidden = false);
        }
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

    return SizedBox(
      width: widget.width,
      height: widget.height ?? 44.0,
      child: CNButton(
        label: widget.buttonText,
        style: CNButtonStyle.glass,
        tint: widget.textColor,
        onPressed: widget.onPressed != null
            ? () async {
                await widget.onPressed!();
              }
            : null,
        shrinkWrap: widget.width == null, // Auto-size if no width specified
        height: widget.height ?? 44.0,
      ),
    );
  }
}

