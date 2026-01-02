/// Global configuration for cupertino_native package.
class CupertinoNativeConfig {
  CupertinoNativeConfig._();
  
  /// Kill-switch: set to false to disable all platform views.
  /// Falls back to Flutter implementations when disabled.
  static bool platformViewsEnabled = true;
  
  /// Enable debug instrumentation (only active in debug mode).
  static bool debugMetrics = false;
}
