import Flutter
import UIKit

/// Liquid Glass Segmented Control with custom glass selection bubble.
class CupertinoLiquidGlassSegmentedControlPlatformView: NSObject, FlutterPlatformView, UITabBarDelegate {
  private let channel: FlutterMethodChannel
  private let container: UIView
  private var tabBar: UITabBar?
  private var selectionBubble: UIVisualEffectView?
  private var selectionBubbleLeading: NSLayoutConstraint?
  private var labels: [String] = []
  private var symbols: [String] = []
  private var tintColor: UIColor?
  private var itemCount: Int = 2
  private var currentIndex: Int = 0
  
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
    
    itemCount = max(labels.count, symbols.count)
    currentIndex = selectedIndex
    
    // === 1. Background Glass Pill ===
    if #available(iOS 13.0, *) {
        let bgEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let bg = UIVisualEffectView(effect: bgEffect)
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
    
    // === 2. Selection Bubble (Glass) ===
    if #available(iOS 13.0, *) {
        let selEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let sel = UIVisualEffectView(effect: selEffect)
        sel.translatesAutoresizingMaskIntoConstraints = false
        sel.layer.cornerRadius = 21
        sel.layer.cornerCurve = .continuous
        sel.clipsToBounds = true
        sel.layer.borderWidth = 0.5
        sel.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        container.addSubview(sel)
        self.selectionBubble = sel
        
        // Width = (container - 8) / itemCount, height = container - 12
        let leadingConstraint = sel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 6)
        self.selectionBubbleLeading = leadingConstraint
        
        NSLayoutConstraint.activate([
            leadingConstraint,
            sel.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            sel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),
            sel.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1.0 / CGFloat(itemCount), constant: -8.0 / CGFloat(itemCount))
        ])
    }
    
    // === 3. TabBar (Transparent, for labels only) ===
    let bar = UITabBar(frame: .zero)
    self.tabBar = bar
    bar.delegate = self
    bar.translatesAutoresizingMaskIntoConstraints = false
    
    if #available(iOS 10.0, *), let tint = tint { bar.tintColor = tint }
    
    // Build Items
    var items: [UITabBarItem] = []
    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
    
    for i in 0..<itemCount {
        var image: UIImage? = nil
        if i < symbols.count { 
            image = UIImage(systemName: symbols[i], withConfiguration: symbolConfig)
        }
        let title = (i < labels.count) ? labels[i] : nil
        let item = UITabBarItem(title: title, image: image, selectedImage: image)
        item.imageInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
        items.append(item)
    }
    bar.items = items
    if let items = bar.items, selectedIndex >= 0, selectedIndex < items.count {
        bar.selectedItem = items[selectedIndex]
    }
    
    // Configure Transparent Bar (no background, no selection indicator)
    if #available(iOS 13.0, *) {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowImage = nil
        appearance.shadowColor = .clear
        // Hide selection indicator
        appearance.selectionIndicatorTintColor = .clear
        
        let offset = UIOffset(horizontal: 0, vertical: 0)
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 11, weight: .medium), .foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 11, weight: .semibold), .foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        appearance.stackedItemPositioning = .fill
        
        bar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            bar.scrollEdgeAppearance = appearance
        }
    }

    container.addSubview(bar)
    
    NSLayoutConstraint.activate([
        bar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 2),
        bar.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -2),
        bar.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
        bar.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2)
    ])
    
    // Position bubble initially
    updateSelectionBubblePosition(index: selectedIndex, animated: false)
    
    // Add Pan Gesture
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    container.addGestureRecognizer(panGesture)

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { result(nil); return }
      switch call.method {
      case "getIntrinsicSize":
          if let bar = self.tabBar, let items = bar.items {
              let size = bar.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
              let minWidth = CGFloat(items.count * 120)
              let finalWidth = max(size.width, minWidth)
              result(["width": Double(finalWidth + 20), "height": Double(max(size.height, 90.0))])
          } else {
              result(["width": 240.0, "height": 90.0])
          }
      case "setSelectedIndex":
        if let args = call.arguments as? [String: Any], let idx = (args["index"] as? NSNumber)?.intValue {
            if let bar = self.tabBar, let items = bar.items, idx >= 0, idx < items.count {
                bar.selectedItem = items[idx]
                self.currentIndex = idx
                self.updateSelectionBubblePosition(index: idx, animated: true)
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
  
  private func updateSelectionBubblePosition(index: Int, animated: Bool) {
    guard itemCount > 0 else { return }
    let containerWidth = container.bounds.width > 0 ? container.bounds.width : 320
    let bubbleWidth = (containerWidth - 8) / CGFloat(itemCount)
    let leading = 6 + CGFloat(index) * bubbleWidth
    
    if animated {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.selectionBubbleLeading?.constant = leading
            self.container.layoutIfNeeded()
        })
    } else {
        self.selectionBubbleLeading?.constant = leading
    }
  }
  
  // Delegate
  func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
      if let items = tabBar.items, let index = items.firstIndex(of: item) {
          currentIndex = index
          updateSelectionBubblePosition(index: index, animated: true)
          channel.invokeMethod("valueChanged", arguments: ["index": index])
      }
  }

  // Pan Gesture
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    guard gesture.state == .changed || gesture.state == .ended else { return }
    
    let location = gesture.location(in: container)
    if let bar = tabBar, let items = bar.items, items.count > 0 {
      let itemWidth = container.bounds.width / CGFloat(items.count)
      var newIdx = Int(location.x / itemWidth)
      newIdx = max(0, min(newIdx, items.count - 1))
      
      if currentIndex != newIdx {
        bar.selectedItem = items[newIdx]
        currentIndex = newIdx
        updateSelectionBubblePosition(index: newIdx, animated: true)
        
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

