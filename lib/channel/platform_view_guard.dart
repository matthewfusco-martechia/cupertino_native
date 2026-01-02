import 'package:flutter/widgets.dart';
import 'platform_view_metrics.dart';

/// Mixin to prevent unnecessary platform view recreation.
///
/// Use this in StatefulWidget states that host UiKitView/AppKitView.
/// The mixin computes a configuration signature and only triggers
/// native view recreation when the signature changes.
mixin PlatformViewGuard<T extends StatefulWidget> on State<T> {
  /// The cached platform view widget (null until first build).
  Widget? _cachedPlatformView;
  
  /// The last computed config signature.
  String? _lastConfigSignature;
  
  /// Unique stable key for this platform view instance.
  late final GlobalKey _platformViewKey = GlobalKey(debugLabel: 'CN_$hashCode');
  
  /// Get the stable key for the platform view.
  Key get platformViewKey => _platformViewKey;
  
  /// Compute a signature from the creation params that matter for identity.
  /// Override this to return a string that changes when the native view
  /// needs to be recreated.
  String computeConfigSignature();
  
  /// Build the actual platform view widget (UiKitView/AppKitView).
  Widget buildPlatformView();
  
  /// Check if rebuild should recreate the platform view.
  bool shouldRecreatePlatformView() {
    final newSignature = computeConfigSignature();
    if (_lastConfigSignature == newSignature && _cachedPlatformView != null) {
      PlatformViewMetrics.recordRebuildSkipped(T.toString());
      return false;
    }
    _lastConfigSignature = newSignature;
    return true;
  }
  
  /// Get the platform view, using cache if unchanged.
  Widget getPlatformViewCached(String viewType) {
    if (shouldRecreatePlatformView()) {
      PlatformViewMetrics.recordCreation(viewType);
      _cachedPlatformView = KeyedSubtree(
        key: _platformViewKey,
        child: buildPlatformView(),
      );
    }
    return _cachedPlatformView!;
  }
}
