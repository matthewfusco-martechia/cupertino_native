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
//
// HOW TO USE onSubmit TO ADD TEXT TO PAGE STATE:
// 1. In FlutterFlow, select this widget
// 2. Go to Actions > onSubmit
// 3. Add action: "Update Page State"
// 4. Select your page state variable (e.g., messages list)
// 5. Use "Action Output" or the callback parameter to get the submitted text
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
/// - [onSubmit]: Action when send button is pressed - receives the text value!
/// - [onTextChanged]: Action when text changes
/// - [onFocusChanged]: Action when focus changes
/// - [clearOnSubmit]: Whether to clear the text field after submit (default: true)
class LiquidGlassTextField extends StatefulWidget {
  const LiquidGlassTextField({
    super.key,
    required this.width,
    required this.height,
    this.placeholder = 'Message',
    this.isDarkMode = false,
    this.trailingIconColor,
    this.onSubmit,
    this.onTextChanged,
    this.onFocusChanged,
    this.maxLines = 10,
    this.cornerRadius,
    this.clearOnSubmit = true,
    this.initialText,
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

  /// Action to perform when the send button is pressed.
  /// Receives the current text value as a parameter.
  /// Use this to append the text to your page state!
  final Future<dynamic> Function(String text)? onSubmit;

  /// Action to perform when the text changes.
  final Future<dynamic> Function(String text)? onTextChanged;

  /// Action to perform when focus changes.
  final Future<dynamic> Function(bool focused)? onFocusChanged;

  /// Maximum number of lines before scrolling.
  final int maxLines;

  /// Corner radius for the glass container. Defaults to height / 2 (pill shape).
  final double? cornerRadius;

  /// Whether to clear the text field after submit. Defaults to true.
  final bool clearOnSubmit;

  /// Initial text to prefill the text field.
  /// Bind this to a page state variable to control the text from outside.
  /// When this value changes, the text field will update.
  final String? initialText;

  @override
  State<LiquidGlassTextField> createState() => _LiquidGlassTextFieldState();
}

class _LiquidGlassTextFieldState extends State<LiquidGlassTextField> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<CNInputState> _inputKey = GlobalKey<CNInputState>();
  double _currentHeight = 50.0;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.height;
    // Set initial text if provided
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _controller.text = widget.initialText!;
      _currentText = widget.initialText!;
    }
  }

  @override
  void didUpdateWidget(covariant LiquidGlassTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update text when initialText changes from outside
    if (widget.initialText != oldWidget.initialText && 
        widget.initialText != null &&
        widget.initialText != _currentText) {
      _controller.text = widget.initialText!;
      _currentText = widget.initialText!;
    }
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

  void _handleSubmit() {
    final text = _currentText;
    if (text.isNotEmpty) {
      // Call the onSubmit callback with the text
      widget.onSubmit?.call(text);
      
      // Clear the text field if clearOnSubmit is true
      if (widget.clearOnSubmit) {
        _controller.clear();
        setState(() {
          _currentText = '';
          _currentHeight = widget.height;
        });
      }
      
      // Dismiss keyboard after submit - call native unfocus
      _inputKey.currentState?.unfocus();
    }
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
            interactive: true,
            child: Row(
              // Always stretch to fill, let each child manage its own alignment
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text Input - fills the available space
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                    child: CNInput(
                      key: _inputKey,
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
                        _currentText = text;
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
                      onPressed: _handleSubmit,
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
  String get text => _currentText;

  /// Set the text value programmatically.
  set text(String value) {
    _controller.text = value;
    _currentText = value;
  }

  /// Clear the text field.
  void clear() {
    _controller.clear();
    _currentText = '';
  }
}
