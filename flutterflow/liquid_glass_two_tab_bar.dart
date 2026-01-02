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
import 'package:flutter/services.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A FlutterFlow-compatible liquid glass tab bar.
///
/// Uses component state to manage the current tab index, making it
/// compatible with FlutterFlow's state management (no TabController needed).
/// You can use this with a PageView or conditionally render content based
/// on the currentIndex returned in onTabChanged.
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
    this.firstTabIcon,
    this.secondTabIcon,
    this.shrinkCentered = true,
  });

  final double? width;
  final double? height;
  final int initialIndex;
  
  /// Called when the user taps or slides to a different tab.
  /// Use this callback to update FlutterFlow component/page state.
  final Future Function(int? index) onTabChanged;
  
  final Color? tintColor;
  final String firstTabLabel;
  final String secondTabLabel;
  
  /// Optional SF Symbol name for the first tab icon.
  /// Example: 'square.grid.2x2'
  final String? firstTabIcon;
  
  /// Optional SF Symbol name for the second tab icon.
  /// Example: 'arrow.down.circle.fill'
  final String? secondTabIcon;
  
  /// If true, centers and shrinks the tab bar to fit content.
  final bool shrinkCentered;

  @override
  State<LiquidGlassTwoTabBar> createState() => _LiquidGlassTwoTabBarState();
}

class _LiquidGlassTwoTabBarState extends State<LiquidGlassTwoTabBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 1);
  }

  @override
  void didUpdateWidget(covariant LiquidGlassTwoTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync with parent state if initialIndex changes
    if (widget.initialIndex != oldWidget.initialIndex) {
      final newIndex = widget.initialIndex.clamp(0, 1);
      if (newIndex != _currentIndex) {
        setState(() => _currentIndex = newIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build items with optional icons
    final items = <CNTabBarItem>[
      CNTabBarItem(
        label: widget.firstTabLabel,
        icon: widget.firstTabIcon != null && widget.firstTabIcon!.isNotEmpty
            ? CNSymbol(widget.firstTabIcon!)
            : null,
      ),
      CNTabBarItem(
        label: widget.secondTabLabel,
        icon: widget.secondTabIcon != null && widget.secondTabIcon!.isNotEmpty
            ? CNSymbol(widget.secondTabIcon!)
            : null,
      ),
    ];

    return SizedBox(
      width: widget.width,
      height: widget.height ?? 90,
      child: CNTabBar(
        items: items,
        currentIndex: _currentIndex,
        tint: widget.tintColor ?? CupertinoTheme.of(context).primaryColor,
        shrinkCentered: widget.shrinkCentered,
        onTap: (index) async {
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
            HapticFeedback.selectionClick();
            await widget.onTabChanged(index);
          }
        },
      ),
    );
  }
}
