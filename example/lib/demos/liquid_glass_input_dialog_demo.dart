import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

// Message Dialog Action (mimics the custom action)
Future<bool> _showLiquidGlassMessageDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmButtonText = 'OK',
  String cancelButtonText = 'Cancel',
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
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
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
  return result ?? false;
}

// Input Dialog Action (mimics the custom action)
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
  String _lastAction = 'None';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Dialogs'),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Current Name Display
                Text(
                  'Chat Name:',
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
                const SizedBox(height: 32),
                
                // Input Dialog Button
                CNButton(
                  label: 'Input Dialog (Rename)',
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
                        _lastAction = 'Renamed to: $newName';
                      });
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Message Dialog Button
                CNButton(
                  label: 'Message Dialog (Delete)',
                  style: CNButtonStyle.glass,
                  tint: CupertinoColors.systemRed.withOpacity(0.2),
                  onPressed: () async {
                    final confirmed = await _showLiquidGlassMessageDialog(
                      context,
                      title: 'Delete Conversation?',
                      message: 'This action cannot be undone. All messages in "$_chatName" will be permanently deleted.',
                      confirmButtonText: 'Delete',
                      cancelButtonText: 'Cancel',
                    );

                    setState(() {
                      _lastAction = confirmed ? 'User confirmed delete' : 'User cancelled';
                    });
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Last Action Display
                Text(
                  'Last Action:',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(color: CupertinoColors.secondaryLabel),
                ),
                const SizedBox(height: 4),
                Text(
                  _lastAction,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Message Dialog Widget (matching the custom action design)
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

    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor =
        isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6);
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
