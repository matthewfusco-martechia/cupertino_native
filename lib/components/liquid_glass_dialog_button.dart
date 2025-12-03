import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/components/glass_effect_container.dart';

/// A button that triggers a native Cupertino dialog or action sheet.
class LiquidGlassDialogButton extends StatelessWidget {
  const LiquidGlassDialogButton({
    super.key,
    this.width,
    this.height,
    required this.buttonText,
    this.buttonTextColor = CupertinoColors.label,
    this.buttonGlassStyle = CNGlassStyle.regular,
    this.buttonTint,
    required this.dialogTitle,
    required this.dialogMessage,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
    this.isDestructive = false,
    this.useActionSheet = false,
    this.onConfirm,
  });

  final double? width;
  final double? height;
  final String buttonText;
  final Color buttonTextColor;
  final CNGlassStyle buttonGlassStyle;
  final Color? buttonTint;
  final String dialogTitle;
  final String dialogMessage;
  final String confirmButtonText;
  final String cancelButtonText;
  final bool isDestructive;
  final bool useActionSheet;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: CNGlassEffectContainer(
              cornerRadius: 16.0,
              glassStyle: buttonGlassStyle,
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
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: buttonTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
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
              onPressed: () {
                Navigator.pop(context);
                onConfirm?.call();
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
              onPressed: () {
                Navigator.pop(context);
                onConfirm?.call();
              },
              child: Text(confirmButtonText),
            ),
          ],
        ),
      );
    }
  }
}

