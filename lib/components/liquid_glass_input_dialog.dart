import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A liquid glass input dialog matching the native iOS rename dialog.
///
/// The container uses liquid glass effect, while the text field and buttons
/// are native Cupertino widgets matching the iOS system dialog appearance.
class LiquidGlassInputDialog extends StatefulWidget {
  const LiquidGlassInputDialog({
    super.key,
    required this.title,
    this.message,
    this.initialText,
    this.placeholder = 'Conversation name',
    this.confirmButtonText = 'Rename',
    this.cancelButtonText = 'Cancel',
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String? message;
  final String? initialText;
  final String placeholder;
  final String confirmButtonText;
  final String cancelButtonText;
  final ValueChanged<String>? onConfirm;
  final VoidCallback? onCancel;

  @override
  State<LiquidGlassInputDialog> createState() => _LiquidGlassInputDialogState();
}

class _LiquidGlassInputDialogState extends State<LiquidGlassInputDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    
    // Text Colors - matching iOS native
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark 
        ? Colors.white.withOpacity(0.6) 
        : Colors.black.withOpacity(0.6);
    
    // Input Field - darker than dialog background
    final inputBackgroundColor = isDark
        ? const Color(0xFF2C2C2E)
        : const Color(0xFFE5E5EA);
    final placeholderColor = isDark
        ? Colors.white.withOpacity(0.35)
        : Colors.black.withOpacity(0.35);
    
    // Button background - native iOS dialog button style
    final buttonBackgroundColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE8E8ED);

    // CRITICAL: Wrap the entire dialog in RepaintBoundary to create a separate
    // compositing layer. This prevents native platform views from interfering
    // with Flutter's text rendering in stacked overlay scenarios.
    return RepaintBoundary(
      child: Align(
        alignment: const Alignment(0, -0.4), // Position dialog higher above keyboard
        child: Container(
          width: 300,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              // Liquid Glass Background - only the container uses glass effect
              // The native view is isolated in its own compositing layer
              Positioned.fill(
                child: RepaintBoundary(
                  child: CNGlassEffectContainer(
                    glassStyle: CNGlassStyle.regular,
                    cornerRadius: 20,
                    interactive: false,
                    child: const SizedBox(),
                  ),
                ),
              ),
            // Content - native Cupertino widgets
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      decoration: TextDecoration.none,
                      letterSpacing: -0.4,
                    ),
                  ),
                  if (widget.message != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.message!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: secondaryTextColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Native Cupertino Text Field
                  CupertinoTextField(
                    controller: _controller,
                    placeholder: widget.placeholder,
                    placeholderStyle: TextStyle(
                      color: placeholderColor,
                      fontSize: 17,
                    ),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: inputBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    cursorColor: CupertinoColors.activeBlue,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  // Native Cupertino Action Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => widget.onCancel?.call(),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: buttonBackgroundColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              widget.cancelButtonText,
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
                          onPressed: () => widget.onConfirm?.call(_controller.text),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: buttonBackgroundColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              widget.confirmButtonText,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
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
      ),
    );
  }
}

