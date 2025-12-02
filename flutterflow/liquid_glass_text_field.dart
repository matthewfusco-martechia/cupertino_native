// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ============================================================================
// IMPORTANT: You MUST add the cupertino_native package to your FlutterFlow project!
// 
// In FlutterFlow:
// 1. Go to Settings (gear icon) > Project Dependencies
// 2. Click "Add Dependency"
// 3. Select "Git" source
// 4. URL: https://github.com/matthewfusco-martechia/cupertino_native.git
// 5. Ref: main
// 6. Click "Add" and wait for rebuild
//
// Without this package, the widget will NOT compile!
//
// TO DISMISS KEYBOARD WHEN TAPPING OUTSIDE:
// Wrap your page's main content with GestureDetector:
//   GestureDetector(
//     onTap: () => FocusScope.of(context).unfocus(),
//     child: YourPageContent(),
//   )
// ============================================================================
import 'package:cupertino_native/cupertino_native.dart';

/// A liquid glass text field widget for FlutterFlow.
///
/// This widget creates a modern, translucent input field with native iOS
/// liquid glass effect, similar to the iMessage input field.
///
/// ## Parameters:
/// - [width]: Required width of the widget
/// - [height]: Required minimum height of the widget
/// - [placeholder]: Placeholder text when empty
/// - [isDarkMode]: Toggle between dark and light mode
/// - [trailingIconColor]: Color of the send button
/// - [onTrailingPressed]: Action when send button is pressed
/// - [onTextChanged]: Action when text changes
/// - [onFocusChanged]: Action when focus changes
class LiquidGlassTextField extends StatefulWidget {
  const LiquidGlassTextField({
    super.key,
    required this.width,
    required this.height,
    this.placeholder = 'Message',
    this.isDarkMode = false,
    this.trailingIconColor,
    this.onTrailingPressed,
    this.onTextChanged,
    this.onFocusChanged,
    this.maxLines = 10,
    this.cornerRadius,
  });

  /// The width of the widget (required by FlutterFlow).
  final double width;

  /// The minimum height of the widget (required by FlutterFlow).
  final double height;

  /// Placeholder text displayed when the field is empty.
  final String placeholder;

  /// Whether to use dark mode styling.
  final bool isDarkMode;

  /// The color of the trailing send button icon.
  final Color? trailingIconColor;

  /// Action to perform when the trailing send button is pressed.
  final Future<dynamic> Function()? onTrailingPressed;

  /// Action to perform when the text changes.
  final Future<dynamic> Function(String text)? onTextChanged;

  /// Action to perform when focus changes.
  final Future<dynamic> Function(bool focused)? onFocusChanged;

  /// Maximum number of lines before scrolling.
  final int maxLines;

  /// Corner radius for the glass container. Defaults to height / 2 (pill shape).
  final double? cornerRadius;

  @override
  State<LiquidGlassTextField> createState() => _LiquidGlassTextFieldState();
}

class _LiquidGlassTextFieldState extends State<LiquidGlassTextField> {
  final TextEditingController _controller = TextEditingController();
  double _currentHeight = 50.0;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.height;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateMaxHeight() {
    const lineHeight = 17.0 * 1.2; // fontSize * line height multiplier
    const verticalPadding = 20.0; // 8 top + 8 bottom + 4 buffer for text rendering
    return lineHeight * widget.maxLines + verticalPadding;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCornerRadius = widget.cornerRadius ?? widget.height / 2;
    final effectiveTrailingColor =
        widget.trailingIconColor ?? const Color(0xFF007AFF); // iOS blue

    final currentHeight = _currentHeight.clamp(widget.height, _calculateMaxHeight());
    
    return Theme(
      data: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: SizedBox(
          height: currentHeight,
          width: widget.width,
          child: CNGlassEffectContainer(
            height: currentHeight,
            width: widget.width,
            glassStyle: CNGlassStyle.regular,
            cornerRadius: effectiveCornerRadius,
            child: Row(
              // Always stretch to fill, let each child manage its own alignment
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text Input - fills the available space
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                    child: CNInput(
                      controller: _controller,
                      placeholder: widget.placeholder,
                      backgroundColor: const Color(0x00000000), // transparent
                      borderStyle: CNInputBorderStyle.none,
                      minHeight: widget.height - 8, // Slight reduction for container padding
                      textColor: widget.isDarkMode
                          ? const Color(0xFFFFFFFF) // white
                          : const Color(0xFF000000), // black
                      maxLines: widget.maxLines,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (text) {
                        widget.onTextChanged?.call(text);
                      },
                      onFocusChanged: (focused) {
                        widget.onFocusChanged?.call(focused);
                      },
                      onHeightChanged: (height) {
                        if (mounted) {
                          setState(() {
                            _currentHeight = height.clamp(
                              widget.height,
                              _calculateMaxHeight(),
                            );
                          });
                        }
                      },
                    ),
                  ),
                ),
                // Trailing Send Button - aligned to bottom when multiline, center otherwise
                Align(
                  alignment: currentHeight > widget.height 
                      ? Alignment.bottomCenter 
                      : Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 8.0,
                      bottom: currentHeight > widget.height ? 8.0 : 0.0,
                    ),
                    child: CNButton.icon(
                      icon: const CNSymbol(
                        'arrow.up',
                        size: 16,
                        color: Color(0xFFFFFFFF), // white
                      ),
                      size: 32,
                      style: CNButtonStyle.prominentGlass,
                      tint: effectiveTrailingColor,
                      onPressed: () {
                        widget.onTrailingPressed?.call();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get the current text value.
  String get text => _controller.text;

  /// Set the text value programmatically.
  set text(String value) {
    _controller.text = value;
  }

  /// Clear the text field.
  void clear() {
    _controller.clear();
  }
}
