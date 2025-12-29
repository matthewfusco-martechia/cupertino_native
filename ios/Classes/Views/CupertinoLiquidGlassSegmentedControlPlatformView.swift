import Flutter
import UIKit

/// A true Liquid Glass segmented control using UIGlassEffect on iOS 26+.
/// Provides a pill-shaped segmented control with a sliding glass selection indicator.
class CupertinoLiquidGlassSegmentedControlPlatformView: NSObject, FlutterPlatformView {
  private let channel: FlutterMethodChannel
  private let container: UIView
  
  // Background glass container
  private var backgroundGlassView: UIVisualEffectView!
  
  // Selection indicator (the sliding glass pill) - positioned manually via frame
  private var selectionIndicator: UIVisualEffectView!
  
  // Segment items
  private var segmentStackView: UIStackView!
  private var segmentViews: [SegmentItemView] = []
  
  // State
  private var labels: [String] = []
  private var symbols: [String] = []
  private var selectedIndex: Int = 0
  private var tintColor: UIColor?
  private var isDark: Bool = true
  private var hasLaidOutOnce: Bool = false
  
  // Layout constants
  private let itemWidth: CGFloat = 100
  private let cornerRadius: CGFloat = 28
  private let selectionPadding: CGFloat = 4
  
  init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
    self.channel = FlutterMethodChannel(name: "CupertinoNativeLiquidGlassSegmentedControl_\(viewId)", binaryMessenger: messenger)
    self.container = LayoutObservingView(frame: frame)
    
    super.init()
    
    // Parse args
    if let dict = args as? [String: Any] {
      if let arr = dict["labels"] as? [String] { labels = arr }
      if let arr = dict["sfSymbols"] as? [String] { symbols = arr }
      if let v = dict["isDark"] as? NSNumber { isDark = v.boolValue }
      if let v = dict["selectedIndex"] as? NSNumber { selectedIndex = v.intValue }
      if let style = dict["style"] as? [String: Any] {
        if let n = style["tint"] as? NSNumber { tintColor = Self.colorFromARGB(n.intValue) }
      }
    }
    
    container.backgroundColor = .clear
    if #available(iOS 13.0, *) {
      container.overrideUserInterfaceStyle = isDark ? .dark : .light
    }
    
    // Set layout callback
    (container as? LayoutObservingView)?.onLayout = { [weak self] in
      self?.onContainerLayout()
    }
    
    setupViews()
    setupGestures()
    setupChannel()
  }
  
  func view() -> UIView { container }
  
  // MARK: - Setup
  
  private func setupViews() {
    // Background glass effect
    let backgroundEffect: UIVisualEffect
    if #available(iOS 26.0, *) {
      let glassEffect = UIGlassEffect(style: .regular)
      backgroundEffect = glassEffect
    } else {
      backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
    }
    
    backgroundGlassView = UIVisualEffectView(effect: backgroundEffect)
    backgroundGlassView.translatesAutoresizingMaskIntoConstraints = false
    backgroundGlassView.layer.cornerRadius = cornerRadius
    backgroundGlassView.clipsToBounds = true
    if #available(iOS 13.0, *) {
      backgroundGlassView.layer.cornerCurve = .continuous
    }
    container.addSubview(backgroundGlassView)
    
    // Selection indicator (inner glass pill) - uses frame-based layout
    let selectionEffect: UIVisualEffect
    if #available(iOS 26.0, *) {
      let glassEffect = UIGlassEffect(style: .regular)
      glassEffect.isInteractive = true
      selectionEffect = glassEffect
    } else {
      selectionEffect = UIBlurEffect(style: .systemThickMaterial)
    }
    
    selectionIndicator = UIVisualEffectView(effect: selectionEffect)
    // NOTE: Using frame-based layout, NOT auto-layout
    selectionIndicator.translatesAutoresizingMaskIntoConstraints = true
    selectionIndicator.layer.cornerRadius = cornerRadius - selectionPadding
    selectionIndicator.clipsToBounds = true
    if #available(iOS 13.0, *) {
      selectionIndicator.layer.cornerCurve = .continuous
    }
    // Set initial frame to avoid zero-size
    selectionIndicator.frame = CGRect(x: selectionPadding, y: selectionPadding, width: itemWidth - selectionPadding * 2, height: 70)
    backgroundGlassView.contentView.addSubview(selectionIndicator)
    
    // Segment stack view - added AFTER selection indicator so it's on top
    segmentStackView = UIStackView()
    segmentStackView.translatesAutoresizingMaskIntoConstraints = false
    segmentStackView.axis = .horizontal
    segmentStackView.distribution = .fillEqually
    segmentStackView.alignment = .fill
    backgroundGlassView.contentView.addSubview(segmentStackView)
    
    // Create segment items
    let count = max(labels.count, symbols.count)
    for i in 0..<count {
      let label = (i < labels.count) ? labels[i] : ""
      let symbol = (i < symbols.count) ? symbols[i] : ""
      let isSelected = (i == selectedIndex)
      
      let segmentView = SegmentItemView(
        label: label,
        sfSymbol: symbol,
        isSelected: isSelected,
        tintColor: tintColor ?? .systemBlue
      )
      segmentView.tag = i
      segmentViews.append(segmentView)
      segmentStackView.addArrangedSubview(segmentView)
    }
    
    // Layout constraints for background and stack view
    NSLayoutConstraint.activate([
      backgroundGlassView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      backgroundGlassView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      backgroundGlassView.topAnchor.constraint(equalTo: container.topAnchor),
      backgroundGlassView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
      
      segmentStackView.leadingAnchor.constraint(equalTo: backgroundGlassView.contentView.leadingAnchor),
      segmentStackView.trailingAnchor.constraint(equalTo: backgroundGlassView.contentView.trailingAnchor),
      segmentStackView.topAnchor.constraint(equalTo: backgroundGlassView.contentView.topAnchor),
      segmentStackView.bottomAnchor.constraint(equalTo: backgroundGlassView.contentView.bottomAnchor),
    ])
  }
  
  private func onContainerLayout() {
    // Called after container lays out - now segment frames are valid
    if !hasLaidOutOnce {
      hasLaidOutOnce = true
      updateSelectionIndicatorPosition(animated: false)
    }
  }
  
  private func setupGestures() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    backgroundGlassView.addGestureRecognizer(tapGesture)
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    backgroundGlassView.addGestureRecognizer(panGesture)
  }
  
  private func setupChannel() {
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { result(nil); return }
      switch call.method {
      case "getIntrinsicSize":
        let count = max(self.labels.count, self.symbols.count)
        let width = CGFloat(count) * self.itemWidth + 20
        let height: CGFloat = 90
        result(["width": Double(width), "height": Double(height)])
        
      case "setSelectedIndex":
        if let args = call.arguments as? [String: Any], let idx = (args["index"] as? NSNumber)?.intValue {
          if idx >= 0 && idx < self.segmentViews.count && idx != self.selectedIndex {
            self.setSelectedIndex(idx, animated: true, notify: false)
          }
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing index", details: nil))
        }
        
      case "setStyle":
        if let args = call.arguments as? [String: Any] {
          if let n = args["tint"] as? NSNumber {
            self.tintColor = Self.colorFromARGB(n.intValue)
            self.updateTintColor()
          }
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing style", details: nil))
        }
        
      case "setBrightness":
        if let args = call.arguments as? [String: Any], let isDark = (args["isDark"] as? NSNumber)?.boolValue {
          self.isDark = isDark
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
  
  // MARK: - Gestures
  
  @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: segmentStackView)
    for (index, segmentView) in segmentViews.enumerated() {
      if segmentView.frame.contains(location) {
        setSelectedIndex(index, animated: true, notify: true)
        break
      }
    }
  }
  
  @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
    guard gesture.state == .changed || gesture.state == .ended else { return }
    
    let location = gesture.location(in: segmentStackView)
    for (index, segmentView) in segmentViews.enumerated() {
      if segmentView.frame.contains(location) {
        if index != selectedIndex {
          setSelectedIndex(index, animated: true, notify: true)
        }
        break
      }
    }
  }
  
  // MARK: - Selection
  
  private func setSelectedIndex(_ index: Int, animated: Bool, notify: Bool) {
    guard index >= 0 && index < segmentViews.count else { return }
    
    let oldIndex = selectedIndex
    selectedIndex = index
    
    // Update selection states
    for (i, segmentView) in segmentViews.enumerated() {
      segmentView.setSelected(i == index, tintColor: tintColor ?? .systemBlue)
    }
    
    // Animate selection indicator
    updateSelectionIndicatorPosition(animated: animated)
    
    // Haptic feedback
    if animated && oldIndex != index {
      if #available(iOS 10.0, *) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
      }
    }
    
    // Notify Flutter
    if notify {
      channel.invokeMethod("valueChanged", arguments: ["index": index])
    }
  }
  
  private func updateSelectionIndicatorPosition(animated: Bool) {
    guard selectedIndex < segmentViews.count else { return }
    guard segmentStackView.bounds.width > 0 else { return }
    
    let selectedView = segmentViews[selectedIndex]
    
    // Convert frame to backgroundGlassView.contentView coordinate space
    let frame = selectedView.convert(selectedView.bounds, to: backgroundGlassView.contentView)
    
    // Inset the frame for padding
    let indicatorFrame = frame.insetBy(dx: selectionPadding, dy: selectionPadding)
    
    if animated {
      UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
        self.selectionIndicator.frame = indicatorFrame
      }
    } else {
      selectionIndicator.frame = indicatorFrame
    }
  }
  
  private func updateTintColor() {
    for (i, segmentView) in segmentViews.enumerated() {
      segmentView.setSelected(i == selectedIndex, tintColor: tintColor ?? .systemBlue)
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

// MARK: - Layout Observing View

private class LayoutObservingView: UIView {
  var onLayout: (() -> Void)?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    onLayout?()
  }
}

// MARK: - Segment Item View

private class SegmentItemView: UIView {
  private let iconImageView = UIImageView()
  private let labelView = UILabel()
  private var hasIcon: Bool = false
  
  init(label: String, sfSymbol: String, isSelected: Bool, tintColor: UIColor) {
    super.init(frame: .zero)
    
    backgroundColor = .clear
    
    // Icon
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    iconImageView.contentMode = .scaleAspectFit
    hasIcon = !sfSymbol.isEmpty
    if hasIcon {
      let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
      iconImageView.image = UIImage(systemName: sfSymbol, withConfiguration: config)
      addSubview(iconImageView)
    }
    
    // Label
    labelView.translatesAutoresizingMaskIntoConstraints = false
    labelView.text = label
    labelView.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    labelView.textAlignment = .center
    addSubview(labelView)
    
    // Layout: icon above label if both present, or just label centered
    if hasIcon {
      NSLayoutConstraint.activate([
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
        iconImageView.widthAnchor.constraint(equalToConstant: 28),
        iconImageView.heightAnchor.constraint(equalToConstant: 28),
        
        labelView.centerXAnchor.constraint(equalTo: centerXAnchor),
        labelView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
        labelView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
        labelView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4),
      ])
    } else {
      NSLayoutConstraint.activate([
        labelView.centerXAnchor.constraint(equalTo: centerXAnchor),
        labelView.centerYAnchor.constraint(equalTo: centerYAnchor),
        labelView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
        labelView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8),
      ])
    }
    
    setSelected(isSelected, tintColor: tintColor)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setSelected(_ selected: Bool, tintColor: UIColor) {
    if selected {
      iconImageView.tintColor = tintColor
      labelView.textColor = tintColor
    } else {
      iconImageView.tintColor = UIColor.secondaryLabel
      labelView.textColor = UIColor.secondaryLabel
    }
  }
}
