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

class FFLiquidGlassContainer1Row extends StatefulWidget {
  const FFLiquidGlassContainer1Row({
    super.key,
    this.width,
    this.height,
    this.containerRadius = 16.0,
    required this.text,
    this.fontSize = 20.0,
    this.textColor,
    this.tintColor,
    this.glassStyle = 'regular',
    this.isDarkMode = false,
    this.onPressed,
  });

  final double? width;
  final double? height;
  final double containerRadius;
  final String text;
  final double fontSize;
  final Color? textColor;
  final Color? tintColor;
  final String glassStyle;
  final bool isDarkMode;
  final Future Function()? onPressed;

  @override
  State<FFLiquidGlassContainer1Row> createState() =>
      _FFLiquidGlassContainer1RowState();
}

class _FFLiquidGlassContainer1RowState
    extends State<FFLiquidGlassContainer1Row> {
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
    final effectiveTextColor =
        widget.textColor ?? (widget.isDarkMode ? Colors.white : Colors.black);

    return Theme(
      data: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        child: SizedBox(
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
                  child: const SizedBox(),
                ),
              ),
              IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                      color: effectiveTextColor,
                      fontFamily: 'SF Pro Text',
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
