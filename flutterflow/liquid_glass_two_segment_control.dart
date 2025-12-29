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
import 'package:cupertino_native/components/liquid_glass_segmented_control.dart';

/// A premium "Liquid Glass" segmented control with native iOS fidelity.
/// 
/// IMPLEMENTATION NOTE:
/// This widget requires the 'cupertino_native' package to be added to 
/// your project's pubspec dependencies. It relies on platform-specific 
/// Swift code provided by that package.
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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant LiquidGlassTwoSegmentControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      if (widget.initialIndex >= 0 && widget.initialIndex < 2) {
          setState(() => _currentIndex = widget.initialIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build SF Symbols list if icons are provided
    // Ensure these match valid SFSymbol names (e.g. 'square.grid.2x2')
    List<String> symbols = [];
    if (widget.firstIcon != null && widget.secondIcon != null) {
      symbols = [widget.firstIcon!, widget.secondIcon!];
    }

    return SizedBox(
      width: widget.width ?? 320,
      height: widget.height ?? 90, // Default to 90 for correct glass aspect ratio
      child: CupertinoLiquidGlassSegmentedControl(
        labels: [widget.firstLabel, widget.secondLabel],
        sfSymbols: symbols.isNotEmpty ? symbols : null,
        selectedIndex: _currentIndex,
        isDark: Theme.of(context).brightness == Brightness.dark,
        onValueChanged: (index) async {
          setState(() => _currentIndex = index);
          await widget.onValueChanged(index);
        },
      ),
    );
  }
}
