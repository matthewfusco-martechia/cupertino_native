import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

class LiquidGlassSegmentedControlDemoPage extends StatefulWidget {
  const LiquidGlassSegmentedControlDemoPage({super.key});

  @override
  State<LiquidGlassSegmentedControlDemoPage> createState() =>
      _LiquidGlassSegmentedControlDemoPageState();
}

class _LiquidGlassSegmentedControlDemoPageState
    extends State<LiquidGlassSegmentedControlDemoPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Segment Control'),
      ),
      child: Stack(
        children: [
          // Background content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selected: ${_selectedIndex == 0 ? "Available" : "Downloaded"}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Looks like tab bar, operates like segment control',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try sliding/dragging across!',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No TabController needed - FlutterFlow compatible!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.activeBlue.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Liquid glass segment control at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CNLiquidGlassSegmentedControl(
                  labels: const ['Available', 'Downloaded'],
                  sfSymbols: const [
                    CNSymbol('square.grid.2x2'),
                    CNSymbol('arrow.down.circle.fill'),
                  ],
                  selectedIndex: _selectedIndex,
                  shrinkWrap: true,
                  onValueChanged: (index) {
                    setState(() => _selectedIndex = index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
