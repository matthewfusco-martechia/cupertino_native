import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A text field with a liquid glass effect background.
///
/// This widget combines [CNGlassEffectContainer] and [CNInput] to create
/// a modern, translucent input field similar to those found in iOS system apps.
/// The trailing send button automatically appears when text is entered.
class LiquidGlassTextField extends StatefulWidget {
  /// Creates a liquid glass text field.
  const LiquidGlassTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.onSubmitted,
    this.onChanged,
    this.onFocusChanged,
    this.leading,
    this.minHeight = 50.0,
    this.width,
    this.glassStyle = CNGlassStyle.regular,
    this.tint,
    this.maxLines = 10,
    this.cornerRadius,
    this.trailingIconColor,
    this.trailingIconInnerColor,
    this.trailingIconName,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Text that appears when the field is empty.
  final String? placeholder;

  /// Called when the user submits the text (e.g. presses send button).
  final ValueChanged<String>? onSubmitted;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocusChanged;

  /// An optional widget to display before the input field.
  final Widget? leading;

  /// The minimum height of the text field.
  final double minHeight;

  /// The width of the text field.
  final double? width;

  /// The style of the glass effect.
  final CNGlassStyle glassStyle;

  /// Optional tint color for the glass effect.
  final Color? tint;

  /// The maximum number of lines to show at one time.
  final int maxLines;

  /// Corner radius for the glass container. Defaults to minHeight / 2 (pill shape).
  final double? cornerRadius;

  /// The tint/background color of the trailing send button.
  final Color? trailingIconColor;

  /// The color of the icon symbol itself (e.g., the arrow). Defaults to white.
  final Color? trailingIconInnerColor;

  /// SF Symbol name for the trailing icon. Defaults to "arrow.up".
  final String? trailingIconName;

  @override
  State<LiquidGlassTextField> createState() => LiquidGlassTextFieldState();
}

/// State for [LiquidGlassTextField].
class LiquidGlassTextFieldState extends State<LiquidGlassTextField> {
  double _currentHeight = 50.0;
  final GlobalKey<CNInputState> _inputKey = GlobalKey<CNInputState>();
  late TextEditingController _controller;
  String _currentText = '';

  // Show trailing icon only when there's text
  bool get _showTrailingIcon => _currentText.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.minHeight;
    _controller = widget.controller ?? TextEditingController();
    _currentText = _controller.text;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  double _calculateMaxHeight() {
    const lineHeight = 17.0 * 1.2; // fontSize * line height multiplier
    const verticalPadding = 28.0; // 14 top + 14 bottom
    return lineHeight * widget.maxLines + verticalPadding;
  }

  /// Unfocuses the text field, dismissing the keyboard.
  void unfocus() {
    _inputKey.currentState?.unfocus();
  }

  /// Focuses the text field, showing the keyboard.
  void focus() {
    _inputKey.currentState?.focus();
  }

  void _handleSubmit() {
    final text = _currentText;
    if (text.isNotEmpty) {
      widget.onSubmitted?.call(text);
      _controller.clear();
      setState(() {
        _currentText = '';
        _currentHeight = widget.minHeight;
      });
      _inputKey.currentState?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCornerRadius = widget.cornerRadius ?? widget.minHeight / 2;
    final effectiveTrailingColor =
        widget.trailingIconColor ?? CupertinoColors.activeBlue;
    final effectiveIconInnerColor =
        widget.trailingIconInnerColor ?? CupertinoColors.white;
    final effectiveIconName = widget.trailingIconName ?? 'arrow.up';
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: _currentHeight.clamp(widget.minHeight, _calculateMaxHeight()),
      width: widget.width ?? double.infinity,
      child: CNGlassEffectContainer(
        height: _currentHeight.clamp(widget.minHeight, _calculateMaxHeight()),
        width: widget.width ?? double.infinity,
        glassStyle: widget.glassStyle,
        tint: widget.tint,
        cornerRadius: effectiveCornerRadius,
        child: Row(
          crossAxisAlignment: _currentHeight > widget.minHeight 
              ? CrossAxisAlignment.end 
              : CrossAxisAlignment.center,
          children: [
            if (widget.leading != null) ...[
              Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                  bottom: _currentHeight > widget.minHeight ? 8.0 : 0.0,
                ),
                child: widget.leading!,
              ),
            ],
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.leading == null ? 16.0 : 4.0,
                  right: _showTrailingIcon ? 4.0 : 16.0,
                ),
                child: CNInput(
                  key: _inputKey,
                  controller: _controller,
                  placeholder: widget.placeholder,
                  // Use transparent background to show the glass effect underneath
                  backgroundColor: CupertinoColors.transparent,
                  borderStyle: CNInputBorderStyle.none,
                  minHeight: widget.minHeight,
                  onSubmitted: (_) => _handleSubmit(),
                  onChanged: (text) {
                    setState(() {
                      _currentText = text;
                    });
                    widget.onChanged?.call(text);
                  },
                  onFocusChanged: widget.onFocusChanged,
                  // Ensure text is visible on glass
                  textColor: CupertinoColors.label,
                  maxLines: widget.maxLines,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onHeightChanged: (height) {
                    if (mounted) {
                      setState(() {
                        _currentHeight = height.clamp(widget.minHeight, _calculateMaxHeight());
                      });
                    }
                  },
                ),
              ),
            ),
            // Trailing Send Button - only shown when text is not empty
            if (_showTrailingIcon) ...[
              Padding(
                padding: EdgeInsets.only(
                  right: 8.0,
                  bottom: _currentHeight > widget.minHeight ? 8.0 : 0.0,
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
            ],
          ],
        ),
      ),
    );
  }
}
