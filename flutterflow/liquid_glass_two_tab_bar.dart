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

/// A native two-tab bar with liquid glass styling.
///
/// Uses the CNTabBar component for pixel-perfect iOS/macOS tab bar appearance
/// with swipe gesture support for sliding between tabs.
class LiquidGlassTwoTabBar extends StatefulWidget {
  const LiquidGlassTwoTabBar({
    super.key,
    this.width,
    this.height,
    required this.initialIndex,
    required this.onTabChanged,
    this.tintColor,
    required this.firstTabLabel,
    required this.secondTabLabel,
    required this.firstTabIcon,
    required this.secondTabIcon,
    required this.shrinkCentered,
  });

  final double? width;
  final double? height;
  final int initialIndex;
  final Future Function(int? index) onTabChanged;
  final Color? tintColor;
  final String firstTabLabel;
  final String secondTabLabel;
  final String firstTabIcon;
  final String secondTabIcon;
  final bool shrinkCentered;

  @override
  State<LiquidGlassTwoTabBar> createState() => _LiquidGlassTwoTabBarState();
}

class _LiquidGlassTwoTabBarState extends State<LiquidGlassTwoTabBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant LiquidGlassTwoTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update if initialIndex changes from parent
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() => _currentIndex = widget.initialIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height ?? 50,
      child: CNTabBar(
        items: [
          CNTabBarItem(
            label: widget.firstTabLabel,
            icon: CNSymbol(widget.firstTabIcon),
          ),
          CNTabBarItem(
            label: widget.secondTabLabel,
            icon: CNSymbol(widget.secondTabIcon),
          ),
        ],
        currentIndex: _currentIndex,
        tint: widget.tintColor ?? CupertinoTheme.of(context).primaryColor,
        shrinkCentered: widget.shrinkCentered,
        onTap: (index) {
          setState(() => _currentIndex = index);
          widget.onTabChanged(index);
        },
      ),
    );
  }
}
