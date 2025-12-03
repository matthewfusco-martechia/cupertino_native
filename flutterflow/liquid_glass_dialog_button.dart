// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A button that triggers a native Cupertino dialog or action sheet.
class FFLiquidGlassDialogButton extends StatelessWidget {
  const FFLiquidGlassDialogButton({
    super.key,
    this.width,
    this.height,
    required this.buttonText,
    this.buttonTextColor,
    this.buttonGlassStyle = 'regular',
    this.buttonTint,
    required this.dialogTitle,
    required this.dialogMessage,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
    this.isDestructive = false,
    this.useActionSheet = false,
    this.isDarkMode = false,
    this.onConfirm,
  });

  /// The width of the button.
  final double? width;

  /// The height of the button.
  final double? height;

  // --- Button Styling ---
  /// Text to display on the trigger button.
  final String buttonText;

  /// Color of the button text (auto-selected based on isDarkMode if not provided).
  final Color? buttonTextColor;

  /// Glass style for the trigger button.
  final String buttonGlassStyle;

  /// Optional tint color for the trigger button.
  final Color? buttonTint;

  // --- Dialog Content ---
  /// Title of the dialog/action sheet.
  final String dialogTitle;

  /// Message body of the dialog/action sheet.
  final String dialogMessage;

  /// Text for the confirmation button.
  final String confirmButtonText;

  /// Text for the cancel button.
  final String cancelButtonText;

  /// Whether the confirm action is destructive (red).
  final bool isDestructive;

  /// Use an Action Sheet (bottom slide-up) instead of an Alert Dialog (center).
  final bool useActionSheet;

  /// Whether to use dark mode styling.
  final bool isDarkMode;

  // --- Action ---
  /// Action to execute when the user confirms.
  final Future<void> Function()? onConfirm;

  CNGlassStyle _resolveGlassStyle(String style) {
    switch (style.toLowerCase()) {
      case 'regular':
        return CNGlassStyle.regular;
      case 'clear':
        return CNGlassStyle.clear;
      default:
        return CNGlassStyle.regular;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on dark mode
    final effectiveTextColor = buttonTextColor ?? (isDarkMode ? Colors.white : CupertinoColors.label);

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: CNGlassEffectContainer(
                  cornerRadius: 16.0,
                  glassStyle: _resolveGlassStyle(buttonGlassStyle),
                  tint: buttonTint,
                  interactive: true,
                  onTap: () => _showDialog(context),
                  child: const SizedBox(),
                ),
              ),
              IgnorePointer(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.0, // Standard iOS body size
                        fontWeight: FontWeight.w600,
                        color: effectiveTextColor,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    if (useActionSheet) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: Text(dialogTitle),
          message: Text(dialogMessage),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: isDestructive,
              onPressed: () async {
                Navigator.pop(context);
                await onConfirm?.call();
              },
              child: Text(confirmButtonText),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(cancelButtonText),
          ),
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogMessage),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: !isDestructive,
              onPressed: () => Navigator.pop(context),
              child: Text(cancelButtonText),
            ),
            CupertinoDialogAction(
              isDestructiveAction: isDestructive,
              onPressed: () async {
                Navigator.pop(context);
                await onConfirm?.call();
              },
              child: Text(confirmButtonText),
            ),
          ],
        ),
      );
    }
  }
}
