import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

// This mimics the Custom Action function for the demo
Future<String?> _showLiquidGlassInputDialog(
  BuildContext context, {
  required String title,
  String? message,
  String? initialText,
  String placeholder = 'Conversation name',
  String confirmButtonText = 'Rename',
  String cancelButtonText = 'Cancel',
}) async {
  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) {
      return LiquidGlassInputDialog(
        title: title,
        message: message,
        initialText: initialText,
        placeholder: placeholder,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: (text) => Navigator.of(ctx).pop(text),
        onCancel: () => Navigator.of(ctx).pop(),
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

class LiquidGlassInputDialogDemo extends StatefulWidget {
  const LiquidGlassInputDialogDemo({super.key});

  @override
  State<LiquidGlassInputDialogDemo> createState() =>
      _LiquidGlassInputDialogDemoState();
}

class _LiquidGlassInputDialogDemoState
    extends State<LiquidGlassInputDialogDemo> {
  String _chatName = 'Project Alpha';

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : CupertinoColors.label;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Input Dialog Action'),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Name:',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(color: CupertinoColors.secondaryLabel),
                ),
                const SizedBox(height: 8),
                Text(
                  _chatName,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle,
                ),
                const SizedBox(height: 48),
                // Trigger Button
                CNButton(
                  label: 'Rename Chat',
                  style: CNButtonStyle.glass,
                  onPressed: () async {
                    final newName = await _showLiquidGlassInputDialog(
                      context,
                      title: 'Rename Conversation',
                      initialText: _chatName,
                      placeholder: 'Conversation name',
                      confirmButtonText: 'Rename',
                    );

                    if (newName != null && newName.isNotEmpty) {
                      setState(() {
                        _chatName = newName;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
