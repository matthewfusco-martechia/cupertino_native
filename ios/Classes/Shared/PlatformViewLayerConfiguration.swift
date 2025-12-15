import Flutter
import UIKit

/// Utility for configuring platform view layers to work correctly with Flutter's compositing.
///
/// When Flutter platform views are used with overlays (bottom sheets, modals, dialogs),
/// there can be compositing conflicts where native UIKit views punch through or occlude
/// Flutter's text rendering layer. This utility provides proper layer configuration
/// to isolate native views into their own compositing group.
///
/// ## The Problem
/// - UIKit platform views are composited outside Flutter's Skia layer
/// - When overlays stack, z-order and compositing boundaries can break
/// - Native views (especially UIVisualEffectView) appear to punch through Flutter text layers
///
/// ## The Solution
/// - Configure CALayer properties to create proper compositing isolation
/// - Set allowsGroupOpacity to handle transparency correctly
/// - Configure shouldRasterize appropriately for complex views
/// - Ensure proper clipping and masking for visual effects
enum PlatformViewLayerConfiguration {
  
  /// Configures a container view's layer for proper compositing with Flutter overlays.
  ///
  /// Call this on the container UIView that wraps your platform view content.
  /// This ensures the native view properly participates in Flutter's compositing
  /// without causing z-ordering issues in overlays.
  ///
  /// - Parameter view: The container UIView to configure
  /// - Parameter isTransparent: Whether the view has transparent content (default: true)
  static func configureForFlutterCompositing(_ view: UIView, isTransparent: Bool = true) {
    let layer = view.layer
    
    // CRITICAL: allowsGroupOpacity ensures child layers are composited together
    // before being blended with the background. This prevents visual artifacts
    // when transparent views overlap with Flutter content.
    layer.allowsGroupOpacity = true
    
    // Set isOpaque = false for transparent views to ensure proper alpha blending
    // with Flutter layers beneath. Setting this wrong causes compositing artifacts.
    view.isOpaque = !isTransparent
    layer.isOpaque = !isTransparent
    
    // masksToBounds clips child layers to the view's bounds.
    // Essential for rounded corners and preventing content from bleeding outside.
    layer.masksToBounds = true
    
    // backgroundColor should be nil for transparent views to avoid
    // compositing issues where a solid color punches through Flutter content.
    if isTransparent {
      view.backgroundColor = .clear
      layer.backgroundColor = nil
    }
    
    // Disable implicit animations that could cause visual glitches during
    // Flutter's rapid frame updates.
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    // Force the layer to participate in the compositing hierarchy correctly.
    // This can help with z-ordering issues.
    layer.zPosition = 0
    
    CATransaction.commit()
  }
  
  /// Configures a UIVisualEffectView for proper compositing with Flutter overlays.
  ///
  /// UIVisualEffectView has special compositing behavior that can interfere with
  /// Flutter's layer tree. This method applies specific configurations to make
  /// visual effect views play nicely with Flutter overlays.
  ///
  /// - Parameter visualEffectView: The UIVisualEffectView to configure
  /// - Parameter cornerRadius: Optional corner radius to apply
  static func configureVisualEffectView(_ visualEffectView: UIVisualEffectView, cornerRadius: CGFloat = 0) {
    let layer = visualEffectView.layer
    
    // Clip to bounds is essential for visual effect views to prevent
    // the blur from bleeding outside the intended area.
    visualEffectView.clipsToBounds = true
    layer.masksToBounds = true
    
    // Apply corner radius to the layer, not just clipsToBounds
    layer.cornerRadius = cornerRadius
    
    // Allow group opacity for proper compositing with Flutter layers
    layer.allowsGroupOpacity = true
    
    // Visual effect views should never be opaque
    visualEffectView.isOpaque = false
    layer.isOpaque = false
    
    // CRITICAL for iOS compositing with Flutter:
    // Setting shouldRasterize = false ensures the visual effect view
    // is composited in real-time rather than as a cached bitmap.
    // This prevents stale rendering when overlays change.
    layer.shouldRasterize = false
    
    // Ensure the visual effect view doesn't have a solid background color
    // that could interfere with transparency
    visualEffectView.backgroundColor = .clear
    
    // Configure the content view similarly
    let contentView = visualEffectView.contentView
    contentView.layer.allowsGroupOpacity = true
    contentView.layer.masksToBounds = true
    contentView.isOpaque = false
  }
  
  /// Configures a view that will contain interactive elements like text fields or buttons.
  ///
  /// Interactive views need specific configuration to ensure they receive touch events
  /// properly while still compositing correctly with Flutter overlays.
  ///
  /// - Parameter view: The interactive view to configure
  static func configureInteractiveView(_ view: UIView) {
    configureForFlutterCompositing(view, isTransparent: true)
    
    // Interactive views should allow user interaction to pass through
    // to the native layer
    view.isUserInteractionEnabled = true
    
    // Ensure the view isn't hidden or disabled unintentionally
    view.isHidden = false
    view.alpha = 1.0
    
    // For text input views specifically, ensure they can become first responder
    if view is UITextView || view is UITextField {
      // Text views need to be able to handle input
      view.layer.allowsGroupOpacity = true
    }
  }
  
  /// Creates a container view pre-configured for Flutter platform view compositing.
  ///
  /// Use this to create the root container for your platform view instead of
  /// creating a plain UIView.
  ///
  /// - Parameter frame: The frame for the container view
  /// - Returns: A properly configured UIView for use as a platform view container
  static func createCompositingContainer(frame: CGRect = .zero) -> UIView {
    let container = UIView(frame: frame)
    configureForFlutterCompositing(container, isTransparent: true)
    return container
  }
  
  /// Applies configuration to ensure a layer hierarchy renders above Flutter text.
  ///
  /// When native views need to explicitly render above Flutter content,
  /// this method ensures the layer tree is set up correctly.
  ///
  /// Note: This doesn't change z-position relative to Flutter's overlay system;
  /// it ensures the view's internal layer hierarchy is correct.
  ///
  /// - Parameter view: The view to configure for overlay rendering
  static func configureForOverlayRendering(_ view: UIView) {
    configureForFlutterCompositing(view, isTransparent: true)
    
    // Additional configuration for views that need to render in overlays
    let layer = view.layer
    
    // Ensure the layer uses the correct blend mode
    // by setting compositing filter to nil (use default)
    layer.compositingFilter = nil
    
    // Force the layer to be in the correct position in the hierarchy
    layer.zPosition = 0
    
    // Apply to all sublayers as well
    layer.sublayers?.forEach { sublayer in
      sublayer.allowsGroupOpacity = true
      sublayer.zPosition = 0
    }
  }
}

// MARK: - UIView Extension for Easy Configuration

extension UIView {
  /// Configures this view for Flutter platform view compositing.
  ///
  /// Call this on container views used in FlutterPlatformView implementations.
  func configureForFlutterCompositing(isTransparent: Bool = true) {
    PlatformViewLayerConfiguration.configureForFlutterCompositing(self, isTransparent: isTransparent)
  }
  
  /// Recursively configures this view and all subviews for Flutter compositing.
  ///
  /// Use this when you have a complex view hierarchy that all needs
  /// proper compositing configuration.
  func configureHierarchyForFlutterCompositing() {
    configureForFlutterCompositing(isTransparent: true)
    for subview in subviews {
      subview.configureHierarchyForFlutterCompositing()
    }
  }
}

// MARK: - UIVisualEffectView Extension

extension UIVisualEffectView {
  /// Configures this visual effect view for Flutter platform view compositing.
  ///
  /// Visual effect views (blur, vibrancy, glass effects) have special compositing
  /// behavior that can cause issues with Flutter overlays. This method applies
  /// the necessary configuration to prevent those issues.
  func configureForFlutterVisualEffects(cornerRadius: CGFloat = 0) {
    PlatformViewLayerConfiguration.configureVisualEffectView(self, cornerRadius: cornerRadius)
  }
}

