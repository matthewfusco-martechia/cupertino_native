import FlutterMacOS
import Cocoa

class CupertinoInputNSView: NSView, NSTextViewDelegate {
  private let channel: FlutterMethodChannel
  private let scrollView: NSScrollView
  private let textView: NSTextView
  private let placeholderLabel: NSTextField
  private var isEnabled: Bool = true
  private var maxLines: Int = 1
  private var fontSize: CGFloat = 17.0
  private var placeholderText: String?
  private var hasNotifiedInitialHeight: Bool = false
  private var currentBorderStyle: String = "roundedRect"
  
  init(viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
    self.channel = FlutterMethodChannel(name: "CupertinoNativeInput_\(viewId)", binaryMessenger: messenger)
    self.scrollView = NSScrollView()
    self.textView = NSTextView()
    self.placeholderLabel = NSTextField(labelWithString: "")
    super.init(frame: .zero)
    
    var placeholder: String? = nil
    var text: String? = nil
    var borderStyle: String = "roundedRect"
    var fontSize: CGFloat = 17.0
    var textColor: NSColor? = nil
    var backgroundColor: NSColor? = nil
    var cursorColor: NSColor? = nil
    var isSecure: Bool = false
    var isDark: Bool = false
    var enabled: Bool = true
    var maxLines: Int = 1
    
    if let dict = args as? [String: Any] {
      if let p = dict["placeholder"] as? String { placeholder = p }
      if let t = dict["text"] as? String { text = t }
      if let bs = dict["borderStyle"] as? String { borderStyle = bs }
      if let fs = dict["fontSize"] as? NSNumber { fontSize = CGFloat(truncating: fs) }
      if let tc = dict["textColor"] as? NSNumber { textColor = Self.colorFromARGB(tc.intValue) }
      if let bg = dict["backgroundColor"] as? NSNumber { backgroundColor = Self.colorFromARGB(bg.intValue) }
      if let cc = dict["cursorColor"] as? NSNumber { cursorColor = Self.colorFromARGB(cc.intValue) }
      if let secure = dict["isSecure"] as? NSNumber { isSecure = secure.boolValue }
      if let dark = dict["isDark"] as? NSNumber { isDark = dark.boolValue }
      if let e = dict["enabled"] as? NSNumber { enabled = e.boolValue }
      if let ml = dict["maxLines"] as? NSNumber { maxLines = ml.intValue }
    }
    
    self.maxLines = maxLines
    self.fontSize = fontSize
    self.placeholderText = placeholder
    self.currentBorderStyle = borderStyle
    
    wantsLayer = true
    layer?.backgroundColor = NSColor.clear.cgColor
    appearance = NSAppearance(named: isDark ? .darkAqua : .aqua)
    
    // Configure scroll view
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.hasVerticalScroller = true
    scrollView.hasHorizontalScroller = false
    scrollView.autohidesScrollers = true
    scrollView.borderType = .noBorder
    scrollView.drawsBackground = false
    
    // Configure text view
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.string = text ?? ""
    textView.font = NSFont.systemFont(ofSize: fontSize)
    textView.isEditable = enabled
    textView.isSelectable = true
    textView.delegate = self
    textView.isVerticallyResizable = true
    textView.isHorizontallyResizable = false
    textView.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    textView.textContainer?.widthTracksTextView = true
    textView.textContainerInset = NSSize(width: 4, height: 14)
    textView.isRichText = false
    textView.allowsUndo = true
    textView.drawsBackground = false
    
    // Apply colors
    if let tc = textColor {
      textView.textColor = tc
    } else {
      textView.textColor = .labelColor
    }
    
    if let bg = backgroundColor {
      // Check if color is transparent (alpha == 0)
      if bg.alphaComponent == 0 {
        textView.backgroundColor = .clear
        scrollView.backgroundColor = .clear
      } else {
        textView.backgroundColor = bg
        scrollView.backgroundColor = bg
      }
    } else {
      textView.backgroundColor = .clear
      scrollView.backgroundColor = .clear
    }
    
    // Apply cursor color (insertion point color)
    if let cc = cursorColor {
      textView.insertionPointColor = cc
    }
    
    // Apply border style
    applyBorderStyle(borderStyle)
    
    self.isEnabled = enabled
    
    // Configure placeholder label
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
    placeholderLabel.stringValue = placeholder ?? ""
    placeholderLabel.font = NSFont.systemFont(ofSize: fontSize)
    placeholderLabel.textColor = .placeholderTextColor
    placeholderLabel.isBezeled = false
    placeholderLabel.isEditable = false
    placeholderLabel.drawsBackground = false
    placeholderLabel.isHidden = !(text?.isEmpty ?? true)
    
    // Setup view hierarchy
    scrollView.documentView = textView
    addSubview(scrollView)
    addSubview(placeholderLabel)
    
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
    ])
    
    // Configure text view to match scroll view width
    if let contentSize = scrollView.contentSize as NSSize? {
      textView.minSize = NSSize(width: 0, height: 0)
      textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
      textView.frame = NSRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
    }
    
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(nil)
        return
      }
      switch call.method {
      case "setText":
        if let args = call.arguments as? [String: Any], let text = args["text"] as? String {
          // Preserve cursor position when setting text
          let selectedRange = self.textView.selectedRange()
          let oldLength = (self.textView.string as NSString).length
          
          self.textView.string = text
          self.placeholderLabel.isHidden = !text.isEmpty
          
          // Restore cursor position, adjusting if text length changed
          let newLength = (text as NSString).length
          let lengthDiff = newLength - oldLength
          let newLocation = max(0, min(selectedRange.location + lengthDiff, newLength))
          self.textView.setSelectedRange(NSRange(location: newLocation, length: 0))
          
          self.notifyHeightChange()
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing text", details: nil))
        }
      case "getText":
        result(self.textView.string)
      case "setPlaceholder":
        if let args = call.arguments as? [String: Any], let placeholder = args["placeholder"] as? String {
          self.placeholderLabel.stringValue = placeholder
          self.placeholderText = placeholder
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing placeholder", details: nil))
        }
      case "setEnabled":
        if let args = call.arguments as? [String: Any], let enabled = args["enabled"] as? NSNumber {
          self.isEnabled = enabled.boolValue
          self.textView.isEditable = self.isEnabled
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing enabled", details: nil))
        }
      case "focus":
        DispatchQueue.main.async {
          self.window?.makeFirstResponder(self.textView)
        }
        result(nil)
      case "unfocus":
        DispatchQueue.main.async {
          self.window?.makeFirstResponder(nil)
        }
        result(nil)
      case "setBorderStyle":
        if let args = call.arguments as? [String: Any], let style = args["borderStyle"] as? String {
          self.applyBorderStyle(style)
          self.currentBorderStyle = style
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing borderStyle", details: nil))
        }
      case "setBrightness":
        if let args = call.arguments as? [String: Any],
          let isDark = (args["isDark"] as? NSNumber)?.boolValue
        {
          self.appearance = NSAppearance(named: isDark ? .darkAqua : .aqua)
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing isDark", details: nil))
        }
      case "getContentHeight":
        let height = self.calculateContentHeight()
        result(height)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    // Observe frame changes for initial layout
    postsFrameChangedNotifications = true
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(frameDidChange(_:)),
      name: NSView.frameDidChangeNotification,
      object: self
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc private func frameDidChange(_ notification: Notification) {
    // Update text view width to match scroll view
    if let contentSize = scrollView.contentSize as NSSize? {
      textView.setFrameSize(NSSize(width: contentSize.width, height: textView.frame.height))
      textView.textContainer?.containerSize = NSSize(width: contentSize.width - 8, height: CGFloat.greatestFiniteMagnitude)
    }
    
    if !hasNotifiedInitialHeight && bounds.width > 0 {
      hasNotifiedInitialHeight = true
      notifyHeightChange()
    }
  }
  
  private func applyBorderStyle(_ style: String) {
    wantsLayer = true
    switch style {
    case "none":
      layer?.borderWidth = 0
      layer?.cornerRadius = 0
    case "line":
      layer?.borderColor = NSColor.separatorColor.cgColor
      layer?.borderWidth = 1
      layer?.cornerRadius = 0
    case "bezel":
      layer?.borderColor = NSColor.separatorColor.cgColor
      layer?.borderWidth = 1
      layer?.cornerRadius = 4
    case "roundedRect":
      layer?.borderColor = NSColor.separatorColor.cgColor
      layer?.borderWidth = 0.5
      layer?.cornerRadius = 8
    default:
      layer?.borderWidth = 0.5
      layer?.cornerRadius = 8
    }
  }
  
  // MARK: - NSTextViewDelegate
  
  func textDidChange(_ notification: Notification) {
    guard isEnabled else { return }
    placeholderLabel.isHidden = !textView.string.isEmpty
    channel.invokeMethod("textChanged", arguments: ["text": textView.string])
    
    // Force layout update before calculating height
    textView.layoutManager?.ensureLayout(for: textView.textContainer!)
    
    notifyHeightChange()
    
    // Scroll to cursor position after layout updates
    DispatchQueue.main.async { [weak self] in
      self?.scrollToCursor()
    }
  }
  
  private func scrollToCursor() {
    guard let layoutManager = textView.layoutManager,
          let textContainer = textView.textContainer else { return }
    
    let selectedRange = textView.selectedRange()
    if selectedRange.location == NSNotFound { return }
    
    // Get the glyph range for the selected range
    let glyphRange = layoutManager.glyphRange(forCharacterRange: selectedRange, actualCharacterRange: nil)
    
    // Get the bounding rect for the cursor position
    var cursorRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    cursorRect.size.height += 20 // Add padding below cursor
    
    // Scroll to make cursor visible
    textView.scrollToVisible(cursorRect)
  }
  
  func textDidBeginEditing(_ notification: Notification) {
    channel.invokeMethod("focusChanged", arguments: ["focused": true])
  }
  
  func textDidEndEditing(_ notification: Notification) {
    channel.invokeMethod("focusChanged", arguments: ["focused": false])
  }
  
  func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    // Handle return key for single line mode
    if commandSelector == #selector(NSResponder.insertNewline(_:)) {
      if maxLines == 1 {
        channel.invokeMethod("submitted", arguments: ["text": textView.string])
        window?.makeFirstResponder(nil)
        return true
      }
      // For multiline, allow the newline and scroll to cursor after
      DispatchQueue.main.async { [weak self] in
        self?.notifyHeightChange()
        self?.scrollToCursor()
      }
    }
    return false
  }
  
  // MARK: - Height Calculation
  
  private func calculateContentHeight() -> CGFloat {
    let lineHeight = fontSize * 1.2
    let verticalPadding: CGFloat = 28 // 14 top + 14 bottom
    let minHeight = lineHeight + verticalPadding
    let maxHeight = lineHeight * CGFloat(maxLines) + verticalPadding
    
    // Get the width for calculation
    let width = textView.bounds.width > 0 ? textView.bounds.width : bounds.width
    guard width > 0 else { return minHeight }
    
    // Calculate the size needed for the text
    guard let layoutManager = textView.layoutManager,
          let textContainer = textView.textContainer else { return minHeight }
    
    layoutManager.ensureLayout(for: textContainer)
    let usedRect = layoutManager.usedRect(for: textContainer)
    let calculatedHeight = min(max(usedRect.height + verticalPadding, minHeight), maxHeight)
    
    // Enable/disable scrolling based on content height
    let shouldScroll = usedRect.height + verticalPadding > maxHeight
    scrollView.hasVerticalScroller = shouldScroll
    
    return calculatedHeight
  }
  
  private func notifyHeightChange() {
    // Delay to ensure layout is complete
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      let height = self.calculateContentHeight()
      self.channel.invokeMethod("heightChanged", arguments: ["height": height])
    }
  }
  
  // MARK: - Helper Methods
  
  private static func colorFromARGB(_ argb: Int) -> NSColor {
    let a = CGFloat((argb >> 24) & 0xFF) / 255.0
    let r = CGFloat((argb >> 16) & 0xFF) / 255.0
    let g = CGFloat((argb >> 8) & 0xFF) / 255.0
    let b = CGFloat(argb & 0xFF) / 255.0
    return NSColor(red: r, green: g, blue: b, alpha: a)
  }
}


#if DEBUG
  import SwiftUI

  // A dummy class to satisfy the initializer of CupertinoInputNSView
  // which requires a FlutterBinaryMessenger. This won't be used in the preview.
  private class DummyBinaryMessenger: NSObject, FlutterBinaryMessenger {
    func send(onChannel channel: String, message: Data?) {}
    func send(
      onChannel channel: String, message: Data?, binaryReply reply: FlutterBinaryReply? = nil
    ) {}
    func setMessageHandlerOnChannel(
      _ channel: String, binaryMessageHandler handler: FlutterBinaryMessageHandler? = nil
    ) -> FlutterBinaryMessengerConnection {
      return 0
    }
    func cleanUpConnection(_ connection: FlutterBinaryMessengerConnection) {}
  }

  @available(macOS 10.15, *)
  private struct CupertinoInputNSView_Preview: NSViewRepresentable {
    let args: [String: Any]
    
    func makeNSView(context: Context) -> NSView {
      let containerView = NSView()
      containerView.wantsLayer = true
      containerView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor

      let cupertinoInputNSView = CupertinoInputNSView(
        viewId: 0,
        args: args,
        messenger: DummyBinaryMessenger()
      )
      
      containerView.addSubview(cupertinoInputNSView)
      
      // Set up constraints
      cupertinoInputNSView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        cupertinoInputNSView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        cupertinoInputNSView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        cupertinoInputNSView.widthAnchor.constraint(equalToConstant: 300),
        cupertinoInputNSView.heightAnchor.constraint(equalToConstant: 100),
      ])
      
      return containerView
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
  }

  // The Preview provider that shows your input field in the Xcode canvas
  @available(macOS 10.15, *)
  struct CupertinoInputNSPreview: PreviewProvider {
    static var previews: some View {
      // You can create multiple previews to see different styles
      Group {
        CupertinoInputNSView_Preview(args: [
          "placeholder": "Enter your name",
          "borderStyle": "roundedRect",
          "fontSize": 14,
          "maxLines": 5,
        ])
        .previewDisplayName("Default Input")

        CupertinoInputNSView_Preview(args: [
          "placeholder": "Type a message...",
          "borderStyle": "roundedRect",
          "maxLines": 10,
        ])
        .previewDisplayName("Multiline Input")

        CupertinoInputNSView_Preview(args: [
          "text": "Disabled input field",
          "enabled": false,
          "borderStyle": "bezel",
        ])
        .previewDisplayName("Disabled Input")

        CupertinoInputNSView_Preview(args: [
          "placeholder": "No border input",
          "borderStyle": "none",
          "fontSize": 16,
          "maxLines": 3,
        ])
        .previewDisplayName("No Border Input")
      }
      .frame(width: 350, height: 120)
      .padding()
    }
  }
#endif
