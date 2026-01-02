import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../channel/platform_view_guard.dart';
import '../channel/params.dart';
import '../cupertino_native_config.dart';
import '../style/sf_symbol.dart';

/// A segment control styled to look exactly like the liquid glass tab bar.
///
/// This component looks like CNTabBar (icons above labels, liquid glass effect)
/// but operates as a standalone segment control - no TabController needed.
/// Supports both tap and slide/drag gestures.
class CNLiquidGlassSegmentedControl extends StatefulWidget {
  /// Creates a liquid glass styled segment control.
  const CNLiquidGlassSegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onValueChanged,
    this.sfSymbols,
    this.tint,
    this.height = 90.0,
    this.shrinkWrap = true,
    this.active = true,
  });

  /// Segment labels to display.
  final List<String> labels;

  /// The index of the selected segment.
  final int selectedIndex;

  /// Called when the user selects a segment (tap or slide).
  final ValueChanged<int> onValueChanged;

  /// Optional SF Symbols for segments (displayed above labels).
  final List<CNSymbol>? sfSymbols;

  /// Accent/tint color for the selected segment icon.
  final Color? tint;

  /// Control height (defaults to 90 to provide ample touch target and mimic tab bar).
  final double height;

  /// If true, sizes the control to its intrinsic width.
  final bool shrinkWrap;

  /// Whether the platform view is active.
  final bool active;

  @override
  State<CNLiquidGlassSegmentedControl> createState() =>
      _CNLiquidGlassSegmentedControlState();
}

class _CNLiquidGlassSegmentedControlState
    extends State<CNLiquidGlassSegmentedControl>
    with PlatformViewGuard<CNLiquidGlassSegmentedControl> {
  MethodChannel? _channel;
  int? _lastSelected;
  bool? _lastIsDark;
  int? _lastTint;
  double? _intrinsicWidth;

  bool get _isDark => CupertinoTheme.of(context).brightness == Brightness.dark;

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CNLiquidGlassSegmentedControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPropsToNativeIfNeeded();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncBrightnessIfNeeded();
  }

  @override
  String computeConfigSignature() {
    return 'stable';
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active || !CupertinoNativeConfig.platformViewsEnabled) {
      if (!CupertinoNativeConfig.platformViewsEnabled) {
         // Fallback logic
         return SizedBox(
          height: widget.height,
          child: CupertinoSegmentedControl<int>(
            children: {
              for (var i = 0; i < widget.labels.length; i++)
                i: Text(widget.labels[i]),
            },
            groupValue: widget.selectedIndex,
            onValueChanged: widget.onValueChanged,
          ),
        );
      }
      return SizedBox(height: widget.height);
    }

    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS)) {
      // Fallback for non-Apple platforms
      return SizedBox(
        height: widget.height,
        child: CupertinoSegmentedControl<int>(
          children: {
            for (var i = 0; i < widget.labels.length; i++)
              i: Text(widget.labels[i]),
          },
          groupValue: widget.selectedIndex,
          onValueChanged: widget.onValueChanged,
        ),
      );
    }

    final platformView = getPlatformViewCached('CupertinoNativeLiquidGlassSegmentedControl');

    if (widget.shrinkWrap) {
      final width = _intrinsicWidth;
      return Center(
        child: SizedBox(
          height: widget.height,
          width: width ?? 320,
          child: platformView,
        ),
      );
    }

    return SizedBox(height: widget.height, child: platformView);
  }

  @override
  Widget buildPlatformView() {
    const viewType = 'CupertinoNativeLiquidGlassSegmentedControl';
    final creationParams = <String, dynamic>{
      'labels': widget.labels,
      'selectedIndex': widget.selectedIndex,
      'isDark': _isDark,
      'style': encodeStyle(context, tint: widget.tint),
      if (widget.sfSymbols != null)
        'sfSymbols': widget.sfSymbols!.map((e) => e.name).toList(),
    };

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: viewType,
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: creationParams,
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return AppKitView(
        viewType: viewType,
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: creationParams,
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
  }

  void _onPlatformViewCreated(int id) {
    final channel = MethodChannel('CupertinoNativeLiquidGlassSegmentedControl_$id');
    _channel = channel;
    channel.setMethodCallHandler(_onMethodCall);
    _cacheCurrentProps();
    _syncBrightnessIfNeeded();
    _requestIntrinsicSize();
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    if (call.method == 'valueChanged') {
      final args = call.arguments as Map?;
      final idx = (args?['index'] as num?)?.toInt();
      if (idx != null) {
        widget.onValueChanged(idx);
        _lastSelected = idx;
      }
    }
    return null;
  }

  void _cacheCurrentProps() {
    _lastSelected = widget.selectedIndex;
    _lastIsDark = _isDark;
    _lastTint = resolveColorToArgb(widget.tint, context);
  }

  Future<void> _syncPropsToNativeIfNeeded() async {
    final channel = _channel;
    if (channel == null) return;

    final tint = resolveColorToArgb(widget.tint, context);

    if (_lastSelected != widget.selectedIndex) {
      await channel.invokeMethod('setSelectedIndex', {
        'index': widget.selectedIndex,
      });
      _lastSelected = widget.selectedIndex;
    }
    if (_lastTint != tint && tint != null) {
      await channel.invokeMethod('setStyle', {'tint': tint});
      _lastTint = tint;
    }
  }

  Future<void> _requestIntrinsicSize() async {
    final channel = _channel;
    if (channel == null) return;
    try {
      final size = await channel.invokeMethod<Map>('getIntrinsicSize');
      final w = (size?['width'] as num?)?.toDouble();
      if (w != null && mounted) {
        setState(() => _intrinsicWidth = w);
      }
    } catch (_) {}
  }

  Future<void> _syncBrightnessIfNeeded() async {
    final channel = _channel;
    if (channel == null) return;
    final isDark = _isDark;
    final tint = resolveColorToArgb(widget.tint, context);
    if (_lastIsDark != isDark) {
      await channel.invokeMethod('setBrightness', {'isDark': isDark});
      _lastIsDark = isDark;
    }
    if (_lastTint != tint && tint != null) {
      await channel.invokeMethod('setStyle', {'tint': tint});
      _lastTint = tint;
    }
  }
}
