// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// Shows a liquid glass styled message dialog.
///
/// Returns true if user pressed confirm, false if cancelled or dismissed.
///
/// Parameters:
/// - title: Dialog title
/// - message: Dialog message/text
/// - cancelButtonText: Text for cancel button (defaults to "Cancel")
/// - confirmButtonText: Text for confirm button (defaults to "OK")
Future<bool> showLiquidGlassMessageDialog(
  BuildContext context,
  String title,
  String message, {
  String? cancelButtonText,
  String? confirmButtonText,
}) async {
  bool? result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) {
      return _LiquidGlassMessageDialog(
        title: title,
        message: message,
        cancelButtonText: cancelButtonText ?? 'Cancel',
        confirmButtonText: confirmButtonText ?? 'OK',
        onCancel: () {
          Navigator.of(ctx).pop(false);
        },
        onConfirm: () {
          Navigator.of(ctx).pop(true);
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

  return result ?? false; // Return false if dismissed
}

/// Internal dialog widget matching the liquid glass design
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

