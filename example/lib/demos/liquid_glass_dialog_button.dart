import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/components/liquid_glass_dialog_button.dart';

class LiquidGlassDialogButtonDemo extends StatelessWidget {
  const LiquidGlassDialogButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Dialog Button'),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Alert Dialog Example
                const Text('Alert Dialog', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                LiquidGlassDialogButton(
                  height: 50,
                  buttonText: 'Reset Settings',
                  dialogTitle: 'Reset Settings?',
                  dialogMessage: 'This will return all settings to default.',
                  confirmButtonText: 'Reset',
                  onConfirm: () {
                    print('Settings Reset');
                  },
                ),
                const SizedBox(height: 32),

                // Destructive Action Sheet Example
                const Text('Destructive Action Sheet', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                LiquidGlassDialogButton(
                  height: 50,
                  buttonText: 'Delete Account',
                  buttonTextColor: CupertinoColors.destructiveRed,
                  buttonTint: CupertinoColors.systemRed.withOpacity(0.1),
                  dialogTitle: 'Delete Account',
                  dialogMessage: 'Are you sure? This action cannot be undone.',
                  confirmButtonText: 'Delete',
                  isDestructive: true,
                  useActionSheet: true,
                  onConfirm: () {
                    print('Account Deleted');
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

