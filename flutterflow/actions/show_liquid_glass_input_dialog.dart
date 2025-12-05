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

/// Shows a Liquid Glass input dialog matching iOS native rename dialog.
///
/// Parameters:
/// - title: Dialog title (e.g., "Rename Conversation")
/// - initialText: Pre-filled text in the input field
/// - placeholder: Placeholder text when field is empty
/// - confirmButtonText: Text for confirm button (e.g., "Rename")
/// - cancelButtonText: Text for cancel button (e.g., "Cancel")
/// - onConfirmAction: Callback action triggered when confirm is pressed (receives entered text)
/// - onCancelAction: Callback action triggered when cancel is pressed (dismisses dialog)
Future showLiquidGlassInputDialog(
  BuildContext context,
  String title,
  String? initialText,
  String placeholder,
  String confirmButtonText,
  String cancelButtonText,
  Future Function(String enteredText) onConfirmAction,
  Future Function()? onCancelAction,
) async {
  // Detect dark mode from FlutterFlow theme
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) {
      return Theme(
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: CupertinoTheme(
          data: CupertinoThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
          ),
          child: LiquidGlassInputDialog(
            title: title,
            initialText: initialText,
            placeholder: placeholder,
            confirmButtonText: confirmButtonText,
            cancelButtonText: cancelButtonText,
            onConfirm: (text) async {
              Navigator.of(ctx).pop();
              await onConfirmAction(text);
            },
            onCancel: () async {
              Navigator.of(ctx).pop();
              await onCancelAction?.call();
            },
          ),
        ),
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
