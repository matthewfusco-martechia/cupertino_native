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

/// A premium "Liquid Glass" segmented control with native iOS fidelity.
/// 
/// This widget wraps the native CNLiquidGlassSegmentedControl but handles
/// gestures in Dart to ensure perfect behavior inside ScrollViews/PageViews.
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

  @override
  State<LiquidGlassTwoSegmentControl> createState() =>
      _LiquidGlassTwoSegmentControlState();
}

class _LiquidGlassTwoSegmentControlState
    extends State<LiquidGlassTwoSegmentControl> {
  late int _currentIndex;
  
  // Drag state for interactive sliding
  bool _isDragging = false;
  int _dragIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    if (_currentIndex < 0) _currentIndex = 0;
    if (_currentIndex > 1) _currentIndex = 1;
  }

  @override
  void didUpdateWidget(covariant LiquidGlassTwoSegmentControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      if (widget.initialIndex >= 0 && widget.initialIndex < 2) {
          if (!_isDragging) {
             setState(() => _currentIndex = widget.initialIndex);
          }
      }
    }
  }

  void _handleTap(int index) async {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    HapticFeedback.selectionClick();
    await widget.onValueChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    List<String> symbols = [];
    if (widget.firstIcon != null && widget.secondIcon != null) {
      symbols = [widget.firstIcon!, widget.secondIcon!];
    }
    
    final int displayIndex = _isDragging ? _dragIndex : _currentIndex;

    return SizedBox(
      width: widget.width ?? 320,
      height: widget.height ?? 90, 
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double w = constraints.maxWidth;
          
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (details) {
              setState(() {
                _isDragging = true;
                _dragIndex = _currentIndex;
              });
            },
            onHorizontalDragUpdate: (details) {
              final double dx = details.localPosition.dx;
              final int newIndex = (dx >= w / 2) ? 1 : 0;
              if (newIndex != _dragIndex) {
                setState(() => _dragIndex = newIndex);
                HapticFeedback.selectionClick();
              }
            },
            onHorizontalDragEnd: (details) async {
              final int committed = _dragIndex;
              setState(() {
                _isDragging = false;
                _currentIndex = committed;
              });
              await widget.onValueChanged(committed);
            },
            onHorizontalDragCancel: () {
              setState(() {
                _isDragging = false;
              });
            },
            child: CNLiquidGlassSegmentedControl(
              labels: [widget.firstLabel, widget.secondLabel],
              sfSymbols: symbols.isNotEmpty ? symbols.map((e) => CNSymbol(e)).toList() : null,
              selectedIndex: displayIndex,
              onValueChanged: (index) {
                if (!_isDragging) {
                  _handleTap(index);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

