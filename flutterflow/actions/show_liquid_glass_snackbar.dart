// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cupertino_native/cupertino_native.dart';

Future showLiquidGlassSnackbar(
  BuildContext context,
  String message,
  String iconName,
  Color iconColor,
  int durationSeconds,
) async {
  final overlayState = Overlay.of(context);
  OverlayEntry? overlayEntry;

  // Animation controller values
  final animationDuration = const Duration(milliseconds: 300);

  // Create the overlay entry
  overlayEntry = OverlayEntry(
    builder: (context) => _LiquidGlassSnackbar(
      message: message,
      iconName: iconName,
      iconColor: iconColor,
      onDismiss: () {
        overlayEntry?.remove();
      },
      animationDuration: animationDuration,
    ),
  );

  // Insert the overlay
  overlayState.insert(overlayEntry);

  // Wait a frame for the overlay to be inserted
  await Future.delayed(const Duration(milliseconds: 50));

  // Auto-dismiss after duration
  await Future.delayed(Duration(seconds: durationSeconds));

  // Remove the overlay if it hasn't been manually dismissed
  if (overlayEntry.mounted) {
    overlayEntry.remove();
  }
}

class _LiquidGlassSnackbar extends StatefulWidget {
  const _LiquidGlassSnackbar({
    required this.message,
    required this.iconName,
    required this.iconColor,
    required this.onDismiss,
    required this.animationDuration,
  });

  final String message;
  final String iconName;
  final Color iconColor;
  final VoidCallback onDismiss;
  final Duration animationDuration;

  @override
  State<_LiquidGlassSnackbar> createState() => _LiquidGlassSnackbarState();
}

class _LiquidGlassSnackbarState extends State<_LiquidGlassSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CNGlassEffectContainer(
                glassStyle: CNGlassStyle.regular,
                cornerRadius: 16,
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Leading icon (message status)
                      CNIcon(
                        symbol: CNSymbol(
                          widget.iconName,
                          size: 24,
                          color: widget.iconColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Message text
                      Expanded(
                        child: Text(
                          widget.message,
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Close button
                      CupertinoIconButton(
                        iconName: 'xmark.circle.fill',
                        iconSize: 20,
                        iconColor: FlutterFlowTheme.of(context).secondaryText,
                        buttonSize: 32,
                        onPressed: _dismiss,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
