import Flutter
import UIKit

/// Reverted transparency and custom view attempts.
/// using strictly native UITabBar with corner radius and precise layout adjustments
/// to match the "Liquid Glass" demo while fixing text clipping.
class CupertinoLiquidGlassSegmentedControlPlatformView: NSObject, FlutterPlatformView, UITabBarDelegate, UIGestureRecognizerDelegate {
  private let channel: FlutterMethodChannel
  private let container: UIView
  private var tabBar: UITabBar?
  private var labels: [String] = []
  private var symbols: [String] = []
  private var tintColor: UIColor?
  
  init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
    self.channel = FlutterMethodChannel(name: "CupertinoNativeLiquidGlassSegmentedControl_\(viewId)", binaryMessenger: messenger)
    self.container = UIView(frame: frame)
    
    super.init()
    
    // Parse args
    if let dict = args as? [String: Any] {
      if let arr = dict["labels"] as? [String] { labels = arr }
      if let arr = dict["sfSymbols"] as? [String] { symbols = arr }
    }

    container.backgroundColor = .clear
    
    // Apply styling
    var isDark = true
    var selectedIndex = 0
    var tint: UIColor? = nil
    
    if let dict = args as? [String: Any] {
        if let v = dict["isDark"] as? NSNumber { isDark = v.boolValue }
        if let v = dict["selectedIndex"] as? NSNumber { selectedIndex = v.intValue }
        if let style = dict["style"] as? [String: Any] {
            if let n = style["tint"] as? NSNumber { tint = Self.colorFromARGB(n.intValue) }
        }
    }
    
    if #available(iOS 13.0, *) {
        container.overrideUserInterfaceStyle = isDark ? .dark : .light
    }
    
    // Create Background View (Decoupled from Bar for correct glass look)
    if #available(iOS 13.0, *) {
        let effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let bg = UIVisualEffectView(effect: effect)
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.layer.cornerRadius = 25
        bg.layer.cornerCurve = .continuous
        bg.clipsToBounds = true
        container.addSubview(bg)
        
        NSLayoutConstraint.activate([
            bg.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 2),
            bg.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -2),
            bg.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            bg.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2)
        ])
    }
    
    let bar = UITabBar(frame: .zero)
    self.tabBar = bar
    bar.delegate = self
    bar.translatesAutoresizingMaskIntoConstraints = false
    
    if #available(iOS 10.0, *), let tint = tint { bar.tintColor = tint }
    
    if #available(iOS 13.0, *) {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground() // Transparent to show decoupled background
        
        // Remove shadow for cleaner look
        appearance.shadowImage = nil
        appearance.shadowColor = .clear
        
        // Layout Strategy: Balanced centering
        let offset = UIOffset(horizontal: 0, vertical: 0)
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        
        // Font 11pt Medium
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .medium)]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .medium)]
        
        appearance.stackedItemPositioning = .fill

        bar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            bar.scrollEdgeAppearance = appearance
        }
    }
    
    // Build Items
    var items: [UITabBarItem] = []
    let count = max(labels.count, symbols.count)
    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
    
    for i in 0..<count {
        var image: UIImage? = nil
        if i < symbols.count { 
            image = UIImage(systemName: symbols[i], withConfiguration: symbolConfig)
        }
        let title = (i < labels.count) ? labels[i] : nil
        let item = UITabBarItem(title: title, image: image, selectedImage: image)
        
        // Moderate offset to center icon (-2) without pushing it too high
        item.imageInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
        
        items.append(item)
    }
    bar.items = items
    if let items = bar.items, selectedIndex >= 0, selectedIndex < items.count {
        bar.selectedItem = items[selectedIndex]
    }
    
    // Note: We deliberately do NOT set cornerRadius or clipsToBounds on the bar itself,
    // so that the selection indicator (bubble) can overflow effectively.
    
    container.addSubview(bar)
    
    // Layout: Inset by 2pt for safety margin
    NSLayoutConstraint.activate([
        bar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 2),
        bar.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -2),
        bar.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
        bar.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2)
    ])
    
    // Add Pan Gesture
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    panGesture.delegate = self
    panGesture.cancelsTouchesInView = false
    container.addGestureRecognizer(panGesture)
    
    // Add Tap Gesture (Explicit handling to ensure responsiveness)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    tapGesture.cancelsTouchesInView = false
    container.addGestureRecognizer(tapGesture)

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { result(nil); return }
      switch call.method {
      case "getIntrinsicSize":
          if let bar = self.tabBar, let items = bar.items {
              let size = bar.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
              // 120pt width per item
              let minWidth = CGFloat(items.count * 120)
              let finalWidth = max(size.width, minWidth)
              // 90pt height
              result(["width": Double(finalWidth + 20), "height": Double(max(size.height, 90.0))])
          } else {
              result(["width": 240.0, "height": 90.0])
          }
      case "setSelectedIndex":
        if let args = call.arguments as? [String: Any], let idx = (args["index"] as? NSNumber)?.intValue {
            if let bar = self.tabBar, let items = bar.items, idx >= 0, idx < items.count {
                bar.selectedItem = items[idx]
            }
            result(nil)
        } else { result(FlutterError(code: "bad_args", message: "Missing index", details: nil)) }
      case "setStyle":
        if let args = call.arguments as? [String: Any] {
           if let n = args["tint"] as? NSNumber {
               let c = Self.colorFromARGB(n.intValue)
               if let bar = self.tabBar { bar.tintColor = c }
           }
           result(nil)
        } else { result(FlutterError(code: "bad_args", message: "Missing style", details: nil)) }
      case "setBrightness":
        if let args = call.arguments as? [String: Any], let isDark = (args["isDark"] as? NSNumber)?.boolValue {
            if #available(iOS 13.0, *) {
                self.container.overrideUserInterfaceStyle = isDark ? .dark : .light
            }
            result(nil)
        } else { result(FlutterError(code: "bad_args", message: "Missing isDark", details: nil)) }
      default:
        result(nil)
      }
    }
  }

  func view() -> UIView { container }
  
  // Delegate
  func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
      if let items = tabBar.items, let index = items.firstIndex(of: item) {
          channel.invokeMethod("valueChanged", arguments: ["index": index])
      }
  }

  // UIGestureRecognizerDelegate
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      if let pan = gestureRecognizer as? UIPanGestureRecognizer {
          let velocity = pan.velocity(in: container)
          // Allow if zero (start) or horizontal
          return velocity == .zero || abs(velocity.x) >= abs(velocity.y)
      }
      return true
  }
  
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      // Return false to prevent the BottomSheet/ScrollView from scrolling while we are dragging this slider
      return false 
  }

  // Tap Gesture
  @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: container)
    updateSelection(at: location)
  }

  // Pan Gesture
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    guard gesture.state == .changed || gesture.state == .ended else { return }
    let location = gesture.location(in: container)
    updateSelection(at: location)
  }

  private func updateSelection(at location: CGPoint) {
    if let bar = tabBar, let items = bar.items, items.count > 0 {
      let itemWidth = container.bounds.width / CGFloat(items.count)
      var newIdx = Int(location.x / itemWidth)
      newIdx = max(0, min(newIdx, items.count - 1))
      
      if bar.selectedItem != items[newIdx] {
        bar.selectedItem = items[newIdx]
        
        if #available(iOS 10.0, *) {
             let generator = UISelectionFeedbackGenerator()
             generator.selectionChanged()
        }
        
        channel.invokeMethod("valueChanged", arguments: ["index": newIdx])
      }
    }
  }

  private static func colorFromARGB(_ argb: Int) -> UIColor {
    let a = CGFloat((argb >> 24) & 0xFF) / 255.0
    let r = CGFloat((argb >> 16) & 0xFF) / 255.0
    let g = CGFloat((argb >> 8) & 0xFF) / 255.0
    let b = CGFloat(argb & 0xFF) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
}

