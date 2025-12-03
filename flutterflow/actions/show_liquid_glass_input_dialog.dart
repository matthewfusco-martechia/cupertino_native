// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// Shows a custom Liquid Glass dialog with a text input field.
///
/// Returns the text entered by the user, or null if cancelled.
Future<String?> showLiquidGlassInputDialog(
  BuildContext context, {
  required String title,
  String? message,
  String? initialText,
  String placeholder = 'Conversation name',
  String confirmButtonText = 'Rename',
  String cancelButtonText = 'Cancel',
  bool isDarkMode = false,
}) async {
  final TextEditingController controller =
      TextEditingController(text: initialText);

  // Colors based on dark mode
  final backgroundColor = isDarkMode
      ? const Color(0xFF1C1C1E).withOpacity(0.75)
      : const Color(0xFFF2F2F7).withOpacity(0.85);
  final textColor = isDarkMode ? Colors.white : Colors.black;
  final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;
  final inputBackgroundColor = isDarkMode
      ? const Color(0xFF3A3A3C).withOpacity(0.5)
      : const Color(0xFFE5E5EA).withOpacity(0.8);
  final placeholderColor = isDarkMode
      ? Colors.white.withOpacity(0.3)
      : Colors.black.withOpacity(0.3);
  final buttonPrimaryTint = isDarkMode
      ? const Color(0xFF3A3A3C).withOpacity(0.8)
      : const Color(0xFFD1D1D6).withOpacity(0.8);
  final buttonSecondaryTint = isDarkMode
      ? const Color(0xFF2C2C2E).withOpacity(0.5)
      : const Color(0xFFE5E5EA).withOpacity(0.6);

  return showGeneralDialog<String>(
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
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: 300,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  children: [
                    // Glass Background
                    Positioned.fill(
                      child: CNGlassEffectContainer(
                        glassStyle: CNGlassStyle.regular,
                        cornerRadius: 24,
                        tint: backgroundColor,
                        interactive: true,
                        child: const SizedBox(),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              decoration: TextDecoration.none,
                              fontFamily: 'SF Pro Text',
                              letterSpacing: -0.4,
                            ),
                          ),
                          if (message != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: secondaryTextColor,
                                decoration: TextDecoration.none,
                                fontFamily: 'SF Pro Text',
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          // Custom Input Field
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: inputBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: CupertinoTextField(
                              controller: controller,
                              placeholder: placeholder,
                              placeholderStyle: TextStyle(
                                color: placeholderColor,
                                fontFamily: 'SF Pro Text',
                              ),
                              style: TextStyle(
                                color: textColor,
                                fontFamily: 'SF Pro Text',
                                fontSize: 17,
                              ),
                              decoration: null,
                              cursorColor: const Color(0xFF0A84FF),
                              autofocus: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _DialogButton(
                                  text: cancelButtonText,
                                  onPressed: () => Navigator.pop(ctx),
                                  isPrimary: false,
                                  isDarkMode: isDarkMode,
                                  tint: buttonSecondaryTint,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _DialogButton(
                                  text: confirmButtonText,
                                  onPressed: () =>
                                      Navigator.pop(ctx, controller.text),
                                  isPrimary: true,
                                  isDarkMode: isDarkMode,
                                  tint: buttonPrimaryTint,
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
            ),
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

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.text,
    required this.onPressed,
    required this.isPrimary,
    required this.isDarkMode,
    required this.tint,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDarkMode;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return SizedBox(
      height: 44,
      child: Stack(
        children: [
          Positioned.fill(
            child: CNGlassEffectContainer(
              cornerRadius: 14,
              glassStyle: CNGlassStyle.regular,
              tint: tint,
              interactive: true,
              onTap: onPressed,
              child: const SizedBox(),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
                  color: textColor,
                  decoration: TextDecoration.none,
                  fontFamily: 'SF Pro Text',
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
