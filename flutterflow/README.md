# Liquid Glass Text Field for FlutterFlow

A modern, translucent input field with native iOS liquid glass effect, similar to the iMessage input field.

## Setup Instructions

### 1. Add the cupertino_native package

In your FlutterFlow project, go to **Settings > Dependencies** and add:

```yaml
cupertino_native: ^latest_version
```

Or add it directly to your `pubspec.yaml`:

```yaml
dependencies:
  cupertino_native: ^1.0.0  # Use latest version
```

### 2. Add the Custom Widget

1. In FlutterFlow, go to **Custom Code > Custom Widgets**
2. Create a new custom widget
3. Copy the contents of `liquid_glass_text_field.dart` into the widget code
4. Save and compile

### 3. Use the Widget

Drag the custom widget onto your page and configure the parameters:

## Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `width` | `double` | ✅ | - | Width of the widget |
| `height` | `double` | ✅ | - | Minimum height of the widget |
| `placeholder` | `String` | ❌ | "Message" | Placeholder text |
| `isDarkMode` | `bool` | ❌ | `false` | Toggle dark/light mode |
| `trailingIconColor` | `Color` | ❌ | Blue | Color of send button |
| `onTrailingPressed` | `Future Function()` | ❌ | - | Action when send pressed |
| `onTextChanged` | `Future Function(String)` | ❌ | - | Action when text changes |
| `maxLines` | `int` | ❌ | 10 | Max lines before scrolling |
| `cornerRadius` | `double` | ❌ | height/2 | Corner radius (pill shape) |

## Example Usage in FlutterFlow

```dart
LiquidGlassTextField(
  width: MediaQuery.of(context).size.width - 32,
  height: 50,
  placeholder: 'Type a message...',
  isDarkMode: false,
  trailingIconColor: Colors.blue,
  onTrailingPressed: () async {
    // Handle send button press
    print('Send pressed!');
  },
  onTextChanged: (text) async {
    // Handle text changes
    print('Text: $text');
  },
)
```

## Features

- ✅ Native iOS liquid glass effect
- ✅ Multiline text support with auto-expansion
- ✅ Dark/Light mode toggle
- ✅ Customizable send button color
- ✅ Action callbacks for send and text change
- ✅ Required width/height for FlutterFlow compatibility
- ✅ Smooth animations

## Notes

- This widget uses native iOS platform views, so it will only show the glass effect on iOS devices
- On other platforms, it falls back to a standard styled text field
- The glass effect requires iOS 13+

## Troubleshooting

### Widget not showing glass effect
- Make sure you're running on an iOS device or simulator
- Ensure `cupertino_native` package is properly installed

### Text not visible
- Check the `isDarkMode` parameter matches your background
- For dark backgrounds, set `isDarkMode: true`

### Actions not firing
- Ensure your action functions are `async` and return `Future`
- Check that the functions are properly connected in FlutterFlow

