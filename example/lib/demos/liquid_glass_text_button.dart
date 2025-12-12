import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

class LiquidGlassTextButtonDemoPage extends StatefulWidget {
  const LiquidGlassTextButtonDemoPage({super.key});

  @override
  State<LiquidGlassTextButtonDemoPage> createState() =>
      _LiquidGlassTextButtonDemoPageState();
}

class _LiquidGlassTextButtonDemoPageState
    extends State<LiquidGlassTextButtonDemoPage> {
  String _status = 'Ready';

  void _handlePress(String buttonName) {
    setState(() {
      _status = '$buttonName pressed!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Text Button'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const Text(
              'FlutterFlow-Compatible Glass Button',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Direct 1:1 replica of the "Glass Red" demo button with native iOS liquid glass effect.',
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 32),
            
            // Status display
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _status,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Demo buttons
            const Text(
              'Examples:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Default blue
            Row(
              children: [
                const Text('Default (Blue):'),
                const Spacer(),
                CNButton(
                  label: 'Glass Button',
                  style: CNButtonStyle.glass,
                  onPressed: () => _handlePress('Blue Glass'),
                  shrinkWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Red (like demo)
            Row(
              children: [
                const Text('Red (Demo Style):'),
                const Spacer(),
                CNButton(
                  label: 'Glass Red',
                  style: CNButtonStyle.glass,
                  tint: const Color.fromARGB(255, 255, 0, 0),
                  onPressed: () => _handlePress('Glass Red'),
                  shrinkWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Green
            Row(
              children: [
                const Text('Green:'),
                const Spacer(),
                CNButton(
                  label: 'Glass Green',
                  style: CNButtonStyle.glass,
                  tint: CupertinoColors.systemGreen,
                  onPressed: () => _handlePress('Green Glass'),
                  shrinkWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Purple
            Row(
              children: [
                const Text('Purple:'),
                const Spacer(),
                CNButton(
                  label: 'Glass Purple',
                  style: CNButtonStyle.glass,
                  tint: CupertinoColors.systemPurple,
                  onPressed: () => _handlePress('Purple Glass'),
                  shrinkWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Orange
            Row(
              children: [
                const Text('Orange:'),
                const Spacer(),
                CNButton(
                  label: 'Glass Orange',
                  style: CNButtonStyle.glass,
                  tint: CupertinoColors.systemOrange,
                  onPressed: () => _handlePress('Orange Glass'),
                  shrinkWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Fixed width
            Row(
              children: [
                const Text('Fixed Width (200px):'),
                const Spacer(),
                SizedBox(
                  width: 200,
                  child: CNButton(
                    label: 'Wide Button',
                    style: CNButtonStyle.glass,
                    tint: CupertinoColors.systemTeal,
                    onPressed: () => _handlePress('Wide Glass'),
                    shrinkWrap: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Tall button
            Row(
              children: [
                const Text('Custom Height (60px):'),
                const Spacer(),
                CNButton(
                  label: 'Tall Button',
                  style: CNButtonStyle.glass,
                  tint: CupertinoColors.systemPink,
                  onPressed: () => _handlePress('Tall Glass'),
                  shrinkWrap: true,
                  height: 60.0,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Disabled
            Row(
              children: [
                const Text('Disabled:'),
                const Spacer(),
                CNButton(
                  label: 'Disabled',
                  style: CNButtonStyle.glass,
                  onPressed: null,
                  shrinkWrap: true,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            Container(
              height: 1,
              color: CupertinoColors.separator,
            ),
            const SizedBox(height: 24),
            
            // Features list
            const Text(
              'Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Native iOS liquid glass effect',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Customizable text color (tint)',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Auto-sizing or fixed width/height',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'FlutterFlow compatible with async callbacks',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Disabled state support',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Direct replica of demo "Glass Red" button',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: CupertinoColors.activeGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

