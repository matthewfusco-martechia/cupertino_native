// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

class LiquidGlassContainer2Row extends StatefulWidget {
  const LiquidGlassContainer2Row({
    super.key,
    this.width,
    this.height,
    this.containerRadius = 16.0,
    required this.line1Text,
    this.line1Size = 20.0,
    this.line1Color,
    required this.line2Text,
    this.line2Size = 14.0,
    this.line2Color,
    this.tintColor,
    this.glassStyle = 'regular',
    this.isDarkMode = false,
    this.onPressed,
  });

  final double? width;
  final double? height;
  final double containerRadius;
  final String line1Text;
  final double line1Size;
  final Color? line1Color;
  final String line2Text;
  final double line2Size;
  final Color? line2Color;
  final Color? tintColor;
  final String glassStyle;
  final bool isDarkMode;
  final Future Function()? onPressed;

  @override
  State<LiquidGlassContainer2Row> createState() =>
      _LiquidGlassContainer2RowState();
}

class _LiquidGlassContainer2RowState extends State<LiquidGlassContainer2Row> {
  CNGlassStyle _resolveGlassStyle(String style) {
    switch (style.toLowerCase()) {
      case 'regular':
        return CNGlassStyle.regular;
      case 'clear':
        return CNGlassStyle.clear;
      default:
        return CNGlassStyle.regular;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLine1Color =
        widget.line1Color ?? (widget.isDarkMode ? Colors.white : Colors.black);
    final effectiveLine2Color = widget.line2Color ??
        (widget.isDarkMode ? Colors.white70 : Colors.black54);

    return Theme(
      data: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: Container(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: CNGlassEffectContainer(
                  cornerRadius: widget.containerRadius,
                  glassStyle: _resolveGlassStyle(widget.glassStyle),
                  tint: widget.tintColor,
                  interactive: widget.onPressed != null,
                  onTap: widget.onPressed != null
                      ? () => widget.onPressed?.call()
                      : null,
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.line1Text,
                          style: TextStyle(
                            fontSize: widget.line1Size,
                            fontWeight: FontWeight.bold,
                            color: effectiveLine1Color,
                            fontFamily: 'SF Pro Text',
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          widget.line2Text,
                          style: TextStyle(
                            fontSize: widget.line2Size,
                            fontWeight: FontWeight.normal,
                            color: effectiveLine2Color,
                            fontFamily: 'SF Pro Text',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
