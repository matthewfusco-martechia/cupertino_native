# iOS Dictation Debugging Guide

## Expected Behavior

When you tap the microphone button in `LiquidGlassMessageInput`:

1. ✅ Keyboard appears (if not already visible)
2. ✅ iOS dictation UI activates - you should see:
   - A purple/blue waveform animation at the bottom of the screen
   - OR a microphone icon pulsing
   - OR the dictation interface replacing the keyboard temporarily
3. ✅ You can speak and see your words appear in real-time
4. ✅ Tap "Done" and the text is inserted into the field

## Current Issue

**Symptom**: Tapping the mic button only brings up the keyboard, dictation doesn't start.

## Why This Might Happen

### 1. **Flutter's CupertinoTextField Limitation**
`CupertinoTextField` is a Flutter widget that wraps native iOS text input, but it may not fully expose the `startDictation` selector in a way that's accessible programmatically.

### 2. **Timing Issues**
The keyboard needs to be fully rendered before dictation can be triggered. We've added delays (500ms for initial focus, 100ms if already focused).

### 3. **iOS Security**
Apple restricts programmatic triggering of dictation for privacy/security reasons. The `startDictation` selector is a private API.

## Solutions to Try

### Option 1: Increase Delay (Current Implementation)
```dart
// In _handleMicPressed()
await Future.delayed(const Duration(milliseconds: 500)); // Try 800ms or 1000ms
```

### Option 2: Use Native CNInput Instead
Replace `CupertinoTextField` with our native `CNInput` component:

```dart
// Instead of:
CupertinoTextField(
  controller: _controller,
  focusNode: _focusNode,
  // ...
)

// Use:
CNInput(
  controller: _controller,
  // ...
)
```

Then in `CNInput`, we can directly call `startDictation()` on the native `UITextView`.

### Option 3: Alternative Approach - Simulate Keyboard Tap
Instead of programmatically triggering dictation, show a visual indicator that tells users to tap the mic button on the keyboard:

```dart
Future<void> _handleMicPressed() async {
  if (!_focusNode.hasFocus) {
    _focusNode.requestFocus();
  }
  
  // Show tooltip or animation pointing to keyboard mic button
  _showDictationHint();
  
  widget.onStopPressed?.call();
}
```

### Option 4: Use speech_to_text Package
Use a Flutter package that handles iOS speech recognition with proper permissions:

```yaml
dependencies:
  speech_to_text: ^7.0.0
```

Then implement custom dictation UI.

## Debug Logs to Check

Run the app and check Xcode console for these messages:

```
✅ Found first responder: UITextField
✅ Calling startDictation on first responder
```

Or you might see:
```
⚠️ First responder doesn't respond to startDictation selector
✅ Sent startDictation action through responder chain
```

Or worst case:
```
❌ No first responder found - trying sendAction anyway
```

## Testing the Implementation

1. **Run with Xcode console open**:
   ```bash
   cd example
   flutter run
   ```

2. **Watch for debug prints** when you tap the mic button

3. **Check if dictation starts**:
   - Look for purple waveform animation
   - Try speaking
   - See if text appears

4. **If nothing happens**, try:
   - Increasing the delay to 1000ms
   - Manually tapping the keyboard mic button (to verify dictation works at all)
   - Checking iOS Settings → General → Keyboard → Enable Dictation

## Workaround for FlutterFlow

If programmatic dictation doesn't work reliably, consider this UX:

1. **Mic button focuses the field**
2. **Show a toast/hint**: "Tap the mic button on your keyboard to dictate"
3. **Maybe add a brief animation** pointing to where the keyboard mic button will appear

This is actually more intuitive for users who are already familiar with iOS keyboards!

## Alternative: Change to Record Button

Instead of trying to trigger iOS dictation, you could:

1. Change the mic button to a "Record" button
2. Use `speech_to_text` package for custom speech recognition
3. Show your own custom UI while recording
4. Give you more control over the experience

This requires adding permissions to Info.plist but gives you a better, more controllable UX.


