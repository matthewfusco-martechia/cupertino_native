import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

/// A Cupertino-style slideable list tile with swipe-to-reveal actions.
///
/// Displays a two-line list tile that reveals action buttons when swiped left.
class CupertinoSlideableListTile extends StatefulWidget {
  const CupertinoSlideableListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleSize = 17.0,
    this.subtitleSize = 13.0,
    this.titleColor,
    this.subtitleColor,
    this.actions = const [],
    this.height = 76.0,
    this.actionsBackgroundColor,
    this.tileBackgroundColor,
    this.actionLabelColor,
    this.onTilePressed,
    this.borderRadius = 0.0,
  });

  /// Primary text displayed on the first line
  final String title;

  /// Secondary text displayed on the second line
  final String subtitle;

  /// Font size for the title text
  final double titleSize;

  /// Font size for the subtitle text
  final double subtitleSize;

  /// Color for the title text
  final Color? titleColor;

  /// Color for the subtitle text
  final Color? subtitleColor;

  /// Actions to display when swiped left
  final List<SlideAction> actions;

  /// Height of the list tile
  final double height;

  /// Background color for the actions drawer (revealed when swiped)
  final Color? actionsBackgroundColor;

  /// Background color for the tile content (the slideable part)
  final Color? tileBackgroundColor;

  /// Color for the action labels (defaults to system label color)
  final Color? actionLabelColor;

  /// Callback when the tile itself is tapped (not the swipe actions)
  final VoidCallback? onTilePressed;

  /// Border radius for the tile container
  final double borderRadius;

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
        // Reset hideActions when tile is fully closed
        if (_dragOffset == 0.0) {
          _hideActions = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _maxDragExtent => widget.actions.length * _actionWidth;

  void _handleDragUpdate(DragUpdateDetails details) {
    if (widget.actions.isEmpty) return;
    if (_controller.isAnimating) _controller.stop();

    setState(() {
      _hideActions = false; // Ensure actions are visible when dragging
      _dragOffset += details.primaryDelta!;
      _dragOffset = _dragOffset.clamp(-_maxDragExtent, 0.0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (widget.actions.isEmpty) return;

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
    final titleColor =
        widget.titleColor ?? CupertinoTheme.of(context).primaryColor;
    final subtitleColor = widget.subtitleColor ??
        CupertinoColors.secondaryLabel.resolveFrom(context);
    
    // Background for actions
    final actionsBgColor = widget.actionsBackgroundColor ?? 
        CupertinoColors.systemGrey6.resolveFrom(context);
    
    // Background for tile content
    final tileBgColor = widget.tileBackgroundColor ?? 
        CupertinoColors.systemBackground.resolveFrom(context);

    // Label color
    final labelColor = widget.actionLabelColor ?? CupertinoColors.label.resolveFrom(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          children: [
            // Actions Background & Items
            if (_dragOffset < -0.5 && !_hideActions) 
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: actionsBgColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.actions.map((action) {
                    return Container(
                      width: _actionWidth,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Circle Button with Interactivity
                          CNButton.icon(
                            style: CNButtonStyle.prominentGlass,
                            tint: action.color,
                            size: 40,
                            icon: CNSymbol(
                              action.iconName,
                              size: 16,
                              color: CupertinoColors.white,
                            ),
                            onPressed: () {
                              // Hide native buttons immediately to prevent z-order glitches during close
                              setState(() => _hideActions = true);
                              _close();
                              // Small delay for animation
                              Future.delayed(
                                  const Duration(milliseconds: 200), action.onPressed);
                            },
                          ),
                          const SizedBox(height: 4),
                          // Label
                          Text(
                            action.label,
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
                  }).toList(),
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
                  : widget.onTilePressed,  // Otherwise trigger tile callback
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                height: widget.height,
                decoration: BoxDecoration(
                  color: tileBgColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: widget.titleSize,
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
                        fontSize: widget.subtitleSize,
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
}

/// Represents a swipe action for the slideable list tile
class SlideAction {
  const SlideAction({
    required this.label,
    required this.iconName,
    required this.color,
    required this.onPressed,
  });

  /// Label text displayed below the icon (e.g., "Rename")
  final String label;

  /// SF Symbol name for the action icon
  final String iconName;

  /// Background color for the circle button
  final Color color;

  /// Callback when the action is pressed
  final VoidCallback onPressed;
}
