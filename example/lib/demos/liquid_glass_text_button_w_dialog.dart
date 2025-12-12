import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

class LiquidGlassTextButtonWDialogDemoPage extends StatefulWidget {
  const LiquidGlassTextButtonWDialogDemoPage({super.key});

  @override
  State<LiquidGlassTextButtonWDialogDemoPage> createState() =>
      _LiquidGlassTextButtonWDialogDemoPageState();
}

class _LiquidGlassTextButtonWDialogDemoPageState
    extends State<LiquidGlassTextButtonWDialogDemoPage> {
  String _status = 'Ready';
  int _clickCount = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Button with Dialog'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const Text(
              'FlutterFlow-Compatible Glass Button with Dialog',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'A glass button that shows a liquid glass dialog when pressed. Dialog design matches the Input Dialog Action demo. Cancel button automatically closes the dialog.',
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 32),

            // Status display
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _status,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dialog opened: $_clickCount times',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Demo buttons
            const Text(
              'Examples:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Simple info dialog
            const Text('Info Dialog:', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            _LiquidGlassButtonWDialog(
              buttonText: 'Show Info',
              buttonTextColor: CupertinoColors.activeBlue,
              dialogTitle: 'Information',
              dialogMessage:
                  'This is a simple information dialog with liquid glass effect.',
              cancelButtonText: 'Dismiss',
              confirmButtonText: 'Got it',
              onConfirm: () {
                setState(() {
                  _status = 'Info dialog confirmed';
                  _clickCount++;
                });
              },
            ),
            const SizedBox(height: 24),

            // Success message
            const Text('Success Message:', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            _LiquidGlassButtonWDialog(
              buttonText: 'Complete Action',
              buttonTextColor: CupertinoColors.systemGreen,
              dialogTitle: 'Success!',
              dialogMessage:
                  'Your action has been completed successfully. All changes have been saved.',
              cancelButtonText: 'Close',
              confirmButtonText: 'Awesome',
              onConfirm: () {
                setState(() {
                  _status = 'Success confirmed';
                  _clickCount++;
                });
              },
            ),
            const SizedBox(height: 24),

            // Warning
            const Text('Warning Dialog:', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            _LiquidGlassButtonWDialog(
              buttonText: 'Show Warning',
              buttonTextColor: CupertinoColors.systemOrange,
              dialogTitle: 'Warning',
              dialogMessage:
                  'This action requires your attention. Please make sure you understand the implications before proceeding.',
              cancelButtonText: 'Cancel',
              confirmButtonText: 'Proceed',
              onConfirm: () {
                setState(() {
                  _status = 'Warning acknowledged';
                  _clickCount++;
                });
              },
            ),
            const SizedBox(height: 24),

            // Error
            const Text('Error Message:', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            _LiquidGlassButtonWDialog(
              buttonText: 'Show Error',
              buttonTextColor: CupertinoColors.systemRed,
              dialogTitle: 'Error',
              dialogMessage:
                  'An error occurred while processing your request. Please try again later.',
              cancelButtonText: 'Cancel',
              confirmButtonText: 'Retry',
              onConfirm: () {
                setState(() {
                  _status = 'Error retry attempted';
                  _clickCount++;
                });
              },
            ),
            const SizedBox(height: 24),

            // Long message
            const Text('Long Message:', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            _LiquidGlassButtonWDialog(
              buttonText: 'Show Details',
              buttonTextColor: CupertinoColors.systemPurple,
              dialogTitle: 'Privacy Notice',
              dialogMessage:
                  'This app collects data to improve your experience. Your information is encrypted and stored securely. We never share your data with third parties without your consent.',
              cancelButtonText: 'Decline',
              confirmButtonText: 'Accept',
              onConfirm: () {
                setState(() {
                  _status = 'Privacy accepted';
                  _clickCount++;
                });
              },
            ),
            const SizedBox(height: 32),
            Container(
              height: 1,
              color: CupertinoColors.separator,
            ),
            const SizedBox(height: 24),

            // Features list
            const Text(
              'Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Native iOS liquid glass dialog',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Matches Input Dialog Action demo design',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Displays custom message text',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Customizable button text color',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Cancel button auto-closes dialog',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Smooth scale & fade animation',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'FlutterFlow compatible with async callbacks',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Customizable button texts',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Confirm action with async callback',
            ),
          ],
        ),
      ),
    );
  }
}

// Internal widget that wraps the button + dialog functionality
class _LiquidGlassButtonWDialog extends StatelessWidget {
  const _LiquidGlassButtonWDialog({
    required this.buttonText,
    this.buttonTextColor,
    required this.dialogTitle,
    required this.dialogMessage,
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.onConfirm,
  });

  final String buttonText;
  final Color? buttonTextColor;
  final String dialogTitle;
  final String dialogMessage;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback onConfirm;

  Future<void> _showDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: CupertinoColors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return _LiquidGlassMessageDialog(
          title: dialogTitle,
          message: dialogMessage,
          cancelButtonText: cancelButtonText,
          confirmButtonText: confirmButtonText,
          onCancel: () {
            Navigator.of(ctx).pop();
          },
          onConfirm: () {
            Navigator.of(ctx).pop();
            onConfirm();
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
    return CNButton(
      label: buttonText,
      style: CNButtonStyle.glass,
      tint: buttonTextColor,
      onPressed: () => _showDialog(context),
      shrinkWrap: true,
    );
  }
}

// Dialog widget matching the liquid glass input dialog design
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
    final textColor = isDark ? CupertinoColors.white : CupertinoColors.black;
    final secondaryTextColor = isDark
        ? CupertinoColors.white.withValues(alpha: 0.6)
        : CupertinoColors.black.withValues(alpha: 0.6);
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

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: CupertinoColors.activeGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

