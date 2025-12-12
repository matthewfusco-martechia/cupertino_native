import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Recording states for voice input
enum _RecordingState {
  idle,
  recording,
  transcribing,
}

/// A two-row liquid glass message composer that reuses [LiquidGlassTextField].
///
/// Row 1: a plain (non-glass) text field. Row 2: plus + Search on the
/// left, mic on the right. The outer glass container grows with text height.
///
/// Supports OpenAI-style voice recording with waveform animation and speech-to-text.
class LiquidGlassMessageInput extends StatefulWidget {
  /// Creates a liquid glass message input with voice recording support.
  const LiquidGlassMessageInput({
    super.key,
    this.controller,
    this.initialText,
    this.placeholder = 'Message',
    this.onChanged,
    this.onPlusPressed,
    this.plusMenuItems,
    this.onPlusMenuSelected,
    this.onSearchPressed,
    this.onStopPressed,
    this.onSendPressed,
    this.showSearch = true,
    this.showMic = true,
    this.sendIconName = 'arrow.up',
    this.sendIconColor = CupertinoColors.white,
    this.sendTint = CupertinoColors.activeBlue,
    this.controlTint = const Color(0xFF1C1C1E),
    this.plusIconName = 'plus',
    this.plusIconColor,
    this.searchIconName = 'globe',
    this.searchIconColor,
    this.searchLabel = 'Search',
    this.micIconName = 'mic',
    this.micIconColor,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Initial text to populate the field when no external controller is provided.
  final String? initialText;

  /// Placeholder text.
  final String placeholder;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback for the plus button.
  final VoidCallback? onPlusPressed;

  /// Popup menu items for the plus button. When provided, plus shows a menu.
  final List<CNPopupMenuEntry>? plusMenuItems;

  /// Callback when a plus menu item is selected.
  final ValueChanged<int>? onPlusMenuSelected;

  /// Callback for the Search pill button.
  final VoidCallback? onSearchPressed;

  /// Callback for the mic button.
  final VoidCallback? onStopPressed;

  /// Callback for the send button (appears when text is not empty).
  final VoidCallback? onSendPressed;

  /// Whether to show the Search pill button.
  final bool showSearch;

  /// Whether to show the mic/send trailing button.
  final bool showMic;

  /// Send icon customization.
  final String sendIconName;
  
  /// Send icon color.
  final Color sendIconColor;
  
  /// Send button background tint.
  final Color sendTint;

  /// Shared control tint (plus/search/mic backgrounds).
  final Color controlTint;

  /// Icon/label customization.
  final String plusIconName;
  
  /// Plus icon color.
  final Color? plusIconColor;
  
  /// Search icon name.
  final String searchIconName;
  
  /// Search icon color.
  final Color? searchIconColor;
  
  /// Search label text.
  final String searchLabel;
  
  /// Microphone icon name.
  final String micIconName;
  
  /// Microphone icon color.
  final Color? micIconColor;

  @override
  State<LiquidGlassMessageInput> createState() =>
      _LiquidGlassMessageInputState();
}

class _LiquidGlassMessageInputState extends State<LiquidGlassMessageInput> with WidgetsBindingObserver {
  String _text = '';
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController(text: widget.initialText ?? '');

  // Voice recording state
  _RecordingState _recordingState = _RecordingState.idle;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechInitialized = false;
  String _errorMessage = '';
  Timer? _errorTimer;
  bool _isProcessingRecording = false; // Debounce flag

  @override
  void initState() {
    super.initState();
    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    _initializeSpeech();
  }

  @override
  void dispose() {
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    _cleanupSpeech();
    _errorTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      // App resumed - permissions might have changed
      _handleAppResumed();
    } else if (state == AppLifecycleState.paused) {
      // App paused - stop any active recording
      _handleAppPaused();
    }
  }

  /// Handle app resuming (user might have changed permissions)
  Future<void> _handleAppResumed() async {
    // If we were recording, stop it
    if (_recordingState == _RecordingState.recording) {
      await _stopRecordingGracefully();
    }
    
    // Reset initialization flag to force re-check on next mic tap
    _speechInitialized = false;
  }

  /// Handle app pausing (stop any active recording)
  Future<void> _handleAppPaused() async {
    if (_recordingState == _RecordingState.recording) {
      await _stopRecordingGracefully();
    }
  }

  /// Gracefully stop recording without crashing
  Future<void> _stopRecordingGracefully() async {
    try {
      if (_speech.isListening) {
        await _speech.stop();
      }
    } catch (e) {
      // Ignore errors when stopping
    }
    
    if (mounted) {
      setState(() {
        _recordingState = _RecordingState.idle;
        _isProcessingRecording = false;
      });
    }
  }

  /// Clean up speech resources
  void _cleanupSpeech() {
    try {
      if (_speechInitialized && _speech.isListening) {
        _speech.stop();
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  /// Initialize speech recognition with timeout
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
            // Speech stopped listening (e.g., timeout)
            _handleStopRecording();
          }
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          if (mounted) {
            _speechInitialized = false;
          }
          return false;
        },
      );
    } catch (e) {
      if (mounted) {
        _speechInitialized = false;
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

  /// Handle starting voice recording
  Future<void> _handleStartRecording() async {
    // Debounce: prevent multiple simultaneous recording starts
    if (_isProcessingRecording) return;
    _isProcessingRecording = true;

    // If speech wasn't initialized or isn't available, try to initialize it now
    if (!_speechInitialized || !_speech.isAvailable) {
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
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            if (mounted) {
              setState(() {
                _errorMessage = 'Speech initialization timed out';
                _isProcessingRecording = false;
              });
              _startErrorTimer();
            }
            return false;
          },
        );
        
        if (!_speechInitialized) {
          setState(() {
            _errorMessage = 'Microphone permission required';
            _isProcessingRecording = false;
          });
          _startErrorTimer();
          return;
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Failed to initialize speech recognition';
            _isProcessingRecording = false;
          });
          _startErrorTimer();
        }
        return;
      }
    }

    try {

      setState(() {
        _recordingState = _RecordingState.recording;
        _errorMessage = '';
      });

      await _speech.listen(
        onResult: (result) {
          // Update with partial results if needed
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
          _errorMessage = 'Microphone permission required';
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

      // Get the transcribed text
      final transcribedText = _speech.lastRecognizedWords;

      if (mounted) {
        if (transcribedText.isNotEmpty) {
          // Insert transcribed text into the input field
          final currentText = _controller.text;
          final newText = currentText.isEmpty
              ? transcribedText
              : '$currentText $transcribedText';
          _controller.text = newText;
          setState(() {
            _text = newText;
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

  /// Handle mic button press (toggle recording)
  Future<void> _handleMicPressed() async {
    if (_recordingState == _RecordingState.idle) {
      await _handleStartRecording();
    } else if (_recordingState == _RecordingState.recording) {
      await _handleStopRecording();
    }
    // Ignore if transcribing
  }

  double _computeHeight() {
    // Base: text row (~52 with padding) + spacer + controls (~52) + outer padding.
    const base = 118.0;
    final lineCount = (_text.isEmpty ? 1 : _text.split('\n').length).clamp(1, 4);
    final extra = (lineCount - 1) * 24.0;
    return (base + extra).clamp(118.0, 220.0);
  }

  Future<void> _handleSend() async {
    final text = _controller.text;
    if (text.isEmpty) return;
    widget.onSendPressed?.call();
    _controller.clear();
    setState(() => _text = '');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final targetHeight = _computeHeight().clamp(120.0, 400.0);

    // Show shimmer text when recording or transcribing
    final String? shimmerText = _recordingState == _RecordingState.recording
        ? 'Recording...'
        : _recordingState == _RecordingState.transcribing
            ? 'Transcribing...'
            : null;

    return SizedBox(
      height: targetHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Main input container
          CNGlassEffectContainer(
            glassStyle: CNGlassStyle.regular,
            cornerRadius: 22.0,
            tint: const Color(0xFF0D0D0F).withValues(alpha: 0.78),
            height: targetHeight,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text input field with shimmer overlay
                  Stack(
                    children: [
                      CupertinoTextField(
                        controller: _controller,
                        placeholder: shimmerText == null ? widget.placeholder : '',
                        onChanged: (value) {
                          setState(() => _text = value);
                          widget.onChanged?.call(value);
                        },
                        maxLines: 4,
                        minLines: 1,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                        decoration: const BoxDecoration(
                          color: CupertinoColors.transparent,
                        ),
                        style: TextStyle(
                          color: shimmerText != null
                              ? CupertinoColors.white.withValues(alpha: 0.0)
                              : CupertinoColors.white,
                          fontSize: 17,
                        ),
                        placeholderStyle: TextStyle(
                          color: CupertinoColors.white.withValues(alpha: 0.35),
                          fontSize: 17,
                        ),
                        cursorColor: CupertinoColors.activeBlue,
                        enabled: shimmerText == null,
                      ),
                      // Shimmer text overlay
                      if (shimmerText != null)
                        Positioned.fill(
                          child: Container(
                            color: CupertinoColors.transparent,
                            child: IgnorePointer(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 12.0),
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
                  const SizedBox(height: 10.0),
                  // Control buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.plusMenuItems != null &&
                              widget.plusMenuItems!.isNotEmpty)
                            CNPopupMenuButton.icon(
                              buttonIcon: CNSymbol(
                                widget.plusIconName,
                                size: 18,
                                color: widget.plusIconColor,
                              ),
                              size: 44.0,
                              items: widget.plusMenuItems!,
                              onSelected: widget.onPlusMenuSelected ?? (_) {},
                              tint: widget.controlTint,
                              buttonStyle: CNButtonStyle.glass,
                            )
                          else
                            CNButton.icon(
                              icon: CNSymbol(
                                widget.plusIconName,
                                size: 18,
                                color: widget.plusIconColor,
                              ),
                              size: 44.0,
                              style: CNButtonStyle.glass,
                              tint: widget.controlTint,
                              onPressed: widget.onPlusPressed,
                            ),
                          const SizedBox(width: 8.0),
                          if (widget.showSearch)
                            _GlassPillButton(
                              iconName: widget.searchIconName,
                              iconColor: widget.searchIconColor,
                              label: widget.searchLabel,
                              tint: widget.controlTint,
                              onPressed: widget.onSearchPressed,
                            ),
                        ],
                      ),
                      if (widget.showMic)
                        _TrailingActionButton(
                          hasText: _text.isNotEmpty,
                          micTint: widget.controlTint,
                          sendTint: widget.sendTint,
                          sendIconName: widget.sendIconName,
                          sendIconColor: widget.sendIconColor,
                          micIconName: widget.micIconName,
                          micIconColor: widget.micIconColor,
                          onMicPressed: _handleMicPressed,
                          onSendPressed: _handleSend,
                          buttonSize: 44.0,
                          recordingState: _recordingState,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Error message overlay
          if (_errorMessage.isNotEmpty)
            Positioned(
              top: 8,
              left: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemRed.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
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

/// Trailing action button (mic or send)
class _TrailingActionButton extends StatelessWidget {
  const _TrailingActionButton({
    required this.hasText,
    required this.micTint,
    required this.sendTint,
    required this.buttonSize,
    required this.sendIconName,
    required this.sendIconColor,
    required this.micIconName,
    required this.recordingState,
    this.micIconColor,
    this.onMicPressed,
    this.onSendPressed,
  });

  final bool hasText;
  final Color micTint;
  final Color sendTint;
  final double buttonSize;
  final String sendIconName;
  final Color sendIconColor;
  final String micIconName;
  final Color? micIconColor;
  final VoidCallback? onMicPressed;
  final VoidCallback? onSendPressed;
  final _RecordingState recordingState;

  @override
  Widget build(BuildContext context) {
    // Show send button if there's text
    if (hasText) {
      return CNButton.icon(
        icon: CNSymbol(
          sendIconName,
          size: 16,
          color: sendIconColor,
        ),
        size: buttonSize,
        style: CNButtonStyle.prominentGlass,
        tint: sendTint,
        onPressed: onSendPressed,
      );
    }

    // Show mic button with recording state indication
    final isRecording = recordingState == _RecordingState.recording;
    return CNButton.icon(
      icon: CNSymbol(
        isRecording ? 'stop.circle' : micIconName,
        size: 18,
        color: isRecording ? CupertinoColors.systemRed : micIconColor,
      ),
      size: buttonSize,
      style: CNButtonStyle.glass,
      tint: isRecording 
          ? CupertinoColors.systemRed.withValues(alpha: 0.2)
          : micTint,
      onPressed: onMicPressed,
    );
  }
}

/// Glass pill button for Search
class _GlassPillButton extends StatelessWidget {
  const _GlassPillButton({
    required this.iconName,
    required this.label,
    this.iconColor,
    this.onPressed,
    this.tint,
  });

  final String iconName;
  final String label;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final textColor = CupertinoColors.label.resolveFrom(context);

    return IntrinsicWidth(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CNGlassEffectContainer(
                glassStyle: CNGlassStyle.regular,
                cornerRadius: 18.0,
                tint: tint?.withValues(alpha: 0.28),
                interactive: onPressed != null,
                onTap: onPressed,
                child: const SizedBox(),
              ),
            ),
            IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CNIcon(
                      symbol: CNSymbol(
                        iconName,
                        size: 18,
                        color: iconColor ?? textColor,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
