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
  private var minHeight: CGFloat = 48.0
  private var maxHeight: CGFloat = 200.0
  
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
    
    // Calculate height bounds
    let lineHeight = fontSize * 1.2
    let verticalPadding: CGFloat = 16 // 8 top + 8 bottom
    self.minHeight = lineHeight + verticalPadding
    self.maxHeight = lineHeight * CGFloat(maxLines) + verticalPadding
    
    super.init()
    
    container.backgroundColor = .clear
    container.clipsToBounds = true
    
    // Configure text view - SIMPLE SETUP
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.text = text
    textView.font = UIFont.systemFont(ofSize: fontSize)
    textView.isEditable = enabled
    textView.isSelectable = true
    textView.delegate = self
    // Smaller vertical padding for better centering with icons
    textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
    textView.textContainer.lineFragmentPadding = 0
    
    // KEY: Always enable scrolling for multi-line - this is how iMessage works
    textView.isScrollEnabled = true
    textView.showsVerticalScrollIndicator = false
    textView.alwaysBounceVertical = false
    
    // Apply colors
    if let tc = textColor {
      textView.textColor = tc
    } else if #available(iOS 13.0, *) {
      textView.textColor = .label
    }
    
    if let bg = backgroundColor {
      var alpha: CGFloat = 0
      bg.getWhite(nil, alpha: &alpha)
      textView.backgroundColor = alpha == 0 ? .clear : bg
    } else {
      textView.backgroundColor = .clear
    }
    
    if let cc = cursorColor {
      textView.tintColor = cc
    }
    
    // Apply border style
    applyBorderStyle(borderStyle)
    
    // Configure keyboard
    textView.keyboardType = Self.keyboardTypeFromString(keyboardType)
    textView.returnKeyType = Self.returnKeyTypeFromString(returnKeyType)
    textView.autocorrectionType = Self.autocorrectionTypeFromString(autocorrectionType)
    textView.isSecureTextEntry = isSecure
    
    if #available(iOS 10.0, *), let tct = textContentType {
      textView.textContentType = Self.textContentTypeFromString(tct)
    }
    
    self.isEnabled = enabled
    
    // Configure placeholder
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
    container.addSubview(placeholderLabel)
    
    // Simple constraints - fill the container
    NSLayoutConstraint.activate([
      textView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      textView.topAnchor.constraint(equalTo: container.topAnchor),
      textView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
      
      // Center placeholder vertically to align with button
      placeholderLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
      placeholderLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
      placeholderLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
    ])
    
    setupMethodChannel()
  }
  
  private func setupMethodChannel() {
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
          self.updateHeight()
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
        self.textView.becomeFirstResponder()
        result(nil)
      case "unfocus":
        self.textView.resignFirstResponder()
        result(nil)
      case "setBorderStyle":
        if let args = call.arguments as? [String: Any], let style = args["borderStyle"] as? String {
          self.applyBorderStyle(style)
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
        result(nil)
      case "getContentHeight":
        result(self.calculateContentHeight())
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func applyBorderStyle(_ style: String) {
    switch style {
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
  }
  
  func view() -> UIView { container }
  
  // Center text vertically when content is smaller than container
  private func centerTextVerticallyIfNeeded() {
    // Force layout to get accurate content size
    textView.layoutIfNeeded()
    
    let contentHeight = textView.contentSize.height
    let containerHeight = container.bounds.height
    
    // Only center if content is smaller than container
    if contentHeight > 0 && containerHeight > 0 && contentHeight < containerHeight {
      let topInset = (containerHeight - contentHeight) / 2.0
      textView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    } else {
      textView.contentInset = .zero
    }
  }
  
  // MARK: - UITextViewDelegate
  
  func textViewDidChange(_ textView: UITextView) {
    guard isEnabled else { return }
    
    // Update placeholder visibility
    placeholderLabel.isHidden = !textView.text.isEmpty
    
    // Send text to Flutter
    channel.invokeMethod("textChanged", arguments: ["text": textView.text ?? ""])
    
    // Update height and centering
    updateHeight()
    centerTextVerticallyIfNeeded()
    
    // Ensure cursor is visible
    scrollToCursor()
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    channel.invokeMethod("focusChanged", arguments: ["focused": true])
    // Keep text centered while editing if content is small
    centerTextVerticallyIfNeeded()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    channel.invokeMethod("focusChanged", arguments: ["focused": false])
    // Re-center text when editing ends if content is small
    centerTextVerticallyIfNeeded()
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    // For single line, return key submits
    if maxLines == 1 && text == "\n" {
      channel.invokeMethod("submitted", arguments: ["text": textView.text ?? ""])
      textView.resignFirstResponder()
      return false
    }
    return true
  }
  
  // MARK: - Height Management
  
  private func calculateContentHeight() -> CGFloat {
    let width = textView.bounds.width > 0 ? textView.bounds.width : container.bounds.width
    guard width > 0 else { return minHeight }
    
    // Calculate the size needed for current text
    let sizeThatFits = textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    
    // Add small buffer to prevent text clipping
    let heightWithBuffer = sizeThatFits.height + 4
    
    // Clamp to min/max
    return min(max(heightWithBuffer, minHeight), maxHeight)
  }
  
  private func updateHeight() {
    let newHeight = calculateContentHeight()
    channel.invokeMethod("heightChanged", arguments: ["height": newHeight])
  }
  
  private func scrollToCursor() {
    // Simple and reliable - just scroll to make selection visible
    if let selectedRange = textView.selectedTextRange {
      let cursorRect = textView.caretRect(for: selectedRange.end)
      if !cursorRect.isNull && !cursorRect.isInfinite {
        // Add some padding
        var rectToShow = cursorRect
        rectToShow.size.height += 10
        textView.scrollRectToVisible(rectToShow, animated: false)
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
