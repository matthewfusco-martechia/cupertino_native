import Flutter
import UIKit

/// Minimal utility for configuring UIVisualEffectView to work correctly with Flutter overlays.
///
/// The compositing issue occurs specifically with UIVisualEffectView (used for liquid glass)
/// when Flutter overlays are stacked. This utility provides targeted configuration
/// ONLY for visual effect views - not general containers.
enum PlatformViewLayerConfiguration {
  
  /// Configures a UIVisualEffectView for proper compositing with Flutter overlays.
  ///
  /// UIVisualEffectView has special compositing behavior that can interfere with
  /// Flutter's layer tree when overlays stack. This applies minimal configuration
  /// to prevent visual effect views from occluding Flutter text layers.
  ///
  /// - Parameter visualEffectView: The UIVisualEffectView to configure
  /// - Parameter cornerRadius: Optional corner radius to apply
  static func configureVisualEffectView(_ visualEffectView: UIVisualEffectView, cornerRadius: CGFloat = 0) {
    // Clip to bounds for proper corner radius
    visualEffectView.clipsToBounds = true
    visualEffectView.layer.cornerRadius = cornerRadius
    
    // Visual effect views should not be opaque
    visualEffectView.isOpaque = false
    visualEffectView.layer.isOpaque = false
    
    // CRITICAL: shouldRasterize = false ensures real-time compositing
    // This prevents stale rendering when Flutter overlays change
    visualEffectView.layer.shouldRasterize = false
  }
}

// MARK: - UIVisualEffectView Extension

extension UIVisualEffectView {
  /// Configures this visual effect view for Flutter platform view compositing.
  func configureForFlutterVisualEffects(cornerRadius: CGFloat = 0) {
    PlatformViewLayerConfiguration.configureVisualEffectView(self, cornerRadius: cornerRadius)
  }
}
