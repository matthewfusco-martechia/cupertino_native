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

/// Liquid Glass Icon Button with Badge Count
///
/// A glass-styled icon button with an optional badge showing a count.
/// Perfect for back buttons showing unread message counts, notification badges, etc.
class LiquidGlassIconButtonWithBadge extends StatefulWidget {
  const LiquidGlassIconButtonWithBadge({
    super.key,
    this.width,
    this.height,
    this.symbolName,
    this.iconAction,
    this.iconColor,
    this.iconSize,
    this.badgeCount,
    this.badgeBackgroundColor,
    this.badgeTextColor,
    this.showBadge,
  });

  final double? width;
  final double? height;

  /// SF Symbol name for the icon (e.g., "chevron.left", "arrow.left")
  final String? symbolName;

  /// Callback action when the button is pressed
  final Future Function()? iconAction;

  /// Color for the SF Symbol icon
  final Color? iconColor;

  /// Size for the SF Symbol icon
  final double? iconSize;

  /// The count to display in the badge (e.g., unread messages)
  final int? badgeCount;

  /// Background color for the badge pill
  final Color? badgeBackgroundColor;

  /// Text color for the badge count
  final Color? badgeTextColor;

  /// Whether to show the badge (defaults to true if badgeCount > 0)
  final bool? showBadge;

  @override
  State<LiquidGlassIconButtonWithBadge> createState() =>
      _LiquidGlassIconButtonWithBadgeState();
}

class _LiquidGlassIconButtonWithBadgeState
    extends State<LiquidGlassIconButtonWithBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHidden = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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

  @override
  Widget build(BuildContext context) {
    _checkModalStatus();

    final iconSize = widget.iconSize ?? 20.0;
    final buttonHeight = widget.height ?? 44.0;
    
    // Badge settings
    final count = widget.badgeCount ?? 0;
    final shouldShowBadge = widget.showBadge ?? (count > 0);
    final badgeBgColor = widget.badgeBackgroundColor ?? 
        FlutterFlowTheme.of(context).primaryBackground;
    final badgeTextColor = widget.badgeTextColor ?? 
        FlutterFlowTheme.of(context).primaryText;
    final iconColor = widget.iconColor ?? 
        FlutterFlowTheme.of(context).primaryText;
    final symbolName = widget.symbolName ?? "chevron.left";

    if (_isHidden) {
      return SizedBox(
        width: widget.width,
        height: buttonHeight,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () async {
        if (widget.iconAction != null) {
          await widget.iconAction!();
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: CNGlassEffectContainer(
          glassStyle: CNGlassStyle.regular,
          cornerRadius: buttonHeight / 2,
          height: buttonHeight,
          interactive: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                CNIcon(
                  symbol: CNSymbol(
                    symbolName,
                    size: iconSize,
                    color: iconColor,
                  ),
                ),
                // Badge with count
                if (shouldShowBadge) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

