import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/components/liquid_glass_icon_container.dart';

class LiquidGlassIconContainerDemo extends StatelessWidget {
  const LiquidGlassIconContainerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Icon Container'),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Standard Example - Settings & Messages
                LiquidGlassIconContainer(
                  icon1Name: 'gearshape',
                  icon2Name: 'message',
                  onIcon1Pressed: () {
                    _showAlert(context, 'Settings', 'Settings icon tapped!');
                  },
                  onIcon2Pressed: () {
                    _showAlert(context, 'Messages', 'Messages icon tapped!');
                  },
                ),
                const SizedBox(height: 24),

                // Colored icons
                LiquidGlassIconContainer(
                  icon1Name: 'heart.fill',
                  icon1Color: CupertinoColors.systemPink,
                  icon2Name: 'star.fill',
                  icon2Color: CupertinoColors.systemYellow,
                  onIcon1Pressed: () {
                    _showAlert(context, 'Favorites', 'Added to favorites!');
                  },
                  onIcon2Pressed: () {
                    _showAlert(context, 'Starred', 'Marked as starred!');
                  },
                ),
                const SizedBox(height: 24),

                // Larger buttons
                LiquidGlassIconContainer(
                  icon1Name: 'camera.fill',
                  icon1Size: 32.0,
                  icon1Color: CupertinoColors.activeBlue,
                  icon2Name: 'photo.fill',
                  icon2Size: 32.0,
                  icon2Color: CupertinoColors.activeGreen,
                  buttonSize: 56.0,
                  spacing: 12.0,
                ),
                const SizedBox(height: 24),

                // Dark background simulation
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: LiquidGlassIconContainer(
                    icon1Name: 'sun.max.fill',
                    icon1Color: CupertinoColors.systemYellow,
                    icon2Name: 'moon.fill',
                    icon2Color: CupertinoColors.white,
                    onIcon1Pressed: () {
                      _showAlert(context, 'Day Mode', 'Switched to day mode!');
                    },
                    onIcon2Pressed: () {
                      _showAlert(
                          context, 'Night Mode', 'Switched to night mode!');
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Green background like the reference image
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CupertinoColors.systemGreen.withValues(alpha: 0.3),
                        CupertinoColors.systemGreen.withValues(alpha: 0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: LiquidGlassIconContainer(
                    icon1Name: 'gearshape',
                    icon1Color: CupertinoColors.white,
                    icon2Name: 'bubble.left',
                    icon2Color: CupertinoColors.white,
                    onIcon1Pressed: () {
                      _showAlert(context, 'Settings', 'Opening settings...');
                    },
                    onIcon2Pressed: () {
                      _showAlert(context, 'Chat', 'Opening chat...');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAlert(BuildContext context, String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
