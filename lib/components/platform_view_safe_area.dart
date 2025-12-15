import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show showModalBottomSheet, showDialog;

/// A widget that creates an opaque compositing barrier above platform views.
///
/// When Flutter platform views (native iOS/macOS views) are present, overlays
/// like bottom sheets can have compositing issues where text fails to render.
/// This widget forces Flutter to create a separate compositing layer using
/// multiple aggressive techniques.
///
/// Use this widget to wrap bottom sheet or dialog content:
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
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled ||
        !(defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      return child;
    }

    // AGGRESSIVE COMPOSITING: Use Opacity trick to force separate layer
    // Opacity < 1.0 forces Flutter to create a separate compositing layer
    // 0.9999 is visually imperceptible but forces layer separation
    return RepaintBoundary(
      child: Opacity(
        opacity: 0.9999,
        child: child,
      ),
    );
  }
}

/// A more aggressive barrier that ensures content renders above platform views.
///
/// Use this when [PlatformViewSafeArea] alone doesn't work. This creates
/// multiple compositing boundaries to ensure proper z-ordering.
class PlatformViewBarrier extends StatelessWidget {
  /// Creates a platform view barrier.
  const PlatformViewBarrier({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  /// The child widget.
  final Widget child;

  /// Optional background color for the barrier.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS)) {
      return child;
    }

    Widget content = child;

    // Add background if specified - creates an opaque paint layer
    if (backgroundColor != null) {
      content = ColoredBox(
        color: backgroundColor!,
        child: content,
      );
    }

    // Use multiple techniques to absolutely force layer separation:
    // 1. Outer RepaintBoundary - creates raster cache boundary
    // 2. Opacity < 1.0 - forces separate compositing layer
    // 3. Inner RepaintBoundary - additional isolation
    return RepaintBoundary(
      child: Opacity(
        opacity: 0.9999,
        child: RepaintBoundary(
          child: content,
        ),
      ),
    );
  }
}

/// Widget that wraps entire bottom sheet content to fix platform view compositing.
///
/// This wrapper uses the most aggressive compositing techniques available
/// to ensure bottom sheet content (especially text/titles) renders correctly
/// when platform views are present in the background.
class BottomSheetPlatformFix extends StatelessWidget {
  /// Creates a bottom sheet platform fix wrapper.
  const BottomSheetPlatformFix({
    super.key,
    required this.child,
  });

  /// The bottom sheet content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS)) {
      return child;
    }

    // For bottom sheets specifically, we need to ensure the ENTIRE sheet
    // including the drag handle and title bar is on its own layer.
    //
    // We use:
    // 1. RepaintBoundary - isolates painting
    // 2. Opacity(0.9999) - forces Flutter to create a new compositing surface
    // 3. ClipRect - creates a clip layer that further isolates compositing
    return RepaintBoundary(
      child: ClipRect(
        child: Opacity(
          opacity: 0.9999,
          child: child,
        ),
      ),
    );
  }
}

/// Extension on BuildContext to easily show platform-view-safe overlays.
extension PlatformViewSafeOverlays on BuildContext {
  /// Shows a modal bottom sheet that renders correctly above platform views.
  ///
  /// This wrapper ensures the sheet content is composited on a separate layer,
  /// fixing text rendering issues when native platform views are present.
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
      builder: (context) => BottomSheetPlatformFix(
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
      builder: (context) => BottomSheetPlatformFix(
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
      builder: (context) => PlatformViewBarrier(
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
