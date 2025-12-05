import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

/// Demo page for the Liquid Glass Snackbar
class LiquidGlassSnackbarDemoPage extends StatefulWidget {
  const LiquidGlassSnackbarDemoPage({super.key});

  @override
  State<LiquidGlassSnackbarDemoPage> createState() =>
      _LiquidGlassSnackbarDemoPageState();
}

class _LiquidGlassSnackbarDemoPageState
    extends State<LiquidGlassSnackbarDemoPage> {
  /// Shows a liquid glass snackbar message with auto-dismiss
  Future<void> _showLiquidGlassSnackbar(
    BuildContext context, {
    required String message,
    String? iconName,
    Color? iconColor,
    int? duration,
  }) async {
    final overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    // Default values
    final displayDuration = duration ?? 2;
    final displayIcon = iconName ?? "checkmark.circle.fill";
    final displayIconColor = iconColor ?? CupertinoColors.systemGreen;

    // Animation controller values
    final animationDuration = const Duration(milliseconds: 300);

    // Create the overlay entry
    overlayEntry = OverlayEntry(
      builder: (context) => _LiquidGlassSnackbar(
        message: message,
        iconName: displayIcon,
        iconColor: displayIconColor,
        onDismiss: () {
          overlayEntry?.remove();
        },
        animationDuration: animationDuration,
      ),
    );

    // Insert the overlay
    overlayState.insert(overlayEntry);

    // Wait a frame for the overlay to be inserted
    await Future.delayed(const Duration(milliseconds: 50));

    // Auto-dismiss after duration
    await Future.delayed(Duration(seconds: displayDuration));

    // Remove the overlay if it hasn't been manually dismissed
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Snackbar'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Liquid Glass Snackbar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Displays a glassmorphism-styled notification at the top of the screen that automatically dismisses after 2 seconds or when the X button is clicked.',
              style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
            ),
            const SizedBox(height: 32),

            // Success Message
            _DemoSection(
              title: 'Success Message',
              description: 'Standard success notification with checkmark icon',
              onPressed: () {
                _showLiquidGlassSnackbar(
                  context,
                  message: 'Message copied',
                  iconName: 'checkmark.circle.fill',
                  iconColor: CupertinoColors.systemGreen,
                );
              },
            ),

            const SizedBox(height: 24),

            // Error Message
            _DemoSection(
              title: 'Error Message',
              description: 'Error notification with warning icon',
              onPressed: () {
                _showLiquidGlassSnackbar(
                  context,
                  message: 'Something went wrong',
                  iconName: 'xmark.circle.fill',
                  iconColor: CupertinoColors.systemRed,
                );
              },
            ),

            const SizedBox(height: 24),

            // Info Message
            _DemoSection(
              title: 'Info Message',
              description: 'Informational notification with info icon',
              onPressed: () {
                _showLiquidGlassSnackbar(
                  context,
                  message: 'New update available',
                  iconName: 'info.circle.fill',
                  iconColor: CupertinoColors.systemBlue,
                );
              },
            ),

            const SizedBox(height: 24),

            // Favorite Message
            _DemoSection(
              title: 'Favorite Message',
              description: 'Custom icon with heart',
              onPressed: () {
                _showLiquidGlassSnackbar(
                  context,
                  message: 'Added to favorites',
                  iconName: 'heart.fill',
                  iconColor: CupertinoColors.systemPink,
                );
              },
            ),

            const SizedBox(height: 24),

            // Download Message
            _DemoSection(
              title: 'Download Message',
              description: 'Download notification with arrow icon',
              onPressed: () {
                _showLiquidGlassSnackbar(
                  context,
                  message: 'Download complete',
                  iconName: 'arrow.down.circle.fill',
                  iconColor: CupertinoColors.systemPurple,
                );
              },
            ),

            const SizedBox(height: 24),

            // Long Duration Message
            _DemoSection(
              title: 'Long Duration (5s)',
              description: 'Message that stays visible for 5 seconds',
              onPressed: () {
                _showLiquidGlassSnackbar(
                  context,
                  message: 'This message will stay for 5 seconds',
                  iconName: 'clock.fill',
                  iconColor: CupertinoColors.systemOrange,
                  duration: 5,
                );
              },
            ),

            const SizedBox(height: 24),

            // Long Message
            _DemoSection(
              title: 'Long Message',
              description: 'Snackbar with longer text content',
              onPressed: () {
                _showLiquidGlassSnackbar(
                  context,
                  message:
                      'This is a longer message that demonstrates text wrapping in the snackbar',
                  iconName: 'text.alignleft',
                  iconColor: CupertinoColors.systemIndigo,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoSection extends StatelessWidget {
  const _DemoSection({
    required this.title,
    required this.description,
    required this.onPressed,
  });

  final String title;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: CupertinoColors.activeBlue,
                onPressed: onPressed,
                child: const Text('Show'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiquidGlassSnackbar extends StatefulWidget {
  const _LiquidGlassSnackbar({
    required this.message,
    required this.iconName,
    required this.iconColor,
    required this.onDismiss,
    required this.animationDuration,
  });

  final String message;
  final String iconName;
  final Color iconColor;
  final VoidCallback onDismiss;
  final Duration animationDuration;

  @override
  State<_LiquidGlassSnackbar> createState() => _LiquidGlassSnackbarState();
}

class _LiquidGlassSnackbarState extends State<_LiquidGlassSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CNGlassEffectContainer(
                glassStyle: CNGlassStyle.regular,
                cornerRadius: 16,
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Leading icon (message status)
                      CNIcon(
                        symbol: CNSymbol(
                          widget.iconName,
                          size: 24,
                          color: widget.iconColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Message text
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Close button
                      CupertinoIconButton(
                        iconName: 'xmark.circle.fill',
                        iconSize: 20,
                        iconColor: CupertinoColors.systemGrey,
                        buttonSize: 32,
                        onPressed: _dismiss,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

