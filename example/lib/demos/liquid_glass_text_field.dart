import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

class LiquidGlassTextFieldDemoPage extends StatefulWidget {
  const LiquidGlassTextFieldDemoPage({super.key});

  @override
  State<LiquidGlassTextFieldDemoPage> createState() =>
      _LiquidGlassTextFieldDemoPageState();
}

class _LiquidGlassTextFieldDemoPageState
    extends State<LiquidGlassTextFieldDemoPage> {
  final TextEditingController _controller = TextEditingController();
  String _submittedText = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Input'),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Liquid Glass Input',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A translucent input field with native glass effect.',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // Demo 1: Standalone
                const Text(
                  'Standard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 12),
                LiquidGlassTextField(
                  controller: _controller,
                  placeholder: 'Type a message...',
                  maxLines: 10,
                  onChanged: (text) {
                    // Text field will auto-expand as you type
                  },
                ),

                const SizedBox(height: 32),

                // Demo 2: With Buttons (iMessage style)
                const Text(
                  'With Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 12),
                LiquidGlassTextField(
                  placeholder: 'Message',
                  maxLines: 10,
                  trailing: CNButton.icon(
                    icon: const CNSymbol(
                      'arrow.up',
                      size: 16,
                      color: CupertinoColors.white,
                    ),
                    size: 32,
                    style: CNButtonStyle.prominentGlass,
                    tint: CupertinoColors.activeBlue,
                    onPressed: () {},
                  ),
                ),

                const SizedBox(height: 32),

                if (_submittedText.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Last Submitted:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_submittedText),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

