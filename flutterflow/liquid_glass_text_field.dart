// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Required package import - add cupertino_native to your pubspec.yaml:
// dependencies:
//   cupertino_native: ^latest_version
import 'package:cupertino_native/cupertino_native.dart';

/// A liquid glass text field widget for FlutterFlow.
///
/// This widget creates a modern, translucent input field with native iOS
/// liquid glass effect, similar to the iMessage input field.
///
/// ## Setup Instructions:
/// 1. Add `cupertino_native` package to your pubspec.yaml
/// 2. Copy this file to your FlutterFlow custom widgets
/// 3. Configure the parameters in FlutterFlow
///
/// ## Parameters:
/// - [width]: Required width of the widget
/// - [height]: Required minimum height of the widget
/// - [placeholder]: Placeholder text when empty
/// - [isDarkMode]: Toggle between dark and light mode
/// - [trailingIconColor]: Color of the send button
/// - [onTrailingPressed]: Action when send button is pressed
/// - [onTextChanged]: Action when text changes
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
    const verticalPadding = 28.0; // 14 top + 14 bottom
    return lineHeight * widget.maxLines + verticalPadding;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCornerRadius = widget.cornerRadius ?? widget.height / 2;
    final effectiveTrailingColor =
        widget.trailingIconColor ?? CupertinoColors.activeBlue;

    return Theme(
      data: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: _currentHeight.clamp(widget.height, _calculateMaxHeight()),
          width: widget.width,
          child: CNGlassEffectContainer(
            height: _currentHeight.clamp(widget.height, _calculateMaxHeight()),
            width: widget.width,
            glassStyle: CNGlassStyle.regular,
            cornerRadius: effectiveCornerRadius,
            child: Row(
              crossAxisAlignment: _currentHeight > widget.height
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.center,
              children: [
                // Text Input
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 4.0,
                      bottom: _currentHeight > widget.height ? 8.0 : 0.0,
                    ),
                    child: CNInput(
                      controller: _controller,
                      placeholder: widget.placeholder,
                      backgroundColor: CupertinoColors.transparent,
                      borderStyle: CNInputBorderStyle.none,
                      minHeight: widget.height,
                      textColor: widget.isDarkMode
                          ? CupertinoColors.white
                          : CupertinoColors.black,
                      maxLines: widget.maxLines,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (text) {
                        widget.onTextChanged?.call(text);
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
                // Trailing Send Button
                Padding(
                  padding: EdgeInsets.only(
                    right: 8.0,
                    bottom: _currentHeight > widget.height ? 8.0 : 0.0,
                  ),
                  child: CNButton.icon(
                    icon: CNSymbol(
                      'arrow.up',
                      size: 16,
                      color: CupertinoColors.white,
                    ),
                    size: 32,
                    style: CNButtonStyle.prominentGlass,
                    tint: effectiveTrailingColor,
                    onPressed: () {
                      widget.onTrailingPressed?.call();
                    },
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

