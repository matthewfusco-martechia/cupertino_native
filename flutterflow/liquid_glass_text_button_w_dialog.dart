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

/// Liquid Glass Text Button with Dialog Widget for FlutterFlow
///
/// A glass-styled button that shows a liquid glass dialog when pressed.
/// Dialog design matches the Input Dialog Action demo but displays text instead of an input field.
class LiquidGlassTextButtonWDialog extends StatefulWidget {
  const LiquidGlassTextButtonWDialog({
    super.key,
    this.width,
    this.height,
    required this.buttonText,
    this.buttonTextColor,
    required this.dialogTitle,
    required this.dialogMessage,
    this.cancelButtonText = 'Cancel',
    this.confirmButtonText = 'OK',
    this.onConfirm,
  });

  final double? width;
  final double? height;

  /// Text to display on the button
  final String buttonText;

  /// Color of the button text
  final Color? buttonTextColor;

  /// Title of the dialog
  final String dialogTitle;

  /// Message/text to display in the dialog
  final String dialogMessage;

  /// Text for the cancel button (defaults to "Cancel")
  final String cancelButtonText;

  /// Text for the confirm button (defaults to "OK")
  final String confirmButtonText;

  /// Callback when dialog confirm button is pressed
  final Future<dynamic> Function()? onConfirm;

  @override
  State<LiquidGlassTextButtonWDialog> createState() =>
      _LiquidGlassTextButtonWDialogState();
}

class _LiquidGlassTextButtonWDialogState
    extends State<LiquidGlassTextButtonWDialog> {
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

  Future<void> _showDialog() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return _LiquidGlassMessageDialog(
          title: widget.dialogTitle,
          message: widget.dialogMessage,
          cancelButtonText: widget.cancelButtonText,
          confirmButtonText: widget.confirmButtonText,
          onCancel: () {
            Navigator.of(ctx).pop();
          },
          onConfirm: () async {
            Navigator.of(ctx).pop();
            if (widget.onConfirm != null) {
              await widget.onConfirm!();
            }
          },
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curvedAnim = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnim),
          child: FadeTransition(
            opacity: curvedAnim,
            child: child,
          ),
        );
      },
    );
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
        tint: widget.buttonTextColor,
        onPressed: _showDialog,
        shrinkWrap: widget.width == null,
        height: widget.height ?? 44.0,
      ),
    );
  }
}

/// Internal dialog widget matching the liquid glass input dialog design
class _LiquidGlassMessageDialog extends StatelessWidget {
  const _LiquidGlassMessageDialog({
    required this.title,
    required this.message,
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.onCancel,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    // Text Colors - matching iOS native
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor =
        isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6);

    // Button background - native iOS dialog button style
    final buttonBackgroundColor =
        isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE8E8ED);

    return Align(
      alignment: const Alignment(0, -0.3),
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            // Liquid Glass Background
            Positioned.fill(
              child: CNGlassEffectContainer(
                glassStyle: CNGlassStyle.regular,
                cornerRadius: 20,
                interactive: false,
                child: const SizedBox(),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      decoration: TextDecoration.none,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: secondaryTextColor,
                      decoration: TextDecoration.none,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Action Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: onCancel,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: buttonBackgroundColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cancelButtonText,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Confirm Button
                      Expanded(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: onConfirm,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: buttonBackgroundColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              confirmButtonText,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

