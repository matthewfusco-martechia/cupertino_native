import Flutter
import UIKit

class CupertinoInputPlatformView: NSObject, FlutterPlatformView, UITextViewDelegate {
  private let channel: FlutterMethodChannel
  private let container: UIView
  private let textView: UITextView
  private let placeholderLabel: UILabel
  private var isEnabled: Bool = true
  private var maxLines: Int = 1
  private var fontSize: CGFloat = 17.0
  private var placeholderText: String?
  private var hasNotifiedInitialHeight: Bool = false
  
  deinit {
    container.removeObserver(self, forKeyPath: "bounds")
  }
  
  init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
    self.channel = FlutterMethodChannel(
      name: "CupertinoNativeInput_\(viewId)", binaryMessenger: messenger)
    self.container = UIView(frame: frame)
    self.textView = UITextView()
    self.placeholderLabel = UILabel()
    
    var placeholder: String? = nil
    var text: String? = nil
    var borderStyle: String = "roundedRect"
    var fontSize: CGFloat = 17.0
    var textColor: UIColor? = nil
    var backgroundColor: UIColor? = nil
    var cursorColor: UIColor? = nil
    var isSecure: Bool = false
    var keyboardType: String = "default"
    var returnKeyType: String = "default"
    var autocorrectionType: String = "default"
    var textContentType: String? = nil
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
      if let kt = dict["keyboardType"] as? String { keyboardType = kt }
      if let rt = dict["returnKeyType"] as? String { returnKeyType = rt }
      if let ac = dict["autocorrectionType"] as? String { autocorrectionType = ac }
      if let tct = dict["textContentType"] as? String { textContentType = tct }
      if let dark = dict["isDark"] as? NSNumber { isDark = dark.boolValue }
      if let e = dict["enabled"] as? NSNumber { enabled = e.boolValue }
      if let ml = dict["maxLines"] as? NSNumber { maxLines = ml.intValue }
    }
    
    self.maxLines = maxLines
    self.fontSize = fontSize
    self.placeholderText = placeholder
    
    super.init()
    
    container.backgroundColor = .clear
    
    // Configure text view
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.text = text
    textView.font = UIFont.systemFont(ofSize: fontSize)
    textView.isEditable = enabled
    textView.isSelectable = true
    textView.delegate = self
    textView.isScrollEnabled = false // Allow auto-sizing
    textView.textContainerInset = UIEdgeInsets(top: 14, left: 4, bottom: 14, right: 4)
    textView.textContainer.lineFragmentPadding = 0
    
    // Apply colors
    if let tc = textColor {
      textView.textColor = tc
    } else if #available(iOS 13.0, *) {
      textView.textColor = .label
    }
    
    if let bg = backgroundColor {
      // Check if color is transparent (alpha == 0)
      var alpha: CGFloat = 0
      bg.getWhite(nil, alpha: &alpha)
      if alpha == 0 {
        textView.backgroundColor = .clear
      } else {
        textView.backgroundColor = bg
      }
    } else {
      textView.backgroundColor = .clear
    }
    
    // Apply cursor color (tintColor controls cursor and selection)
    if let cc = cursorColor {
      textView.tintColor = cc
    }
    
    // Apply border style
    switch borderStyle {
    case "none":
      textView.layer.borderWidth = 0
      textView.layer.cornerRadius = 0
    case "line":
      if #available(iOS 13.0, *) {
        textView.layer.borderColor = UIColor.separator.cgColor
      } else {
        textView.layer.borderColor = UIColor.lightGray.cgColor
      }
      textView.layer.borderWidth = 1
      textView.layer.cornerRadius = 0
    case "bezel":
      if #available(iOS 13.0, *) {
        textView.layer.borderColor = UIColor.separator.cgColor
      } else {
        textView.layer.borderColor = UIColor.lightGray.cgColor
      }
      textView.layer.borderWidth = 1
      textView.layer.cornerRadius = 4
    case "roundedRect":
      if #available(iOS 13.0, *) {
        textView.layer.borderColor = UIColor.separator.cgColor
      } else {
        textView.layer.borderColor = UIColor.lightGray.cgColor
      }
      textView.layer.borderWidth = 0.5
      textView.layer.cornerRadius = 8
    default:
      textView.layer.borderWidth = 0.5
      textView.layer.cornerRadius = 8
    }
    
    // Configure keyboard
    textView.keyboardType = Self.keyboardTypeFromString(keyboardType)
    textView.returnKeyType = Self.returnKeyTypeFromString(returnKeyType)
    textView.autocorrectionType = Self.autocorrectionTypeFromString(autocorrectionType)
    textView.isSecureTextEntry = isSecure
    
    // Set text content type if available
    if #available(iOS 10.0, *), let tct = textContentType {
      textView.textContentType = Self.textContentTypeFromString(tct)
    }
    
    self.isEnabled = enabled
    
    // Configure placeholder label
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
    placeholderLabel.text = placeholder
    placeholderLabel.font = UIFont.systemFont(ofSize: fontSize)
    placeholderLabel.numberOfLines = 1
    if #available(iOS 13.0, *) {
      placeholderLabel.textColor = .placeholderText
    } else {
      placeholderLabel.textColor = .lightGray
    }
    placeholderLabel.isHidden = !(text?.isEmpty ?? true)
    
    container.addSubview(textView)
    textView.addSubview(placeholderLabel)
    
    NSLayoutConstraint.activate([
      textView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      textView.topAnchor.constraint(equalTo: container.topAnchor),
      textView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
      
      placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 4),
      placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -4),
      placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 14),
    ])
    
    // Observe bounds changes to recalculate height
    container.addObserver(self, forKeyPath: "bounds", options: [.new], context: nil)
    
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(nil)
        return
      }
      switch call.method {
      case "setText":
        if let args = call.arguments as? [String: Any], let text = args["text"] as? String {
          self.textView.text = text
          self.placeholderLabel.isHidden = !text.isEmpty
          self.notifyHeightChange()
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing text", details: nil))
        }
      case "getText":
        result(self.textView.text ?? "")
      case "setPlaceholder":
        if let args = call.arguments as? [String: Any], let placeholder = args["placeholder"] as? String {
          self.placeholderLabel.text = placeholder
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
          self.textView.becomeFirstResponder()
        }
        result(nil)
      case "unfocus":
        DispatchQueue.main.async {
          self.textView.resignFirstResponder()
        }
        result(nil)
      case "setBorderStyle":
        if let args = call.arguments as? [String: Any], let style = args["borderStyle"] as? String {
          switch style {
          case "none":
            self.textView.layer.borderWidth = 0
            self.textView.layer.cornerRadius = 0
          case "line":
            if #available(iOS 13.0, *) {
              self.textView.layer.borderColor = UIColor.separator.cgColor
            }
            self.textView.layer.borderWidth = 1
            self.textView.layer.cornerRadius = 0
          case "bezel":
            if #available(iOS 13.0, *) {
              self.textView.layer.borderColor = UIColor.separator.cgColor
            }
            self.textView.layer.borderWidth = 1
            self.textView.layer.cornerRadius = 4
          case "roundedRect":
            if #available(iOS 13.0, *) {
              self.textView.layer.borderColor = UIColor.separator.cgColor
            }
            self.textView.layer.borderWidth = 0.5
            self.textView.layer.cornerRadius = 8
          default:
            break
          }
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing borderStyle", details: nil))
        }
      case "setSecure":
        if let args = call.arguments as? [String: Any], let secure = args["isSecure"] as? NSNumber {
          self.textView.isSecureTextEntry = secure.boolValue
          result(nil)
        } else {
          result(FlutterError(code: "bad_args", message: "Missing isSecure", details: nil))
        }
      case "setBrightness":
        // No longer override user interface style - let the system handle it
        result(nil)
      case "getContentHeight":
        let height = self.calculateContentHeight()
        result(height)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  func view() -> UIView { container }
  
  // MARK: - UITextViewDelegate
  
  func textViewDidChange(_ textView: UITextView) {
    guard isEnabled else { return }
    placeholderLabel.isHidden = !textView.text.isEmpty
    channel.invokeMethod("textChanged", arguments: ["text": textView.text ?? ""])
    notifyHeightChange()
    
    // Scroll to cursor position after layout updates
    DispatchQueue.main.async { [weak self] in
      self?.scrollToCursor()
    }
  }
  
  private func scrollToCursor() {
    // Only scroll if scrolling is enabled (content exceeds max height)
    guard textView.isScrollEnabled else { return }
    
    // Scroll to bottom to show the cursor
    scrollToBottom()
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    channel.invokeMethod("focusChanged", arguments: ["focused": true])
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    channel.invokeMethod("focusChanged", arguments: ["focused": false])
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    // Handle return key for single line mode
    if maxLines == 1 && text == "\n" {
      channel.invokeMethod("submitted", arguments: ["text": textView.text ?? ""])
      textView.resignFirstResponder()
      return false
    }
    
    // For multiline, when pressing return, scroll to cursor after the change
    if text == "\n" && maxLines > 1 {
      DispatchQueue.main.async { [weak self] in
        self?.notifyHeightChange()
        self?.scrollToCursor()
      }
    }
    
    return true
  }
  
  // MARK: - Height Calculation
  
  private func calculateContentHeight() -> CGFloat {
    let lineHeight = fontSize * 1.2
    let verticalPadding: CGFloat = 28 // 14 top + 14 bottom
    let minHeight = lineHeight + verticalPadding
    let maxHeight = lineHeight * CGFloat(maxLines) + verticalPadding
    
    // Get the width for calculation - use container width if available
    let width = textView.bounds.width > 0 ? textView.bounds.width : container.bounds.width
    guard width > 0 else { return minHeight }
    
    let size = textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    let calculatedHeight = min(max(size.height, minHeight), maxHeight)
    
    // Enable scrolling when content exceeds max height
    let shouldScroll = size.height > maxHeight
    if textView.isScrollEnabled != shouldScroll {
      textView.isScrollEnabled = shouldScroll
      
      // When enabling scrolling, scroll to the cursor position
      if shouldScroll {
        DispatchQueue.main.async { [weak self] in
          self?.scrollToBottom()
        }
      }
    }
    
    return calculatedHeight
  }
  
  private func scrollToBottom() {
    let bottomOffset = CGPoint(x: 0, y: max(0, textView.contentSize.height - textView.bounds.height))
    textView.setContentOffset(bottomOffset, animated: false)
  }
  
  private func notifyHeightChange() {
    // Delay to ensure layout is complete
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      let height = self.calculateContentHeight()
      self.channel.invokeMethod("heightChanged", arguments: ["height": height])
    }
  }
  
  // Called when the view is laid out
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "bounds" {
      // Only notify once on initial layout, and then on text changes
      if !hasNotifiedInitialHeight && container.bounds.width > 0 {
        hasNotifiedInitialHeight = true
        notifyHeightChange()
      }
    }
  }
  
  // MARK: - Helper Methods
  
  private static func colorFromARGB(_ argb: Int) -> UIColor {
    let a = CGFloat((argb >> 24) & 0xFF) / 255.0
    let r = CGFloat((argb >> 16) & 0xFF) / 255.0
    let g = CGFloat((argb >> 8) & 0xFF) / 255.0
    let b = CGFloat(argb & 0xFF) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: a)
  }
  
  private static func keyboardTypeFromString(_ type: String) -> UIKeyboardType {
    switch type {
    case "default": return .default
    case "asciiCapable": return .asciiCapable
    case "numbersAndPunctuation": return .numbersAndPunctuation
    case "URL": return .URL
    case "numberPad": return .numberPad
    case "phonePad": return .phonePad
    case "namePhonePad": return .namePhonePad
    case "emailAddress": return .emailAddress
    case "decimalPad": return .decimalPad
    case "twitter": return .twitter
    case "webSearch": return .webSearch
    default: return .default
    }
  }
  
  private static func returnKeyTypeFromString(_ type: String) -> UIReturnKeyType {
    switch type {
    case "default": return .default
    case "go": return .go
    case "google": return .google
    case "join": return .join
    case "next": return .next
    case "route": return .route
    case "search": return .search
    case "send": return .send
    case "yahoo": return .yahoo
    case "done": return .done
    case "emergencyCall": return .emergencyCall
    case "continue": return .continue
    default: return .default
    }
  }
  
  private static func autocorrectionTypeFromString(_ type: String) -> UITextAutocorrectionType {
    switch type {
    case "default": return .default
    case "no": return .no
    case "yes": return .yes
    default: return .default
    }
  }
  
  @available(iOS 10.0, *)
  private static func textContentTypeFromString(_ type: String) -> UITextContentType? {
    switch type {
    case "name": return .name
    case "namePrefix": return .namePrefix
    case "givenName": return .givenName
    case "middleName": return .middleName
    case "familyName": return .familyName
    case "nameSuffix": return .nameSuffix
    case "nickname": return .nickname
    case "jobTitle": return .jobTitle
    case "organizationName": return .organizationName
    case "location": return .location
    case "fullStreetAddress": return .fullStreetAddress
    case "streetAddressLine1": return .streetAddressLine1
    case "streetAddressLine2": return .streetAddressLine2
    case "addressCity": return .addressCity
    case "addressState": return .addressState
    case "addressCityAndState": return .addressCityAndState
    case "sublocality": return .sublocality
    case "countryName": return .countryName
    case "postalCode": return .postalCode
    case "telephoneNumber": return .telephoneNumber
    case "emailAddress": return .emailAddress
    case "URL": return .URL
    case "creditCardNumber": return .creditCardNumber
    case "username": return .username
    case "password": return .password
    default: return nil
    }
  }
}


#if DEBUG
  import SwiftUI

  // A dummy class to satisfy the initializer of CupertinoInputPlatformView
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

  private struct CupertinoInputPlatformView_Preview: UIViewRepresentable {
    let args: [String: Any]
    
    func makeUIView(context: Context) -> UIView {
      let containerView = UIView()
      containerView.backgroundColor = .systemBackground

      let cupertinoInputPlatformView = CupertinoInputPlatformView(
        frame: CGRect(x: 0, y: 0, width: 300, height: 44),
        viewId: 0,
        args: args,
        messenger: DummyBinaryMessenger()
      ).view()
      
      // Create a container that represents an input field
      let inputContainer = UIView()
      inputContainer.backgroundColor = .systemBackground

      inputContainer.addSubview(cupertinoInputPlatformView)
      containerView.addSubview(inputContainer)
      
      // Set up constraints
      inputContainer.translatesAutoresizingMaskIntoConstraints = false
      cupertinoInputPlatformView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        inputContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        inputContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        inputContainer.widthAnchor.constraint(equalToConstant: 300),
        inputContainer.heightAnchor.constraint(equalToConstant: 44),
        
        cupertinoInputPlatformView.topAnchor.constraint(equalTo: inputContainer.topAnchor),
        cupertinoInputPlatformView.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor),
        cupertinoInputPlatformView.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor),
        cupertinoInputPlatformView.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor),
      ])
      
      return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
  }

  // The Preview provider that shows your input field in the Xcode canvas
  @available(iOS 13.0, *)
  struct CupertinoInputPreview: PreviewProvider {
    static var previews: some View {
      // You can create multiple previews to see different styles
      Group {
        CupertinoInputPlatformView_Preview(args: [
          "placeholder": "Enter your name",
          "borderStyle": "roundedRect",
          "fontSize": 17,
        ])
        .previewDisplayName("Default Input")

        CupertinoInputPlatformView_Preview(args: [
          "placeholder": "Search...",
          "borderStyle": "roundedRect",
          "keyboardType": "webSearch",
          "returnKeyType": "search",
        ])
        .previewDisplayName("Search Input")

        CupertinoInputPlatformView_Preview(args: [
          "placeholder": "Enter password",
          "borderStyle": "roundedRect",
          "isSecure": true,
          "textContentType": "password",
        ])
        .previewDisplayName("Password Input")

        CupertinoInputPlatformView_Preview(args: [
          "placeholder": "Email address",
          "borderStyle": "line",
          "keyboardType": "emailAddress",
          "textContentType": "emailAddress",
          "autocorrectionType": "no",
        ])
        .previewDisplayName("Email Input")

        CupertinoInputPlatformView_Preview(args: [
          "text": "Disabled input field",
          "enabled": false,
          "borderStyle": "bezel",
        ])
        .previewDisplayName("Disabled Input")

        CupertinoInputPlatformView_Preview(args: [
          "placeholder": "No border input",
          "borderStyle": "none",
          "fontSize": 18,
        ])
        .previewDisplayName("No Border Input")
      }
      .previewLayout(.fixed(width: 350, height: 80))
      .padding()
    }
  }
#endif
