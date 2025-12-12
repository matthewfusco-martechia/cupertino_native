# Voice Input Integration for Liquid Glass Message Input

## Overview

The `LiquidGlassMessageInputFF` widget now supports conditional voice button visibility based on the text field state and an app-level streaming state.

## Voice Button Behavior

The voice/microphone button automatically shows or hides based on these conditions:

- ✅ **Shows** when: Text field is **empty** AND `currentIsStreaming` is **false**
- ❌ **Hidden** when: Text field is **empty** AND `currentIsStreaming` is **true**
- ➡️ **Send button** replaces it when text field is **not empty** (regardless of streaming state)

## Parameters

### `currentIsStreaming` (bool?)

Controls whether the app is currently in a streaming state (e.g., AI response streaming).

- When `true`: Voice button is hidden (even if text is empty)
- When `false` or `null`: Voice button shows when text is empty
- **Use case**: Prevent voice input while AI is responding

### `onMicPressed` (Future<void> Function()?)

Callback triggered **after** iOS dictation is automatically started.

**⚠️ Important**: The widget automatically calls `CupertinoNative.startDictation()` when the mic button is pressed, which triggers iOS's native dictation UI (like iMessage). You don't need to manually start dictation in this callback.

Use this callback for additional actions like:
- Logging/analytics
- UI state updates
- Custom sound effects

```dart
LiquidGlassMessageInputFF(
  currentIsStreaming: FFAppState().isAIResponding,
  onMicPressed: () async {
    // Dictation is already started automatically!
    // This callback is for additional actions:
    print('User started dictation');
    FFAppState().update(() {
      FFAppState().isDictating = true;
    });
  },
  // ... other parameters
)
```

**How It Works:**

1. User taps the mic button
2. Widget calls `CupertinoNative.startDictation()` → iOS dictation UI appears
3. User speaks → Text appears in the field automatically
4. Your `onMicPressed` callback is called for custom logic

## iOS Dictation Integration

### Built-in iOS Dictation (Automatic)

The widget automatically uses iOS's built-in dictation feature (the same one you see when tapping the microphone on the iOS keyboard). **No additional setup or permissions required!**

This works exactly like iMessage:
1. User taps mic button
2. iOS dictation UI appears
3. User speaks
4. Text is automatically inserted into the field

**No Info.plist permissions needed** - iOS's keyboard dictation has its own system-level permissions that the user has already granted.

### How It Works Under the Hood

```swift
// The widget calls this private iOS API:
textView.perform(Selector(("startDictation")))
```

This triggers the exact same dictation interface that appears when you tap the microphone button on the iOS keyboard.

### Alternative: Custom Speech Recognition

If you need more control (e.g., custom UI, streaming results), you can use the `speech_to_text` package:

1. Add to `pubspec.yaml`:
```yaml
dependencies:
  speech_to_text: ^7.0.0
```

2. Add iOS permissions in `Info.plist`:
```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs speech recognition to convert your voice to text</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to your microphone for speech recognition</string>
```

3. Implement custom logic in `onMicPressed`:
```dart
import 'package:speech_to_text/speech_to_text.dart';

// Don't use the built-in dictation, implement your own
LiquidGlassMessageInputFF(
  onMicPressed: () async {
    // Your custom speech recognition logic here
    await _myCustomSpeechRecognition();
  },
)
```

## FlutterFlow Implementation

### Step 1: Create App State Variable

Create a boolean app state called `isAIResponding` or `currentIsStreaming`.

### Step 2: Configure Widget Parameters

```
• currentIsStreaming: FFAppState().currentIsStreaming
• onMicPressed: [Custom Action] startVoiceRecognition
• textController: [Your text controller]
```

### Step 3: Create Custom Action

Create a custom action `startVoiceRecognition` that:
1. Checks microphone permissions
2. Starts iOS speech recognition
3. Updates the text field when complete
4. Handles errors gracefully

### Step 4: Update Streaming State

When your AI starts responding:
```dart
FFAppState().update(() {
  FFAppState().currentIsStreaming = true;
});
```

When AI finishes:
```dart
FFAppState().update(() {
  FFAppState().currentIsStreaming = false;
});
```

## Demo

Run the example app to see the voice button behavior:

```bash
cd example
flutter run
```

Navigate to "Components → Liquid Glass Input" and toggle the "Streaming" button to see how the voice button appears/disappears.

## Notes

- The voice button automatically switches to a send button when text is entered
- When streaming is active, the input area only shows the send button (if there's text) or nothing (if text is empty)
- This prevents users from starting voice input while the app is busy with other operations
- The implementation is optimized for iOS's native speech recognition UI

