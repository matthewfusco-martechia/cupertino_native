// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

// ============================================================================
// FOR VOICE INPUT (iOS/macOS):
// Add these to Settings > App Settings > iOS > Info.plist Additions:
//   <key>NSMicrophoneUsageDescription</key>
//   <string>This app needs microphone access for voice input.</string>
//   <key>NSSpeechRecognitionUsageDescription</key>
//   <string>This app needs speech recognition to transcribe your voice.</string>
// ============================================================================

/// FlutterFlow-compatible Liquid Glass Message Input
///
/// Provides:
/// - Plain text input (inside a glass container)
/// - Optional plus popup menu (labels/icons)
/// - Optional Search pill visibility
/// - Mic/Send swap with callbacks
class LiquidGlassMessageInputFF extends StatefulWidget {
  const LiquidGlassMessageInputFF({
    super.key,
    this.width,
    this.height,
    this.textController,
    this.initialText,
    this.placeholder,
    this.onChanged,
    this.onPlusPressed,
    this.plusMenuLabels,
    this.plusMenuIcons,
    this.onPlusMenuSelected,
    this.onSearchPressed,
    this.onMicPressed,
    this.onSendPressed,
    this.showSearch = true,
    this.showMic = true,
    this.sendIconName = 'arrow.up',
    this.sendIconColor,
    this.sendTint,
    this.controlTint,
    this.plusIconName,
    this.plusIconColor,
    this.searchIconName,
    this.searchIconColor,
    this.searchLabel,
    this.micIconName,
    this.micIconColor,
  });

  final double? width;
  final double? height;

  /// Optional external controller so FF can bind text.
  final TextEditingController? textController;
  final String? initialText;
  final String? placeholder;
  final Future<void> Function(String)? onChanged;

  /// Plus button behaviors: either simple tap or popup menu
  final Future<void> Function()? onPlusPressed;
  final List<String>? plusMenuLabels;
  final List<String>? plusMenuIcons;
  final Future<void> Function(int)? onPlusMenuSelected;

  /// Search button
  final Future<void> Function()? onSearchPressed;

  /// Mic and Send callbacks
  final Future<void> Function()? onMicPressed;
  final Future<void> Function()? onSendPressed;

  /// Visibility toggles
  final bool showSearch;
  final bool showMic;
  final String sendIconName;
  final Color? sendIconColor;
  final Color? sendTint;
  final Color? controlTint;
  final String? plusIconName;
  final Color? plusIconColor;
  final String? searchIconName;
  final Color? searchIconColor;
  final String? searchLabel;
  final String? micIconName;
  final Color? micIconColor;

  @override
  State<LiquidGlassMessageInputFF> createState() =>
      _LiquidGlassMessageInputFFState();
}

class _LiquidGlassMessageInputFFState
    extends State<LiquidGlassMessageInputFF> {
  late final TextEditingController _controller =
      widget.textController ?? TextEditingController();

  List<CNPopupMenuEntry>? _buildPlusMenu() {
    final labels = widget.plusMenuLabels;
    if (labels == null || labels.isEmpty) return null;
    final icons = widget.plusMenuIcons;
    final entries = <CNPopupMenuEntry>[];
    final iconSize = 18.0;
    for (var i = 0; i < labels.length; i++) {
      final label = labels[i];
      if (label.trim() == '---') {
        entries.add(const CNPopupMenuDivider());
        continue;
      }
      CNSymbol? icon;
      if (icons != null && i < icons.length && icons[i].isNotEmpty) {
        icon = CNSymbol(icons[i], size: iconSize);
      }
      entries.add(CNPopupMenuItem(label: label, icon: icon, enabled: true));
    }
    return entries;
  }

  Future<void> _handlePlusMenuSelected(int index) async {
    if (widget.onPlusMenuSelected != null) {
      await widget.onPlusMenuSelected!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plusMenuEntries = _buildPlusMenu();

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LiquidGlassMessageInput(
        controller: _controller,
        initialText: widget.initialText,
        placeholder: widget.placeholder ?? 'Message',
        onChanged: widget.onChanged,
        onPlusPressed: widget.onPlusPressed,
        plusMenuItems: plusMenuEntries,
        onPlusMenuSelected: plusMenuEntries != null
            ? (i) => _handlePlusMenuSelected(i)
            : null,
        onSearchPressed: widget.onSearchPressed,
        onStopPressed: widget.onMicPressed,
        onSendPressed: widget.onSendPressed,
        showSearch: widget.showSearch,
        showMic: widget.showMic,
        sendIconName: widget.sendIconName,
        sendIconColor: widget.sendIconColor ?? CupertinoColors.white,
        sendTint: widget.sendTint ?? CupertinoColors.activeBlue,
        controlTint: widget.controlTint ?? const Color(0xFF1C1C1E),
        plusIconName: widget.plusIconName ?? 'plus',
        plusIconColor: widget.plusIconColor,
        searchIconName: widget.searchIconName ?? 'globe',
        searchIconColor: widget.searchIconColor,
        searchLabel: widget.searchLabel ?? 'Search',
        micIconName: widget.micIconName ?? 'mic',
        micIconColor: widget.micIconColor,
      ),
    );
  }
}

