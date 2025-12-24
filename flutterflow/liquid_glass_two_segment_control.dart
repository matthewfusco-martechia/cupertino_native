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

import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A native two-segment control with sliding gesture support.
///
/// Uses CNSegmentedControl which is backed by native UISegmentedControl.
/// Supports both tap and slide/drag gestures to switch between segments.
class LiquidGlassTwoSegmentControl extends StatefulWidget {
  const LiquidGlassTwoSegmentControl({
    super.key,
    this.width,
    this.height,
    required this.initialIndex,
    required this.onValueChanged,
    this.tintColor,
    required this.firstLabel,
    required this.secondLabel,
    this.firstIcon,
    this.secondIcon,
    required this.shrinkWrap,
  });

  final double? width;
  final double? height;
  final int initialIndex;
  final Future Function(int? index) onValueChanged;
  final Color? tintColor;
  final String firstLabel;
  final String secondLabel;
  final String? firstIcon;
  final String? secondIcon;
  final bool shrinkWrap;

  @override
  State<LiquidGlassTwoSegmentControl> createState() =>
      _LiquidGlassTwoSegmentControlState();
}

class _LiquidGlassTwoSegmentControlState
    extends State<LiquidGlassTwoSegmentControl> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant LiquidGlassTwoSegmentControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() => _currentIndex = widget.initialIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build SF Symbols list if icons are provided
    List<CNSymbol>? symbols;
    if (widget.firstIcon != null && widget.secondIcon != null) {
      symbols = [
        CNSymbol(widget.firstIcon!),
        CNSymbol(widget.secondIcon!),
      ];
    }

    final control = CNSegmentedControl(
      labels: [widget.firstLabel, widget.secondLabel],
      selectedIndex: _currentIndex,
      color: widget.tintColor ?? CupertinoTheme.of(context).primaryColor,
      height: widget.height ?? 32.0,
      shrinkWrap: widget.shrinkWrap,
      sfSymbols: symbols,
      onValueChanged: (index) {
        setState(() => _currentIndex = index);
        widget.onValueChanged(index);
      },
    );

    if (widget.width != null && !widget.shrinkWrap) {
      return SizedBox(
        width: widget.width,
        child: control,
      );
    }

    return control;
  }
}
