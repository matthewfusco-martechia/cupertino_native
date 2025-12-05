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

/// A Cupertino-style slideable list tile with swipe-to-reveal actions.
///
/// Displays a two-line list tile that reveals action buttons when swiped left.
class CupertinoSlideableListTile extends StatefulWidget {
  const CupertinoSlideableListTile({
    super.key,
    this.width,
    this.height,
    required this.title,
    required this.subtitle,
    this.titleSize,
    this.subtitleSize,
    this.titleColor,
    this.subtitleColor,
    this.tileBackgroundColor,
    this.actionLabelColor,
    this.action1Label,
    this.action1Icon,
    this.action1Color,
    this.action1Callback,
    this.action2Label,
    this.action2Icon,
    this.action2Color,
    this.action2Callback,
    this.actionsBackgroundColor,
    this.onTilePressed,
    this.borderRadius,
  });

  final double? width;
  final double? height;

  /// Primary text displayed on the first line
  final String title;

  /// Secondary text displayed on the second line
  final String subtitle;

  /// Font size for the title text (defaults to 17.0)
  final double? titleSize;

  /// Font size for the subtitle text (defaults to 13.0)
  final double? subtitleSize;

  /// Color for the title text
  final Color? titleColor;

  /// Color for the subtitle text
  final Color? subtitleColor;

  /// Background color for the tile content
  final Color? tileBackgroundColor;

  /// Color for action labels
  final Color? actionLabelColor;

  /// Label for the first action
  final String? action1Label;

  /// SF Symbol name for the first action (e.g., "pencil")
  final String? action1Icon;

  /// Background color for the first action circle
  final Color? action1Color;

  /// Callback for the first action
  final Future<dynamic> Function()? action1Callback;

  /// Label for the second action
  final String? action2Label;

  /// SF Symbol name for the second action (e.g., "trash")
  final String? action2Icon;

  /// Background color for the second action circle
  final Color? action2Color;

  /// Callback for the second action
  final Future<dynamic> Function()? action2Callback;

  /// Background color for the actions drawer
  final Color? actionsBackgroundColor;

  /// Callback when the tile itself is tapped (not the swipe actions)
  final Future<dynamic> Function()? onTilePressed;

  /// Border radius for the tile container (defaults to 0)
  final double? borderRadius;

  @override
  State<CupertinoSlideableListTile> createState() =>
      _CupertinoSlideableListTileState();
}

class _CupertinoSlideableListTileState
    extends State<CupertinoSlideableListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragOffset = 0.0;
  final double _actionWidth = 70.0; // Width per action
  bool _isHidden = false;
  bool _hideActions = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.addListener(() {
      setState(() {
        _dragOffset = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkModalStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      final shouldHide = route != null && !route.isCurrent;
      if (shouldHide != _isHidden) {
        setState(() {
          _isHidden = shouldHide;
        });
      }
    });
  }

  int get _actionCount {
    int count = 0;
    if (widget.action1Icon != null) count++;
    if (widget.action2Icon != null) count++;
    return count;
  }

  double get _maxDragExtent => _actionCount * _actionWidth;

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_actionCount == 0) return;
    if (_controller.isAnimating) _controller.stop();

    setState(() {
      _hideActions = false;
      _dragOffset += details.primaryDelta!;
      _dragOffset = _dragOffset.clamp(-_maxDragExtent, 0.0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_actionCount == 0) return;

    final velocity = details.primaryVelocity ?? 0;
    final threshold = -_maxDragExtent / 2;

    double end;
    if (_dragOffset < threshold || velocity < -500) {
      end = -_maxDragExtent; // Open
    } else {
      end = 0.0; // Close
    }

    _animation = Tween<double>(begin: _dragOffset, end: end).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0.0);
  }

  void _close() {
    if (_dragOffset == 0.0) return;
    _animation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    _checkModalStatus();

    if (_isHidden) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }

    final defaultHeight = widget.height ?? 76.0;
    final titleColor =
        widget.titleColor ?? FlutterFlowTheme.of(context).primaryText;
    final subtitleColor =
        widget.subtitleColor ?? FlutterFlowTheme.of(context).secondaryText;
    final titleSize = widget.titleSize ?? 17.0;
    final subtitleSize = widget.subtitleSize ?? 13.0;
    
    final actionsBgColor = widget.actionsBackgroundColor ?? 
        FlutterFlowTheme.of(context).secondaryBackground;
        
    final tileBgColor = widget.tileBackgroundColor ?? 
        FlutterFlowTheme.of(context).primaryBackground;

    final labelColor = widget.actionLabelColor ?? 
        FlutterFlowTheme.of(context).primaryText;
    
    final radius = widget.borderRadius ?? 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: defaultHeight,
        child: Stack(
          children: [
            // Actions Background & Items
            if (_actionCount > 0 && _dragOffset < -0.5 && !_hideActions)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: actionsBgColor,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Action 1
                    if (widget.action1Icon != null)
                      _buildActionItem(
                        label: widget.action1Label ?? "Action",
                        icon: widget.action1Icon!,
                        color: widget.action1Color ?? CupertinoColors.systemBlue,
                        labelColor: labelColor,
                        onTap: widget.action1Callback,
                      ),
                    // Action 2
                    if (widget.action2Icon != null)
                      _buildActionItem(
                        label: widget.action2Label ?? "Action",
                        icon: widget.action2Icon!,
                        color: widget.action2Color ?? CupertinoColors.systemRed,
                        labelColor: labelColor,
                        onTap: widget.action2Callback,
                      ),
                  ],
                ),
              ),
            ),
          
          // Slideable Content
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: GestureDetector(
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              onTap: _dragOffset < 0 
                  ? _close  // If swiped open, tap closes it
                  : () => widget.onTilePressed?.call(),  // Otherwise trigger tile callback
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                height: defaultHeight,
                decoration: BoxDecoration(
                  color: tileBgColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: subtitleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required String label,
    required String icon,
    required Color color,
    required Color labelColor,
    required Future<dynamic> Function()? onTap,
  }) {
    return Container(
      width: _actionWidth,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CNButton.icon(
            style: CNButtonStyle.prominentGlass,
            tint: color,
            size: 40,
            icon: CNSymbol(
              icon,
              size: 16,
              color: CupertinoColors.white,
            ),
            onPressed: () {
              setState(() => _hideActions = true);
              _close();
              Future.delayed(
                  const Duration(milliseconds: 200), () => onTap?.call());
            },
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
