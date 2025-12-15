import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A two-row liquid glass message composer.
///
/// Row 1: a plain (non-glass) text field. Row 2: plus + Search on the
/// left, mic on the right. The outer glass container grows with text height.
///
/// For voice input, users can use iOS's native keyboard dictation by tapping
/// the microphone button on the iOS keyboard. This is handled entirely by iOS
/// and requires no additional setup.
class LiquidGlassMessageInput extends StatefulWidget {
  /// Creates a liquid glass message input.
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
    this.onMicPressed,
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
  final VoidCallback? onMicPressed;

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

class _LiquidGlassMessageInputState extends State<LiquidGlassMessageInput> {
  String _text = '';
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController(text: widget.initialText ?? '');

  @override
  void initState() {
    super.initState();
    _text = _controller.text;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
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

    // CRITICAL: Wrap in RepaintBoundary to isolate platform view compositing
    // This prevents rendering issues when used in overlays with stacked sheets
    return RepaintBoundary(
      child: SizedBox(
        height: targetHeight,
        width: double.infinity,
        child: CNGlassEffectContainer(
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
              // Text input field
              CupertinoTextField(
                controller: _controller,
                placeholder: widget.placeholder,
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
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 17,
                ),
                placeholderStyle: TextStyle(
                  color: CupertinoColors.white.withValues(alpha: 0.35),
                  fontSize: 17,
                ),
                cursorColor: CupertinoColors.activeBlue,
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
                      onMicPressed: widget.onMicPressed,
                      onSendPressed: _handleSend,
                      buttonSize: 44.0,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
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

    // Show mic button (user can use iOS keyboard dictation)
    return CNButton.icon(
      icon: CNSymbol(
        micIconName,
        size: 18,
        color: micIconColor,
      ),
      size: buttonSize,
      style: CNButtonStyle.glass,
      tint: micTint,
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
