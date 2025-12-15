import Flutter
import UIKit

/// Utility for configuring UIVisualEffectView to work correctly with Flutter overlays.
///
/// The compositing issue occurs when UIVisualEffectView (used for liquid glass)
/// is present and Flutter overlays (bottom sheets, modals) are stacked.
/// The native view can "punch through" Flutter's overlay content.
///
/// This utility configures the view layers to minimize z-ordering conflicts
/// with Flutter's compositing system.
enum PlatformViewLayerConfiguration {
  
  /// Configures a UIVisualEffectView for proper compositing with Flutter overlays.
  ///
  /// UIVisualEffectView has special compositing behavior that can interfere with
  /// Flutter's layer tree when overlays stack. This applies configuration
  /// to prevent visual effect views from occluding Flutter text layers.
  ///
  /// - Parameter visualEffectView: The UIVisualEffectView to configure
  /// - Parameter cornerRadius: Optional corner radius to apply
  static func configureVisualEffectView(_ visualEffectView: UIVisualEffectView, cornerRadius: CGFloat = 0) {
    let layer = visualEffectView.layer
    
    // Clip to bounds for proper corner radius
    visualEffectView.clipsToBounds = true
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = true
    
    // Visual effect views must not be opaque for proper compositing
    visualEffectView.isOpaque = false
    layer.isOpaque = false
    
    // CRITICAL: shouldRasterize = false ensures real-time compositing
    // This prevents stale rendering when Flutter overlays change
    layer.shouldRasterize = false
    
    // CRITICAL: Set negative zPosition to ensure the platform view
    // renders BELOW Flutter overlay layers in the compositing hierarchy.
    // This helps prevent the visual effect view from "punching through"
    // Flutter content rendered above it.
    layer.zPosition = -1
    
    // Allow group opacity for proper alpha blending with Flutter layers
    layer.allowsGroupOpacity = true
    
    // Clear background to avoid solid colors interfering with compositing
    visualEffectView.backgroundColor = .clear
    
    // Also configure the content view
    let contentView = visualEffectView.contentView
    contentView.layer.allowsGroupOpacity = true
    contentView.layer.masksToBounds = true
    contentView.isOpaque = false
  }
  
  /// Configures a container view's layer for proper platform view compositing.
  /// Use this for the outer container that holds the UIVisualEffectView.
  ///
  /// - Parameter container: The container UIView
  static func configureContainer(_ container: UIView) {
    container.backgroundColor = .clear
    container.isOpaque = false
    container.layer.isOpaque = false
    container.layer.zPosition = -1
    container.layer.allowsGroupOpacity = true
  }
}

// MARK: - UIVisualEffectView Extension

extension UIVisualEffectView {
  /// Configures this visual effect view for Flutter platform view compositing.
  func configureForFlutterVisualEffects(cornerRadius: CGFloat = 0) {
    PlatformViewLayerConfiguration.configureVisualEffectView(self, cornerRadius: cornerRadius)
  }
}

// MARK: - UIView Extension

extension UIView {
  /// Configures this view as a platform view container for Flutter compositing.
  func configureAsFlutterPlatformViewContainer() {
    PlatformViewLayerConfiguration.configureContainer(self)
  }
}
