import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A text field with a liquid glass effect background.
///
/// This widget combines [CNGlassEffectContainer] and [CNInput] to create
/// a modern, translucent input field similar to those found in iOS system apps.
/// The trailing send button automatically appears when text is entered.
///
/// When [showPlaceholderIcon] is true, a placeholder icon (like a mic) shows
/// when the field is empty, then transforms into the send button when text
/// is entered.
///
/// For voice input, users can use iOS's native keyboard dictation by tapping
/// the microphone button on the iOS keyboard. This is handled entirely by iOS
/// and requires no additional setup.
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
    this.showPlaceholderIcon = false,
    this.placeholderIconName = 'mic',
    this.placeholderIconColor,
    this.onPlaceholderIconPressed,
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

  /// Whether to show a placeholder icon when the field is empty.
  /// When true, shows [placeholderIconName] when empty, send button when has text.
  final bool showPlaceholderIcon;

  /// SF Symbol name for the placeholder icon. Defaults to "mic".
  final String placeholderIconName;

  /// Color for the placeholder icon.
  final Color? placeholderIconColor;

  /// Callback when the placeholder icon is pressed.
  final VoidCallback? onPlaceholderIconPressed;

  @override
  State<LiquidGlassTextField> createState() => LiquidGlassTextFieldState();
}

/// State for [LiquidGlassTextField].
class LiquidGlassTextFieldState extends State<LiquidGlassTextField> {
  double _currentHeight = 50.0;
  final GlobalKey<CNInputState> _inputKey = GlobalKey<CNInputState>();
  late TextEditingController _controller;

  // Check text directly from controller for reliability
  bool get _hasText => _controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.minHeight;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant LiquidGlassTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      _controller = widget.controller ?? _controller;
      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    // Just trigger a rebuild - we read from controller directly
    if (mounted) {
      setState(() {});
    }
  }

  double _calculateMaxHeight() {
    const lineHeight = 17.0 * 1.2;
    const verticalPadding = 28.0;
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
    final text = _controller.text;
    if (text.isNotEmpty) {
      widget.onSubmitted?.call(text);
      _controller.clear();
      setState(() {
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
    
    // Show trailing button if: has text OR showPlaceholderIcon is enabled
    final showTrailingButton = _hasText || widget.showPlaceholderIcon;

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
                  right: showTrailingButton ? 4.0 : 16.0,
                ),
                child: CNInput(
                  key: _inputKey,
                  controller: _controller,
                  placeholder: widget.placeholder,
                  backgroundColor: CupertinoColors.transparent,
                  borderStyle: CNInputBorderStyle.none,
                  minHeight: widget.minHeight,
                  onSubmitted: (_) => _handleSubmit(),
                  onChanged: (text) {
                    widget.onChanged?.call(text);
                    // Controller listener will trigger rebuild
                  },
                  onFocusChanged: widget.onFocusChanged,
                  maxLines: widget.maxLines,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onHeightChanged: (height) {
                    if (mounted) {
                      setState(() {
                        _currentHeight =
                            height.clamp(widget.minHeight, _calculateMaxHeight());
                      });
                    }
                  },
                ),
              ),
            ),
            // Trailing Button - Send when has text, placeholder when empty
            if (showTrailingButton) ...[
              Padding(
                padding: EdgeInsets.only(
                  right: 8.0,
                  bottom: _currentHeight > widget.minHeight ? 8.0 : 0.0,
                ),
                child: _hasText
                    // Send button when there's text
                    ? CNButton.icon(
                        icon: CNSymbol(
                          effectiveIconName,
                          size: 16,
                          color: effectiveIconInnerColor,
                        ),
                        size: 32,
                        style: CNButtonStyle.prominentGlass,
                        tint: effectiveTrailingColor,
                        onPressed: _handleSubmit,
                      )
                    // Placeholder icon when empty
                    : CNButton.icon(
                        icon: CNSymbol(
                          widget.placeholderIconName,
                          size: 16,
                          color: widget.placeholderIconColor,
                        ),
                        size: 32,
                        style: CNButtonStyle.glass,
                        tint: widget.tint,
                        onPressed: widget.onPlaceholderIconPressed,
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
