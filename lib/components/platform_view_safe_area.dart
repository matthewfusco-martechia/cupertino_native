import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show showModalBottomSheet, showDialog;

/// A widget that ensures its child renders correctly above platform views.
///
/// When Flutter platform views (native iOS/macOS views) are present, overlays
/// like bottom sheets, modals, and dialogs can have compositing issues where
/// text fails to render. This widget forces Flutter to create a separate
/// compositing layer that properly renders above platform views.
///
/// Use this widget to wrap any overlay content that needs to appear above
/// native platform views:
///
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (context) => PlatformViewSafeArea(
///     child: YourSheetContent(),
///   ),
/// );
/// ```
class PlatformViewSafeArea extends StatelessWidget {
  /// Creates a platform view safe area.
  const PlatformViewSafeArea({
    super.key,
    required this.child,
    this.enabled = true,
  });

  /// The child widget to render safely above platform views.
  final Widget child;

  /// Whether the safe area compositing is enabled.
  /// Set to false to disable the compositing layer (useful for debugging).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // Only apply on iOS where platform view compositing is an issue
    if (!enabled ||
        !(defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      return child;
    }

    // Force a separate compositing layer using multiple techniques:
    // 1. RepaintBoundary - creates a separate layer for caching
    // 2. Transform.identity - forces the layer to be composited separately
    // 3. The combination ensures Flutter creates a new surface above platform views
    return RepaintBoundary(
      child: Transform(
        transform: Matrix4.identity(),
        // transformHitTests: false ensures touch events pass through correctly
        transformHitTests: false,
        child: child,
      ),
    );
  }
}

/// A widget that wraps overlay content to ensure proper rendering above platform views.
///
/// This is a more aggressive version of [PlatformViewSafeArea] that uses
/// additional techniques to force proper compositing. Use this if
/// [PlatformViewSafeArea] alone doesn't resolve the rendering issues.
class PlatformViewOverlay extends StatelessWidget {
  /// Creates a platform view overlay wrapper.
  const PlatformViewOverlay({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  /// The child widget to render safely above platform views.
  final Widget child;

  /// Optional background color. If provided, creates an additional
  /// compositing boundary.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    // Only apply on iOS/macOS where platform view compositing is an issue
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS)) {
      return child;
    }

    Widget content = child;

    // Wrap in ColoredBox if background is provided - this creates a paint boundary
    if (backgroundColor != null) {
      content = ColoredBox(
        color: backgroundColor!,
        child: content,
      );
    }

    // Use a CompositedTransformFollower-like approach with Transform
    // This forces Flutter to composite the content on a separate layer
    return RepaintBoundary(
      child: Builder(
        builder: (context) {
          return Transform(
            transform: Matrix4.identity(),
            transformHitTests: false,
            child: RepaintBoundary(
              child: content,
            ),
          );
        },
      ),
    );
  }
}

/// Extension on BuildContext to easily show platform-view-safe overlays.
extension PlatformViewSafeOverlays on BuildContext {
  /// Shows a modal bottom sheet that renders correctly above platform views.
  ///
  /// This is a wrapper around [showModalBottomSheet] that ensures the sheet
  /// content renders properly when native platform views are present.
  Future<T?> showPlatformSafeBottomSheet<T>({
    required WidgetBuilder builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: (context) => PlatformViewSafeArea(
        child: builder(context),
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
    );
  }

  /// Shows a Cupertino modal popup that renders correctly above platform views.
  Future<T?> showPlatformSafeCupertinoModalPopup<T>({
    required WidgetBuilder builder,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) {
    return showCupertinoModalPopup<T>(
      context: this,
      builder: (context) => PlatformViewSafeArea(
        child: builder(context),
      ),
      filter: filter,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      semanticsDismissible: semanticsDismissible ?? barrierDismissible,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
    );
  }

  /// Shows a dialog that renders correctly above platform views.
  Future<T?> showPlatformSafeDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => PlatformViewSafeArea(
        child: builder(context),
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );
  }
}
