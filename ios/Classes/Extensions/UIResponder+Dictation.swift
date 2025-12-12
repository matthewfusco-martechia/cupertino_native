import UIKit

extension UIResponder {
  /// Trigger dictation on any text input responder
  @objc func triggerDictation() {
    // Use the private API selector that the keyboard uses
    if self.responds(to: Selector(("dictationRecognitionDidEnd"))) {
      // This is a callback, not the start method
    }
    
    // The correct selector to start dictation
    if self.responds(to: Selector(("startDictation"))) {
      self.perform(Selector(("startDictation")))
    }
  }
  
  /// Alternative method: Insert dictation placeholder
  @objc func insertDictationResult(_ result: Any) {
    if let textField = self as? UITextField {
      textField.insertText("")
    } else if let textView = self as? UITextView {
      textView.insertText("")
    }
  }
}

