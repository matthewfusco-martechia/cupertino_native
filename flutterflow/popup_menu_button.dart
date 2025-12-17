// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:cupertino_native/cupertino_native.dart';
// Required package import - add cupertino_native to your pubspec.yaml:
// dependencies:
//   cupertino_native: ^latest_version

// ============================================================================
// HELPER CLASSES (from cupertino_native package)
// These are included here for FlutterFlow standalone usage
// ============================================================================

/// Converts a [Color] to ARGB int (0xAARRGGBB).
int? _argbFromColor(Color? color) {
  if (color == null) return null;
  final a = (color.a * 255.0).round() & 0xff;
  final r = (color.r * 255.0).round() & 0xff;
  final g = (color.g * 255.0).round() & 0xff;
  final b = (color.b * 255.0).round() & 0xff;
  return (a << 24) | (r << 16) | (g << 8) | b;
}

/// Resolves a possibly dynamic Cupertino color to a concrete ARGB int.
int? _resolveColorToArgb(Color? color, BuildContext context) {
  if (color == null) return null;
  if (color is CupertinoDynamicColor) {
    final resolved = color.resolveFrom(context);
    return _argbFromColor(resolved);
  }
  return _argbFromColor(color);
}

/// Creates a unified style map for platform views.
Map<String, dynamic> _encodeStyle(
  BuildContext context, {
  Color? tint,
}) {
  final style = <String, dynamic>{};
  final tintInt = _resolveColorToArgb(tint, context);
  if (tintInt != null) style['tint'] = tintInt;
  return style;
}

/// Visual styles for the popup menu button.
enum FFPopupMenuButtonStyle {
  /// Minimal, text-only style.
  plain,

  /// Subtle gray background style.
  gray,

  /// Tinted/filled text style.
  tinted,

  /// Bordered button style.
  bordered,

  /// Prominent bordered (accent-colored) style.
  borderedProminent,

  /// Filled background style.
  filled,

  /// Glass effect (iOS 26+).
  glass,

  /// More prominent glass effect (iOS 26+).
  prominentGlass,
}

/// Rendering modes for SF Symbols.
enum FFSymbolRenderingMode {
  /// Single-color glyph.
  monochrome,

  /// Hierarchical (shaded) rendering.
  hierarchical,

  /// Uses provided palette colors.
  palette,

  /// Uses built-in multicolor assets.
  multicolor,
}

/// Describes an SF Symbol to render natively.
class FFSymbol {
  /// The SF Symbol name, e.g. `chevron.down`.
  final String name;

  /// Desired point size for the symbol.
  final double size;

  /// Preferred icon color (for monochrome/hierarchical modes).
  final Color? color;

  /// Palette colors for multi-color/palette modes.
  final List<Color>? paletteColors;

  /// Optional per-icon rendering mode.
  final FFSymbolRenderingMode? mode;

  /// Whether to enable the built-in gradient when available.
  final bool? gradient;

  /// Creates a symbol description for native rendering.
  const FFSymbol(
    this.name, {
    this.size = 24.0,
    this.color,
    this.paletteColors,
    this.mode,
    this.gradient,
  });
}

/// Base type for entries in a popup menu.
abstract class FFPopupMenuEntry {
  const FFPopupMenuEntry();
}

/// A selectable item in a popup menu.
class FFPopupMenuItem extends FFPopupMenuEntry {
  const FFPopupMenuItem({
    required this.label,
    this.icon,
    this.enabled = true,
  });

  /// Display label for the item.
  final String label;

  /// Optional SF Symbol shown before the label.
  final FFSymbol? icon;

  /// Whether the item can be selected.
  final bool enabled;
}

/// A visual divider between popup menu items.
class FFPopupMenuDivider extends FFPopupMenuEntry {
  const FFPopupMenuDivider();
}

// ============================================================================
// MAIN WIDGET
// ============================================================================

/// A Cupertino-native popup menu button for FlutterFlow.
///
/// This widget creates a native iOS popup menu button with liquid glass effect.
///
/// ## Setup Instructions:
/// 1. Add `cupertino_native` package to your pubspec.yaml
/// 2. Copy this file to your FlutterFlow custom widgets
/// 3. Configure the parameters in FlutterFlow
///
/// ## Parameters:
/// - [width]: Required width of the widget
/// - [height]: Required height of the widget
/// - [buttonLabel]: Text label for the button (use this OR iconName)
/// - [iconName]: SF Symbol name for icon button (use this OR buttonLabel)
/// - [items]: List of menu items (labels)
/// - [onSelected]: Action when an item is selected
/// - [isDarkMode]: Toggle between dark and light mode
/// - [tintColor]: Tint color for the button
/// - [buttonStyle]: Visual style of the button
class FFPopupMenuButton extends StatefulWidget {
  const FFPopupMenuButton({
    super.key,
    required this.width,
    required this.height,
    this.buttonLabel,
    this.iconName,
    this.iconSize = 20.0,
    this.iconColor,
    required this.itemLabels,
    this.itemIcons,
    this.onSelected,
    this.isDarkMode = false,
    this.tintColor,
    this.buttonStyle = 'glass',
  });

  /// The width of the widget (required by FlutterFlow).
  final double width;

  /// The height of the widget (required by FlutterFlow).
  final double height;

  /// Text label for the button. Use this OR [iconName], not both.
  final String? buttonLabel;

  /// SF Symbol name for icon-only button. Use this OR [buttonLabel], not both.
  /// Example: 'ellipsis', 'plus', 'gear', 'chevron.down'
  final String? iconName;

  /// Size of the icon when using [iconName].
  final double iconSize;

  /// Color of the icon when using [iconName].
  final Color? iconColor;

  /// List of menu item labels.
  final List<String> itemLabels;

  /// Optional list of SF Symbol names for each menu item.
  /// Must match length of [itemLabels] if provided.
  final List<String>? itemIcons;

  /// Action to perform when an item is selected.
  /// Receives the index of the selected item.
  final Future<dynamic> Function(int index)? onSelected;

  /// Whether to use dark mode styling.
  final bool isDarkMode;

  /// Tint color for the button.
  final Color? tintColor;

  /// Visual style of the button.
  /// Options: 'plain', 'gray', 'tinted', 'bordered', 'borderedProminent', 'filled', 'glass', 'prominentGlass'
  final String buttonStyle;

  /// Whether this is an icon button (no label).
  bool get isIconButton => iconName != null && buttonLabel == null;

  @override
  State<FFPopupMenuButton> createState() => _FFPopupMenuButtonState();
}

class _FFPopupMenuButtonState extends State<FFPopupMenuButton> {
  MethodChannel? _channel;
  bool? _lastIsDark;
  int? _lastTint;
  String? _lastTitle;
  String? _lastIconName;
  double? _lastIconSize;
  int? _lastIconColor;
  String? _lastStyle;
  Offset? _downPosition;
  bool _pressed = false;

  Color? get _effectiveTint =>
      widget.tintColor ?? CupertinoTheme.of(context).primaryColor;

  @override
  void didUpdateWidget(covariant FFPopupMenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPropsToNativeIfNeeded();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncBrightnessIfNeeded();
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS)) {
      // Fallback Flutter implementation
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: CupertinoButton(
          padding: widget.isIconButton
              ? const EdgeInsets.all(4)
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          onPressed: () async {
            final selected = await showCupertinoModalPopup<int>(
              context: context,
              builder: (ctx) {
                return CupertinoActionSheet(
                  title: widget.buttonLabel != null
                      ? Text(widget.buttonLabel!)
                      : null,
                  actions: [
                    for (var i = 0; i < widget.itemLabels.length; i++)
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.of(ctx).pop(i),
                        child: Text(widget.itemLabels[i]),
                      ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => Navigator.of(ctx).pop(),
                    isDefaultAction: true,
                    child: const Text('Cancel'),
                  ),
                );
              },
            );
            if (selected != null) {
              widget.onSelected?.call(selected);
            }
          },
          child: widget.isIconButton
              ? Icon(CupertinoIcons.ellipsis, size: widget.iconSize)
              : Text(widget.buttonLabel ?? ''),
        ),
      );
    }

    const viewType = 'CupertinoNativePopupMenuButton';

    // Build menu items
    final labels = <String>[];
    final symbols = <String>[];
    final isDivider = <bool>[];
    final enabled = <bool>[];
    final sizes = <double?>[];
    final colors = <int?>[];
    final modes = <String?>[];
    final palettes = <List<int?>?>[];
    final gradients = <bool?>[];

    for (var i = 0; i < widget.itemLabels.length; i++) {
      labels.add(widget.itemLabels[i]);
      symbols.add(widget.itemIcons != null && i < widget.itemIcons!.length
          ? widget.itemIcons![i]
          : '');
      isDivider.add(false);
      enabled.add(true);
      sizes.add(null);
      colors.add(null);
      modes.add(null);
      palettes.add(null);
      gradients.add(null);
    }

    final creationParams = <String, dynamic>{
      if (widget.buttonLabel != null) 'buttonTitle': widget.buttonLabel,
      if (widget.iconName != null) 'buttonIconName': widget.iconName,
      if (widget.iconName != null) 'buttonIconSize': widget.iconSize,
      if (widget.iconColor != null)
        'buttonIconColor': _resolveColorToArgb(widget.iconColor, context),
      if (widget.isIconButton) 'round': true,
      'buttonStyle': widget.buttonStyle,
      'labels': labels,
      'sfSymbols': symbols,
      'isDivider': isDivider,
      'enabled': enabled,
      'sfSymbolSizes': sizes,
      'sfSymbolColors': colors,
      'sfSymbolRenderingModes': modes,
      'sfSymbolPaletteColors': palettes,
      'sfSymbolGradientEnabled': gradients,
      'isDark': widget.isDarkMode,
      'style': _encodeStyle(context, tint: _effectiveTint),
    };

    final platformView = defaultTargetPlatform == TargetPlatform.iOS
        ? UiKitView(
            viewType: viewType,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onCreated,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
            },
          )
        : AppKitView(
            viewType: viewType,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onCreated,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
            },
          );

    return Listener(
      onPointerDown: (e) {
        _downPosition = e.position;
        _setPressed(true);
      },
      onPointerMove: (e) {
        final start = _downPosition;
        if (start != null && _pressed) {
          final moved = (e.position - start).distance;
          if (moved > kTouchSlop) {
            _setPressed(false);
          }
        }
      },
      onPointerUp: (_) {
        _setPressed(false);
        _downPosition = null;
      },
      onPointerCancel: (_) {
        _setPressed(false);
        _downPosition = null;
      },
      child: Container(
        height: widget.height,
        constraints: BoxConstraints(minWidth: widget.width),
        child: platformView,
      ),
    );
  }

  void _onCreated(int id) {
    final ch = MethodChannel('CupertinoNativePopupMenuButton_$id');
    _channel = ch;
    ch.setMethodCallHandler(_onMethodCall);
    _lastTint = _resolveColorToArgb(_effectiveTint, context);
    _lastIsDark = widget.isDarkMode;
    _lastTitle = widget.buttonLabel;
    _lastIconName = widget.iconName;
    _lastIconSize = widget.iconSize;
    _lastIconColor = _resolveColorToArgb(widget.iconColor, context);
    _lastStyle = widget.buttonStyle;
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    if (call.method == 'itemSelected') {
      final args = call.arguments as Map?;
      final idx = (args?['index'] as num?)?.toInt();
      if (idx != null) {
        widget.onSelected?.call(idx);
      }
    }
    return null;
  }

  Future<void> _syncPropsToNativeIfNeeded() async {
    final ch = _channel;
    if (ch == null) return;

    // Build updated menu items
    final updLabels = <String>[];
    final updSymbols = <String>[];
    final updIsDivider = <bool>[];
    final updEnabled = <bool>[];
    final updSizes = <double?>[];
    final updColors = <int?>[];
    final updModes = <String?>[];
    final updPalettes = <List<int?>?>[];
    final updGradients = <bool?>[];

    for (var i = 0; i < widget.itemLabels.length; i++) {
      updLabels.add(widget.itemLabels[i]);
      updSymbols.add(widget.itemIcons != null && i < widget.itemIcons!.length
          ? widget.itemIcons![i]
          : '');
      updIsDivider.add(false);
      updEnabled.add(true);
      updSizes.add(null);
      updColors.add(null);
      updModes.add(null);
      updPalettes.add(null);
      updGradients.add(null);
    }

    final tint = _resolveColorToArgb(_effectiveTint, context);
    final preIconName = widget.iconName;
    final preIconSize = widget.iconSize;
    final preIconColor = _resolveColorToArgb(widget.iconColor, context);

    if (_lastTint != tint && tint != null) {
      await ch.invokeMethod('setStyle', {'tint': tint});
      _lastTint = tint;
    }
    if (_lastStyle != widget.buttonStyle) {
      await ch.invokeMethod('setStyle', {
        'buttonStyle': widget.buttonStyle,
      });
      _lastStyle = widget.buttonStyle;
    }
    if (_lastTitle != widget.buttonLabel && widget.buttonLabel != null) {
      await ch.invokeMethod('setButtonTitle', {'title': widget.buttonLabel});
      _lastTitle = widget.buttonLabel;
    }

    if (widget.isIconButton) {
      final updates = <String, dynamic>{};
      if (_lastIconName != preIconName && preIconName != null) {
        updates['buttonIconName'] = preIconName;
        _lastIconName = preIconName;
      }
      if (_lastIconSize != preIconSize) {
        updates['buttonIconSize'] = preIconSize;
        _lastIconSize = preIconSize;
      }
      if (_lastIconColor != preIconColor && preIconColor != null) {
        updates['buttonIconColor'] = preIconColor;
        _lastIconColor = preIconColor;
      }
      if (updates.isNotEmpty) {
        await ch.invokeMethod('setButtonIcon', updates);
      }
    }

    await ch.invokeMethod('setItems', {
      'labels': updLabels,
      'sfSymbols': updSymbols,
      'isDivider': updIsDivider,
      'enabled': updEnabled,
      'sfSymbolSizes': updSizes,
      'sfSymbolColors': updColors,
      'sfSymbolRenderingModes': updModes,
      'sfSymbolPaletteColors': updPalettes,
      'sfSymbolGradientEnabled': updGradients,
    });
  }

  Future<void> _syncBrightnessIfNeeded() async {
    final ch = _channel;
    if (ch == null) return;
    final isDark = widget.isDarkMode;
    final tint = _resolveColorToArgb(_effectiveTint, context);
    if (_lastIsDark != isDark) {
      await ch.invokeMethod('setBrightness', {'isDark': isDark});
      _lastIsDark = isDark;
    }
    if (_lastTint != tint && tint != null) {
      await ch.invokeMethod('setStyle', {'tint': tint});
      _lastTint = tint;
    }
  }

  Future<void> _setPressed(bool pressed) async {
    final ch = _channel;
    if (ch == null) return;
    if (_pressed == pressed) return;
    _pressed = pressed;
    try {
      await ch.invokeMethod('setPressed', {'pressed': pressed});
    } catch (_) {}
  }
}


