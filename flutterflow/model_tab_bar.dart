// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A native tab bar for switching between Available Models and Downloaded Models.
///
/// Uses the CNTabBar component for pixel-perfect iOS/macOS tab bar appearance
/// with swipe gesture support for sliding between tabs.
class ModelTabBar extends StatefulWidget {
  const ModelTabBar({
    super.key,
    this.width,
    this.height,
    this.initialIndex = 0,
    this.onTabChanged,
    this.tintColor,
    this.availableModelsLabel = 'Available Models',
    this.downloadedModelsLabel = 'Downloaded Models',
    this.availableModelsIcon = 'square.grid.2x2',
    this.downloadedModelsIcon = 'arrow.down.circle.fill',
    this.shrinkCentered = true,
  });

  final double? width;
  final double? height;

  /// The initial tab index (0 = Available Models, 1 = Downloaded Models).
  final int initialIndex;

  /// Callback when the tab changes, receives the new index.
  final void Function(int index)? onTabChanged;

  /// Optional tint color for the selected tab.
  final Color? tintColor;

  /// Label for the first tab.
  final String availableModelsLabel;

  /// Label for the second tab.
  final String downloadedModelsLabel;

  /// SF Symbol name for the first tab icon.
  final String availableModelsIcon;

  /// SF Symbol name for the second tab icon.
  final String downloadedModelsIcon;

  /// Whether to shrink and center the tab bar.
  final bool shrinkCentered;

  @override
  State<ModelTabBar> createState() => _ModelTabBarState();
}

class _ModelTabBarState extends State<ModelTabBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant ModelTabBar oldWidget) {
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
            label: widget.availableModelsLabel,
            icon: CNSymbol(widget.availableModelsIcon),
          ),
          CNTabBarItem(
            label: widget.downloadedModelsLabel,
            icon: CNSymbol(widget.downloadedModelsIcon),
          ),
        ],
        currentIndex: _currentIndex,
        tint: widget.tintColor ?? CupertinoTheme.of(context).primaryColor,
        shrinkCentered: widget.shrinkCentered,
        onTap: (index) {
          setState(() => _currentIndex = index);
          widget.onTabChanged?.call(index);
        },
      ),
    );
  }
}
