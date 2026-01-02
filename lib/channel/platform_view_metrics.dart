import 'package:flutter/foundation.dart';
import '../cupertino_native_config.dart';

/// Platform view lifecycle metrics (debug only).
class PlatformViewMetrics {
  static int _creations = 0;
  static int _disposals = 0;
  static int _rebuildsSaved = 0;
  
  static void recordCreation(String viewType) {
    if (kDebugMode) {
      _creations++;
      if (CupertinoNativeConfig.debugMetrics) {
        debugPrint('[CN Metrics] Created $viewType (total: $_creations)');
      }
    }
  }
  
  static void recordDisposal(String viewType) {
    if (kDebugMode) {
      _disposals++;
      if (CupertinoNativeConfig.debugMetrics) {
        debugPrint('[CN Metrics] Disposed $viewType (total: $_disposals)');
      }
    }
  }
  
  static void recordRebuildSkipped(String viewType) {
    if (kDebugMode) {
      _rebuildsSaved++;
      if (CupertinoNativeConfig.debugMetrics) {
        debugPrint('[CN Metrics] Rebuild skipped for $viewType (saved: $_rebuildsSaved)');
      }
    }
  }
  
  /// Get current metrics (debug only).
  static Map<String, int> get metrics => {
    'creations': _creations,
    'disposals': _disposals,
    'rebuildsSaved': _rebuildsSaved,
  };
  
  /// Reset all counters.
  static void reset() {
    _creations = 0;
    _disposals = 0;
    _rebuildsSaved = 0;
  }
}
