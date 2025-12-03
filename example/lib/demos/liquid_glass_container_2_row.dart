import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/components/liquid_glass_container_2_row.dart';

class LiquidGlassContainer2RowDemo extends StatelessWidget {
  const LiquidGlassContainer2RowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Container (2 Rows)'),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Standard Example
                LiquidGlassContainer2Row(
                  line1Text: 'Explain Quantum',
                  line2Text: 'Complex scientific concept',
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Tapped!'),
                        content: const Text('You tapped the glass container.'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                // Custom Radius & Colors
                LiquidGlassContainer2Row(
                  containerRadius: 24.0,
                  line1Text: 'Design System',
                  line1Color: CupertinoColors.activeBlue,
                  line2Text: 'Updated 2 hours ago',
                  line2Color: CupertinoColors.systemGrey,
                  line1Size: 20,
                  line2Size: 14,
                ),
                const SizedBox(height: 24),

                // Darker Style Simulation
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const LiquidGlassContainer2Row(
                    line1Text: 'Dark Mode Context',
                    line1Color: CupertinoColors.white,
                    line2Text: 'Glass adapts to background',
                    line2Color: CupertinoColors.systemGrey4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

