import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

/// Recording states for voice input
enum _RecordingState {
  idle,
  recording,
  transcribing,
}

/// A text field with a liquid glass effect background.
///
/// This widget combines [CNGlassEffectContainer] and [CNInput] to create
/// a modern, translucent input field similar to those found in iOS system apps.
/// The trailing send button automatically appears when text is entered.
/// Supports voice recording with speech-to-text transcription.
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
    this.enableVoiceInput = false,
    this.micIconName = 'mic',
    this.micIconColor,
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

  /// Whether to enable voice input with speech-to-text.
  final bool enableVoiceInput;

  /// Microphone icon name.
  final String micIconName;

  /// Microphone icon color.
  final Color? micIconColor;

  @override
  State<LiquidGlassTextField> createState() => LiquidGlassTextFieldState();
}

/// State for [LiquidGlassTextField].
class LiquidGlassTextFieldState extends State<LiquidGlassTextField> {
  double _currentHeight = 50.0;
  final GlobalKey<CNInputState> _inputKey = GlobalKey<CNInputState>();
  late TextEditingController _controller;
  String _currentText = '';

  // Voice recording state
  _RecordingState _recordingState = _RecordingState.idle;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechInitialized = false;
  String _errorMessage = '';
  Timer? _errorTimer;
  bool _isProcessingRecording = false;

  // Show trailing icon only when there's text
  bool get _showTrailingIcon => _currentText.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.minHeight;
    _controller = widget.controller ?? TextEditingController();
    _currentText = _controller.text;
    
    if (widget.enableVoiceInput) {
      _initializeSpeech();
    }
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    if (_speechInitialized && _speech.isListening) {
      _speech.stop();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Initialize speech recognition
  Future<void> _initializeSpeech() async {
    try {
      _speechInitialized = await _speech.initialize(
        onError: (error) {
          if (mounted) {
            setState(() {
              _recordingState = _RecordingState.idle;
              _errorMessage = 'Speech error: ${error.errorMsg}';
              _isProcessingRecording = false;
            });
            _startErrorTimer();
          }
        },
        onStatus: (status) {
          if (status == 'notListening' && 
              _recordingState == _RecordingState.recording &&
              mounted) {
            _handleStopRecording();
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize speech recognition';
          _isProcessingRecording = false;
        });
        _startErrorTimer();
      }
    }
  }

  /// Start the error timer to clear error messages after 3 seconds
  void _startErrorTimer() {
    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = '';
        });
      }
    });
  }

  /// Show settings dialog when permission is permanently denied
  Future<void> _showPermissionDialog() async {
    if (!mounted) return;
    
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Microphone Access Required'),
        content: const Text(
          'To enable voice input, please allow microphone access in Settings.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  /// Handle starting voice recording
  Future<void> _handleStartRecording() async {
    if (_isProcessingRecording) return;
    _isProcessingRecording = true;

    if (!_speechInitialized) {
      setState(() {
        _errorMessage = 'Speech recognition not available';
        _isProcessingRecording = false;
      });
      _startErrorTimer();
      return;
    }

    try {
      // Check microphone permission status first
      final micStatus = await Permission.microphone.status;
      final speechStatus = await Permission.speech.status;
      
      // If permanently denied, show settings dialog
      if (micStatus.isPermanentlyDenied || speechStatus.isPermanentlyDenied) {
        _isProcessingRecording = false;
        await _showPermissionDialog();
        return;
      }
      
      // If denied but not permanently, request again
      if (micStatus.isDenied || speechStatus.isDenied) {
        final micResult = await Permission.microphone.request();
        final speechResult = await Permission.speech.request();
        
        if (micResult.isDenied || speechResult.isDenied) {
          setState(() {
            _errorMessage = 'Microphone permission denied';
            _isProcessingRecording = false;
          });
          _startErrorTimer();
          return;
        }
        
        if (micResult.isPermanentlyDenied || speechResult.isPermanentlyDenied) {
          _isProcessingRecording = false;
          await _showPermissionDialog();
          return;
        }
      }

      final available = await _speech.initialize();
      if (!available) {
        setState(() {
          _errorMessage = 'Microphone permission denied';
          _isProcessingRecording = false;
        });
        _startErrorTimer();
        return;
      }

      setState(() {
        _recordingState = _RecordingState.recording;
        _errorMessage = '';
      });

      await _speech.listen(
        onResult: (result) {
          if (result.finalResult && mounted) {
            _handleStopRecording();
          }
        },
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.confirmation,
          cancelOnError: true,
          partialResults: false,
        ),
      );

      _isProcessingRecording = false;
    } catch (e) {
      if (mounted) {
        setState(() {
          _recordingState = _RecordingState.idle;
          _errorMessage = 'Failed to start recording';
          _isProcessingRecording = false;
        });
        _startErrorTimer();
      }
    }
  }

  /// Handle stopping voice recording and transcribing
  Future<void> _handleStopRecording() async {
    if (_recordingState != _RecordingState.recording) return;

    setState(() {
      _recordingState = _RecordingState.transcribing;
    });

    try {
      await _speech.stop();

      final transcribedText = _speech.lastRecognizedWords;

      if (mounted) {
        if (transcribedText.isNotEmpty) {
          final currentText = _controller.text;
          final newText = currentText.isEmpty
              ? transcribedText
              : '$currentText $transcribedText';
          _controller.text = newText;
          setState(() {
            _currentText = newText;
            _recordingState = _RecordingState.idle;
            _isProcessingRecording = false;
          });
          widget.onChanged?.call(newText);
        } else {
          setState(() {
            _recordingState = _RecordingState.idle;
            _errorMessage = 'No speech detected';
            _isProcessingRecording = false;
          });
          _startErrorTimer();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recordingState = _RecordingState.idle;
          _errorMessage = 'Transcription failed';
          _isProcessingRecording = false;
        });
        _startErrorTimer();
      }
    }
  }

  /// Handle mic button press
  Future<void> _handleMicPressed() async {
    if (_recordingState == _RecordingState.idle) {
      await _handleStartRecording();
    } else if (_recordingState == _RecordingState.recording) {
      await _handleStopRecording();
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
    
    final String? shimmerText = _recordingState == _RecordingState.recording
        ? 'Recording...'
        : _recordingState == _RecordingState.transcribing
            ? 'Transcribing...'
            : null;

    final isRecording = _recordingState == _RecordingState.recording;
    
    return Stack(
      children: [
        AnimatedContainer(
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
                      right: (_showTrailingIcon || widget.enableVoiceInput) ? 4.0 : 16.0,
                ),
                    child: Stack(
                      children: [
                        CNInput(
                  key: _inputKey,
                  controller: _controller,
                          placeholder: shimmerText == null ? widget.placeholder : '',
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
                          textColor: shimmerText != null
                              ? CupertinoColors.label.withValues(alpha: 0.0)
                              : CupertinoColors.label,
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
                        // Shimmer text overlay
                        if (shimmerText != null)
                          Positioned.fill(
                            child: Container(
                              color: CupertinoColors.transparent,
                              child: IgnorePointer(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 14.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: _ShimmerText(text: shimmerText),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                ),
              ),
            ),
                // Trailing Send Button or Mic Button
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
                ] else if (widget.enableVoiceInput) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      right: 8.0,
                      bottom: _currentHeight > widget.minHeight ? 8.0 : 0.0,
                    ),
                    child: CNButton.icon(
                      icon: CNSymbol(
                        isRecording ? 'stop.circle' : widget.micIconName,
                        size: 16,
                        color: isRecording 
                            ? CupertinoColors.systemRed 
                            : widget.micIconColor,
                      ),
                      size: 32,
                      style: CNButtonStyle.glass,
                      tint: isRecording 
                          ? CupertinoColors.systemRed.withValues(alpha: 0.2)
                          : widget.tint,
                      onPressed: _handleMicPressed,
                    ),
                  ),
            ],
          ],
        ),
      ),
        ),
        // Error message overlay
        if (_errorMessage.isNotEmpty)
          Positioned(
            top: 4,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: CupertinoColors.systemRed.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Shimmer text widget for recording/transcribing states
class _ShimmerText extends StatefulWidget {
  const _ShimmerText({required this.text});

  final String text;

  @override
  State<_ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<_ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return DefaultTextStyle(
          style: const TextStyle(
            backgroundColor: CupertinoColors.transparent,
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: CupertinoColors.white.withValues(alpha: _animation.value * 0.6 + 0.4),
              fontSize: 17,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
              backgroundColor: CupertinoColors.transparent,
            ),
          ),
        );
      },
    );
  }
}
