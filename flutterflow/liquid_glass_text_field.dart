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
// ============================================================================
import 'package:cupertino_native/cupertino_native.dart';

/// A liquid glass text field widget for FlutterFlow.
///
/// The trailing send button automatically appears when text is entered
/// and disappears when the field is empty.
///
/// ## Parameters:
/// - [width]: Required width of the widget
/// - [height]: Required minimum height of the widget
/// - [placeholder]: Placeholder text when empty
/// - [isDarkMode]: Toggle between dark and light mode
/// - [trailingIconColor]: Tint/background color of the send button
/// - [trailingIconInnerColor]: Color of the icon symbol itself
/// - [trailingIconName]: SF Symbol name (default: "arrow.up")
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
    this.trailingIconInnerColor,
    this.trailingIconName,
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

  /// The tint/background color of the trailing send button.
  final Color? trailingIconColor;

  /// The color of the icon symbol itself (e.g., the arrow). Defaults to white.
  final Color? trailingIconInnerColor;

  /// SF Symbol name for the trailing icon. Defaults to "arrow.up".
  /// Examples: "paperplane.fill", "checkmark", "plus", "arrow.right"
  final String? trailingIconName;

  /// Action to perform when the send button is pressed.
  /// Receives the current text value as a parameter.
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
  final String? initialText;

  @override
  State<LiquidGlassTextField> createState() => _LiquidGlassTextFieldState();
}

class _LiquidGlassTextFieldState extends State<LiquidGlassTextField> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<CNInputState> _inputKey = GlobalKey<CNInputState>();
  double _currentHeight = 50.0;
  String _currentText = '';

  // Show trailing icon only when there's text
  bool get _showTrailingIcon => _currentText.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.height;
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _controller.text = widget.initialText!;
      _currentText = widget.initialText!;
    }
  }

  @override
  void didUpdateWidget(covariant LiquidGlassTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    const lineHeight = 17.0 * 1.2;
    const verticalPadding = 20.0;
    return lineHeight * widget.maxLines + verticalPadding;
  }

  void _handleSubmit() {
    final text = _currentText;
    if (text.isNotEmpty) {
      widget.onSubmit?.call(text);
      
      if (widget.clearOnSubmit) {
        _controller.clear();
        setState(() {
          _currentText = '';
          _currentHeight = widget.height;
        });
      }
      
      _inputKey.currentState?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCornerRadius = widget.cornerRadius ?? widget.height / 2;
    final effectiveTrailingColor =
        widget.trailingIconColor ?? const Color(0xFF007AFF);
    final effectiveIconInnerColor =
        widget.trailingIconInnerColor ?? const Color(0xFFFFFFFF);
    final effectiveIconName = widget.trailingIconName ?? 'arrow.up';

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text Input
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12.0,
                      right: _showTrailingIcon ? 4.0 : 12.0,
                    ),
                    child: CNInput(
                      key: _inputKey,
                      controller: _controller,
                      placeholder: widget.placeholder,
                      backgroundColor: const Color(0x00000000),
                      borderStyle: CNInputBorderStyle.none,
                      minHeight: widget.height - 8,
                      textColor: widget.isDarkMode
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF000000),
                      maxLines: widget.maxLines,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (text) {
                        setState(() {
                        _currentText = text;
                        });
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
                // Trailing Send Button - only shown when text is not empty
                if (_showTrailingIcon)
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
                        icon: CNSymbol(
                          effectiveIconName,
                        size: 16,
                          color: effectiveIconInnerColor,
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

  String get text => _currentText;

  set text(String value) {
    _controller.text = value;
    _currentText = value;
  }

  void clear() {
    _controller.clear();
    _currentText = '';
  }
}
