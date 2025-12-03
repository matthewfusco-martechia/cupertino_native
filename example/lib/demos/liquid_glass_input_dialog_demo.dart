import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:cupertino_native/components/liquid_glass_container_1_row.dart';

// This mimics the Custom Action function for the demo
Future<String?> _showLiquidGlassInputDialog(
  BuildContext context, {
  required String title,
  String? message,
  String? initialText,
  String placeholder = 'Conversation name',
  String confirmButtonText = 'Rename',
  String cancelButtonText = 'Cancel',
}) async {
  final TextEditingController controller =
      TextEditingController(text: initialText);

  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              children: [
                // Glass Background
                Positioned.fill(
                  child: CNGlassEffectContainer(
                    glassStyle: CNGlassStyle.regular, // Use regular with heavy tint
                    cornerRadius: 24,
                    // Deep charcoal tint to match screenshot
                    tint: const Color(0xFF1C1C1E).withOpacity(0.75),
                    interactive: true, // Make the background interactive/liquid
                    child: const SizedBox(),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontFamily: 'SF Pro Text',
                          letterSpacing: -0.4,
                        ),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                            fontFamily: 'SF Pro Text',
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      // Custom Input Field
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A3A3C).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CupertinoTextField(
                          controller: controller,
                          placeholder: placeholder,
                          placeholderStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontFamily: 'SF Pro Text',
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'SF Pro Text',
                            fontSize: 17,
                          ),
                          decoration: null, // Remove default border
                          cursorColor: const Color(0xFF0A84FF), // iOS Blue
                          autofocus: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _DialogButton(
                              text: cancelButtonText,
                              onPressed: () => Navigator.pop(ctx),
                              isPrimary: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DialogButton(
                              text: confirmButtonText,
                              onPressed: () =>
                                  Navigator.pop(ctx, controller.text),
                              isPrimary: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (ctx, anim1, anim2, child) {
      final curvedAnim = CurvedAnimation(
        parent: anim1,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      );
      return ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnim),
        child: FadeTransition(
          opacity: curvedAnim,
          child: child,
        ),
      );
    },
  );
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.text,
    required this.onPressed,
    required this.isPrimary,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        children: [
          Positioned.fill(
            child: CNGlassEffectContainer(
              cornerRadius: 14,
              glassStyle: CNGlassStyle.regular,
              // Darker tint for buttons to stand out from dialog background
              tint: isPrimary
                  ? const Color(0xFF3A3A3C).withOpacity(0.8)
                  : const Color(0xFF2C2C2E).withOpacity(0.5),
              interactive: true,
              onTap: onPressed,
              child: const SizedBox(),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFamily: 'SF Pro Text',
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LiquidGlassInputDialogDemo extends StatefulWidget {
  const LiquidGlassInputDialogDemo({super.key});

  @override
  State<LiquidGlassInputDialogDemo> createState() =>
      _LiquidGlassInputDialogDemoState();
}

class _LiquidGlassInputDialogDemoState
    extends State<LiquidGlassInputDialogDemo> {
  String _chatName = 'Project Alpha';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Input Dialog Action'),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Name:',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(color: CupertinoColors.secondaryLabel),
                ),
                const SizedBox(height: 8),
                Text(
                  _chatName,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle,
                ),
                const SizedBox(height: 48),
                LiquidGlassContainer1Row(
                  text: 'Rename Chat',
                  fontSize: 17,
                  onPressed: () async {
                    final newName = await _showLiquidGlassInputDialog(
                      context,
                      title: 'Rename Chat',
                      // message: 'Enter a new name for this project.',
                      initialText: _chatName,
                      placeholder: 'Chat Name',
                      confirmButtonText: 'Rename',
                    );

                    if (newName != null && newName.isNotEmpty) {
                      setState(() {
                        _chatName = newName;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
