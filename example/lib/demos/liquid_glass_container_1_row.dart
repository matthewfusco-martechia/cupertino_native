import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/components/liquid_glass_container_1_row.dart';

class LiquidGlassContainer1RowDemo extends StatelessWidget {
  const LiquidGlassContainer1RowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Container (1 Row)'),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Standard Example
                LiquidGlassContainer1Row(
                  text: 'Simple Action',
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Tapped!'),
                        content: const Text('You tapped the 1-row container.'),
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
                LiquidGlassContainer1Row(
                  containerRadius: 24.0,
                  text: 'Destructive',
                  fontSize: 18,
                  textColor: CupertinoColors.destructiveRed,
                  tintColor: CupertinoColors.systemRed.withOpacity(0.1),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: const Text('Destructive Action'),
                        message: const Text('Are you sure you want to proceed?'),
                        actions: [
                          CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Confirm Delete'),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Darker Style Simulation
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const LiquidGlassContainer1Row(
                    text: 'Dark Mode Context',
                    textColor: CupertinoColors.white,
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

