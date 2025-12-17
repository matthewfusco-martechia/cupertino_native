import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For colored icons if needed, but Cupertino is preferred for iOS style
import 'package:cupertino_native/cupertino_native.dart';

class LiquidGlassSearchTextField extends StatefulWidget {
  const LiquidGlassSearchTextField({
    super.key,
    this.width,
    this.height,
    this.placeholder = 'Search',
    this.isDarkMode = false,
    this.onSubmitted,
    this.onChanged,
    this.onFocusChanged,
    this.onCancel,
    this.initialText,
    this.clearOnSubmit = true,
  });

  /// The width of the widget.
  final double? width;

  /// The height of the widget.
  final double? height;

  /// Placeholder text.
  final String placeholder;

  /// Dark mode toggle.
  final bool isDarkMode;

  /// Callback when search is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when focus changes.
  final ValueChanged<bool>? onFocusChanged;

  /// Callback when cancel button is pressed.
  final VoidCallback? onCancel;

  /// Initial text value.
  final String? initialText;

  /// Whether to clear text after submission.
  final bool clearOnSubmit;

  @override
  State<LiquidGlassSearchTextField> createState() =>
      _LiquidGlassSearchTextFieldState();
}

class _LiquidGlassSearchTextFieldState
    extends State<LiquidGlassSearchTextField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _showClearButton = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClearButton != hasText) {
      setState(() {
        _showClearButton = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    widget.onFocusChanged?.call(_focusNode.hasFocus);
  }

  void _onSubmit(String text) {
    if (text.isNotEmpty) {
      widget.onSubmitted?.call(text);
      if (widget.clearOnSubmit) {
        _controller.clear();
      }
    }
    Future.microtask(() => _focusNode.unfocus());
  }

  void _onClear() {
    _controller.clear();
  }

  void _onCancel() {
    _controller.clear();
    Future.microtask(() => _focusNode.unfocus());
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    // We use null tint to allow the native liquid glass blur to fully show through
    // without being muddied by an opacity layer.
    final Color? backgroundColor = null; 

    // Adjust icon/text colors for contrast
    final iconColor = widget.isDarkMode
        ? CupertinoColors.systemGrey.withOpacity(0.8)
        : CupertinoColors.systemGrey;

    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final placeholderColor = widget.isDarkMode
        ? CupertinoColors.systemGrey
        : CupertinoColors.systemGrey;
    
    final cursorColor = CupertinoColors.activeBlue;
    
    // Default height 45.0 as requested
    final height = widget.height ?? 45.0;

    return SizedBox(
      width: widget.width,
      height: height,
      child: Row(
        children: [
          // The Search Pill
          Expanded(
            child: Stack(
              children: [
                // Native Glass Background
                Positioned.fill(
                  child: CNGlassEffectContainer(
                    glassStyle: CNGlassStyle.regular,
                    tint: backgroundColor, 
                    cornerRadius: height / 2,
                    child: const SizedBox(),
                  ),
                ),
                // Input Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // More padding
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        color: iconColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Center(
                          child: CupertinoTextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            decoration: null, // Remove default border
                            placeholder: widget.placeholder,
                            placeholderStyle: TextStyle(
                              color: placeholderColor,
                              fontSize: 17,
                            ),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 17,
                              height: 1.2,
                            ),
                            cursorColor: cursorColor,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            keyboardAppearance: widget.isDarkMode
                                ? Brightness.dark
                                : Brightness.light,
                            onSubmitted: _onSubmit,
                            // Ensure centering
                             padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      // Inline Clear Button (visible when text exists)
                      if (_showClearButton)
                        GestureDetector(
                          onTap: _onClear,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              CupertinoIcons.xmark_circle_fill,
                              color: widget.isDarkMode ? Colors.white : Colors.black, // High visibility
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Trailing Action Button (visible when focused or has text)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutQuart,
            child: SizedBox(
               width: (_isFocused || _showClearButton) ? height + 12.0 : 0.0,
              child: OverflowBox(
                minWidth: 0.0,
                maxWidth: height + 12.0,
                alignment: Alignment.centerRight,
                child: Opacity(
                  opacity: (_isFocused || _showClearButton) ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: GestureDetector(
                      onTap: _onCancel,
                      child: SizedBox(
                        width: height,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: CNGlassEffectContainer(
                                glassStyle: CNGlassStyle.regular,
                                tint: backgroundColor,
                                cornerRadius: height / 2,
                                child: const SizedBox(),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.xmark,
                              size: 18,
                              color: widget.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
