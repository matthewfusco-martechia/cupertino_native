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
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  String _submittedText = '';

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
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
                  'Send button appears when you type!',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // Demo 1: Standard (auto-show send button)
                const Text(
                  'Standard (type to see send button)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 12),
                LiquidGlassTextField(
                  controller: _controller1,
                  placeholder: 'Type a message...',
                  maxLines: 10,
                  onSubmitted: (text) {
                    setState(() {
                      _submittedText = text;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Demo 2: Custom icon colors
                const Text(
                  'Custom Icon Colors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 12),
                LiquidGlassTextField(
                  controller: _controller2,
                  placeholder: 'Green button, black icon...',
                  maxLines: 5,
                  trailingIconColor: CupertinoColors.systemGreen,
                  trailingIconInnerColor: CupertinoColors.black,
                  onSubmitted: (text) {
                    setState(() {
                      _submittedText = text;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Demo 3: Custom icon name
                const Text(
                  'Custom Icon (paperplane)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                      color: CupertinoColors.white,
                    ),
                ),
                const SizedBox(height: 12),
                LiquidGlassTextField(
                  controller: _controller3,
                  placeholder: 'Send with paperplane...',
                  maxLines: 5,
                  trailingIconName: 'paperplane.fill',
                  trailingIconColor: CupertinoColors.systemPurple,
                  onSubmitted: (text) {
                    setState(() {
                      _submittedText = text;
                    });
                  },
                ),

                const SizedBox(height: 32),

                if (_submittedText.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground.withValues(alpha: 0.8),
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
