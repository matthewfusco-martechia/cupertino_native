import Flutter
import UIKit

/// A Liquid Glass segmented control using native UITabBar for iOS 18+ liquid glass styling.
/// Provides a pill-shaped segmented control with the native selection indicator.
class CupertinoLiquidGlassSegmentedControlPlatformView: NSObject, FlutterPlatformView, UITabBarDelegate {
  private let channel: FlutterMethodChannel
  private let container: UIView
  private var tabBar: UITabBar?
  private var labels: [String] = []
  private var symbols: [String] = []
  private var selectedIndex: Int = 0
  private var tintColor: UIColor?
  
  init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
    self.channel = FlutterMethodChannel(name: "CupertinoNativeLiquidGlassSegmentedControl_\(viewId)", binaryMessenger: messenger)
    self.container = UIView(frame: frame)
    
    super.init()
    
    // Parse args
    if let dict = args as? [String: Any] {
      if let arr = dict["labels"] as? [String] { labels = arr }
      if let arr = dict["sfSymbols"] as? [String] { symbols = arr }
      if let v = dict["selectedIndex"] as? NSNumber { selectedIndex = v.intValue }
      if let style = dict["style"] as? [String: Any] {
        if let n = style["tint"] as? NSNumber { tintColor = Self.colorFromARGB(n.intValue) }
      }
    }
    
    container.backgroundColor = .clear
    
    // Apply dark/light mode
    var isDark = true
    if let dict = args as? [String: Any] {
      if let v = dict["isDark"] as? NSNumber { isDark = v.boolValue }
    }
    if #available(iOS 13.0, *) {
      container.overrideUserInterfaceStyle = isDark ? .dark : .light
    }
    
    setupTabBar()
    setupGestures()
    setupChannel()
  }
  
  func view() -> UIView { container }
  
  // MARK: - Setup
  
  private func setupTabBar() {
    let bar = UITabBar(frame: .zero)
    self.tabBar = bar
    bar.delegate = self
    bar.translatesAutoresizingMaskIntoConstraints = false
    
    // Apply tint color
    if let tint = tintColor {
      bar.tintColor = tint
    }
    
    // Configure appearance for liquid glass
    if #available(iOS 13.0, *) {
      let appearance = UITabBarAppearance()
      appearance.configureWithDefaultBackground() // This gives liquid glass on iOS 18+
      
      // Remove shadow for cleaner look
      appearance.shadowImage = nil
      appearance.shadowColor = .clear
      
      // Font styling
      let normalAttrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 11, weight: .medium)
      ]
      let selectedAttrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 11, weight: .medium)
      ]
      
      appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs
      appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs
      appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
      appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
      
      appearance.stackedItemPositioning = .centered
      
      bar.standardAppearance = appearance
      if #available(iOS 15.0, *) {
        bar.scrollEdgeAppearance = appearance
      }
    }
    
    // Build tab bar items
    var items: [UITabBarItem] = []
    let count = max(labels.count, symbols.count)
    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
    
    for i in 0..<count {
      let title = (i < labels.count) ? labels[i] : nil
      var image: UIImage? = nil
      
      if i < symbols.count && !symbols[i].isEmpty {
        image = UIImage(systemName: symbols[i], withConfiguration: symbolConfig)
      }
      
      let item = UITabBarItem(title: title, image: image, selectedImage: image)
      
      // Adjust icon position slightly for better centering
      item.imageInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
      
      items.append(item)
    }
    
    bar.items = items
    
    // Set initial selection
    if let barItems = bar.items, selectedIndex >= 0, selectedIndex < barItems.count {
      bar.selectedItem = barItems[selectedIndex]
    }
    
    // Pill shape styling
    bar.layer.cornerRadius = 28
    bar.clipsToBounds = true
    if #available(iOS 13.0, *) {
      bar.layer.cornerCurve = .continuous
    }
    
    container.addSubview(bar)
    
    // Layout with small inset
    NSLayoutConstraint.activate([
      bar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 2),
      bar.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -2),
      bar.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
      bar.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2)
    ])
  }
  
  private func setupGestures() {
    // Pan gesture for sliding between segments
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    container.addGestureRecognizer(panGesture)
  }
  
  private func setupChannel() {
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { result(nil); return }
      
      switch call.method {
      case "getIntrinsicSize":
        if let bar = self.tabBar, let items = bar.items {
          // Calculate width: ~120pt per item minimum
          let minWidth = CGFloat(items.count * 120)
          result(["width": Double(minWidth + 20), "height": 90.0])
        } else {
          result(["width": 260.0, "height": 90.0])
        }
        
      case "setSelectedIndex":
        if let args = call.arguments as? [String: Any], let idx = (args["index"] as? NSNumber)?.intValue {
          if let bar = self.tabBar, let items = bar.items, idx >= 0, idx < items.count {
            bar.selectedItem = items[idx]
            self.selectedIndex = idx
          }
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing index", details: nil))
        }
        
      case "setStyle":
        if let args = call.arguments as? [String: Any] {
          if let n = args["tint"] as? NSNumber {
            let color = Self.colorFromARGB(n.intValue)
            self.tintColor = color
            self.tabBar?.tintColor = color
          }
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing style", details: nil))
        }
        
      case "setBrightness":
        if let args = call.arguments as? [String: Any], let isDark = (args["isDark"] as? NSNumber)?.boolValue {
          if #available(iOS 13.0, *) {
            self.container.overrideUserInterfaceStyle = isDark ? .dark : .light
          }
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing isDark", details: nil))
        }
        
      default:
        result(nil)
      }
    }
  }
  
  // MARK: - UITabBarDelegate
  
  func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if let items = tabBar.items, let index = items.firstIndex(of: item) {
      selectedIndex = index
      channel.invokeMethod("valueChanged", arguments: ["index": index])
    }
  }
  
  // MARK: - Pan Gesture
  
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    guard gesture.state == .changed || gesture.state == .ended else { return }
    
    guard let bar = tabBar, let items = bar.items, items.count > 0 else { return }
    
    let location = gesture.location(in: container)
    let itemWidth = container.bounds.width / CGFloat(items.count)
    var newIndex = Int(location.x / itemWidth)
    newIndex = max(0, min(newIndex, items.count - 1))
    
    if bar.selectedItem != items[newIndex] {
      bar.selectedItem = items[newIndex]
      selectedIndex = newIndex
      
      // Haptic feedback
      if #available(iOS 10.0, *) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
      }
      
      channel.invokeMethod("valueChanged", arguments: ["index": newIndex])
    }
  }
  
  // MARK: - Helpers
  
  private static func colorFromARGB(_ argb: Int) -> UIColor {
    let a = CGFloat((argb >> 24) & 0xFF) / 255.0
    let r = CGFloat((argb >> 16) & 0xFF) / 255.0
    let g = CGFloat((argb >> 8) & 0xFF) / 255.0
    let b = CGFloat(argb & 0xFF) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
}
