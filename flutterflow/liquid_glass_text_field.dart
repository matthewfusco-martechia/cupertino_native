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
// FOR VOICE INPUT (iOS/macOS):
// Add these to Settings > App Settings > iOS > Info.plist Additions:
//   <key>NSMicrophoneUsageDescription</key>
//   <string>This app needs microphone access for voice input.</string>
//   <key>NSSpeechRecognitionUsageDescription</key>
//   <string>This app needs speech recognition to transcribe your voice.</string>
// ============================================================================
import 'package:cupertino_native/cupertino_native.dart' as cn;

/// A liquid glass text field widget for FlutterFlow with voice input support.
///
/// The trailing send button automatically appears when text is entered
/// and disappears when the field is empty. When voice input is enabled,
/// a mic button appears when the field is empty.
///
/// ## Parameters:
/// - [width]: Required width of the widget
/// - [height]: Required minimum height of the widget
/// - [placeholder]: Placeholder text when empty
/// - [isDarkMode]: Toggle between dark and light mode
/// - [trailingIconColor]: Tint/background color of the send button
/// - [trailingIconInnerColor]: Color of the icon symbol itself
/// - [trailingIconName]: SF Symbol name (default: "arrow.up")
/// - [enableVoiceInput]: Enable voice recording with speech-to-text
/// - [micIconName]: Microphone icon SF Symbol name (default: "mic")
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
    this.enableVoiceInput = false,
    this.micIconName,
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

  /// Enable voice input with speech-to-text transcription.
  final bool enableVoiceInput;

  /// Microphone icon SF Symbol name. Defaults to "mic".
  /// Examples: "mic.fill", "waveform"
  final String? micIconName;

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
  final GlobalKey<cn.LiquidGlassTextFieldState> _fieldKey = GlobalKey<cn.LiquidGlassTextFieldState>();
  String _currentText = '';

  @override
  void initState() {
    super.initState();
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

  void _handleSubmit(String text) {
    if (text.isNotEmpty) {
      widget.onSubmit?.call(text);
      
      if (widget.clearOnSubmit) {
        _controller.clear();
        setState(() {
          _currentText = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTrailingColor =
        widget.trailingIconColor ?? const Color(0xFF007AFF);
    final effectiveIconInnerColor =
        widget.trailingIconInnerColor ?? const Color(0xFFFFFFFF);
    final effectiveIconName = widget.trailingIconName ?? 'arrow.up';
    final effectiveMicIconName = widget.micIconName ?? 'mic';
    
    return Theme(
      data: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: SizedBox(
          width: widget.width,
          child: cn.LiquidGlassTextField(
            key: _fieldKey,
            controller: _controller,
            placeholder: widget.placeholder,
            minHeight: widget.height,
            width: widget.width,
            maxLines: widget.maxLines,
            cornerRadius: widget.cornerRadius,
            trailingIconColor: effectiveTrailingColor,
            trailingIconInnerColor: effectiveIconInnerColor,
            trailingIconName: effectiveIconName,
            enableVoiceInput: widget.enableVoiceInput,
            micIconName: effectiveMicIconName,
            onSubmitted: _handleSubmit,
            onChanged: (text) {
              setState(() {
                _currentText = text;
              });
              widget.onTextChanged?.call(text);
            },
            onFocusChanged: (focused) {
              widget.onFocusChanged?.call(focused);
            },
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
