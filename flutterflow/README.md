# Cupertino Native Widgets for FlutterFlow

Modern, native iOS widgets with liquid glass effects for FlutterFlow.

## Widgets Included

1. **LiquidGlassTextField** - A translucent input field with native iOS liquid glass effect
2. **FFPopupMenuButton** - A native iOS popup menu button with glass styling

---

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

### 2. Add the Custom Widgets

1. In FlutterFlow, go to **Custom Code > Custom Widgets**
2. Create a new custom widget for each file
3. Copy the contents of each `.dart` file into the widget code
4. Save and compile

---

## Widget 1: LiquidGlassTextField

A modern, translucent input field with native iOS liquid glass effect, similar to the iMessage input field.

### Parameters

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

### Example Usage

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

---

## Widget 2: FFPopupMenuButton

A native iOS popup menu button with liquid glass styling.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `width` | `double` | ✅ | - | Width of the widget |
| `height` | `double` | ✅ | - | Height of the widget |
| `buttonLabel` | `String` | ❌ | - | Text label (use this OR iconName) |
| `iconName` | `String` | ❌ | - | SF Symbol name (use this OR buttonLabel) |
| `iconSize` | `double` | ❌ | 20.0 | Size of the icon |
| `iconColor` | `Color` | ❌ | - | Color of the icon |
| `itemLabels` | `List<String>` | ✅ | - | Menu item labels |
| `itemIcons` | `List<String>` | ❌ | - | SF Symbol names for items |
| `onSelected` | `Future Function(int)` | ❌ | - | Action when item selected |
| `isDarkMode` | `bool` | ❌ | `false` | Toggle dark/light mode |
| `tintColor` | `Color` | ❌ | - | Tint color for button |
| `buttonStyle` | `FFPopupMenuButtonStyle` | ❌ | `glass` | Visual style |

### Button Styles

- `plain` - Minimal, text-only style
- `gray` - Subtle gray background
- `tinted` - Tinted/filled text style
- `bordered` - Bordered button style
- `borderedProminent` - Prominent bordered style
- `filled` - Filled background style
- `glass` - Glass effect (iOS 26+)
- `prominentGlass` - More prominent glass effect

### Common SF Symbol Names

- `ellipsis` - Three dots (...)
- `plus` - Plus sign
- `gear` - Settings gear
- `chevron.down` - Down arrow
- `trash` - Trash can
- `pencil` - Edit pencil
- `square.and.arrow.up` - Share icon
- `doc.on.doc` - Copy icon

### Example Usage

```dart
// Icon button with glass effect
FFPopupMenuButton(
  width: 44,
  height: 44,
  iconName: 'ellipsis',
  iconSize: 20,
  itemLabels: ['Edit', 'Share', 'Delete'],
  itemIcons: ['pencil', 'square.and.arrow.up', 'trash'],
  buttonStyle: FFPopupMenuButtonStyle.glass,
  onSelected: (index) async {
    switch (index) {
      case 0:
        print('Edit selected');
        break;
      case 1:
        print('Share selected');
        break;
      case 2:
        print('Delete selected');
        break;
    }
  },
)

// Text button
FFPopupMenuButton(
  width: 120,
  height: 44,
  buttonLabel: 'Options',
  itemLabels: ['Option 1', 'Option 2', 'Option 3'],
  buttonStyle: FFPopupMenuButtonStyle.borderedProminent,
  tintColor: Colors.blue,
  onSelected: (index) async {
    print('Selected option: $index');
  },
)
```

---

## Features

### LiquidGlassTextField
- ✅ Native iOS liquid glass effect
- ✅ Multiline text support with auto-expansion
- ✅ Dark/Light mode toggle
- ✅ Customizable send button color
- ✅ Action callbacks for send and text change
- ✅ Required width/height for FlutterFlow compatibility
- ✅ Smooth animations

### FFPopupMenuButton
- ✅ Native iOS popup menu
- ✅ Glass and prominent glass styles
- ✅ Icon-only or text button modes
- ✅ SF Symbols support for icons
- ✅ Dark/Light mode toggle
- ✅ Customizable tint color
- ✅ Action callback with selected index

---

## Notes

- These widgets use native iOS platform views, so they will only show the glass effect on iOS devices
- On other platforms, they fall back to standard styled widgets
- The glass effect requires iOS 13+ (glass styles require iOS 26+)

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

### Popup menu not appearing
- Ensure `itemLabels` is not empty
- Check that the widget has proper width/height

