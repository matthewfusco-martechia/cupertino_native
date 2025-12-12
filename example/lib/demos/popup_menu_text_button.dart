import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

class PopupMenuTextButtonDemoPage extends StatefulWidget {
  const PopupMenuTextButtonDemoPage({super.key});

  @override
  State<PopupMenuTextButtonDemoPage> createState() =>
      _PopupMenuTextButtonDemoPageState();
}

class _PopupMenuTextButtonDemoPageState
    extends State<PopupMenuTextButtonDemoPage> {
  int? _lastSelected;
  String _status = 'No selection';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Popup Menu Text Button'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Native Popup Menu Text Button',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A native iOS popup menu button with text label and automatic chevron indicator.',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('With chevron down:'),
                const Spacer(),
                _PopupMenuTextButton(
                  buttonLabel: 'Actions',
                  chevronIconName: 'chevron.down',
                  buttonTextColor: CupertinoColors.white,
                  menuItemLabels: const [
                    'New File',
                    'New Folder',
                    '---',
                    'Rename',
                    'Delete',
                  ],
                  menuItemIcons: const [
                    'doc',
                    'folder',
                    '',
                    'pencil',
                    'trash',
                  ],
                  onItemSelected: (index) async {
                    setState(() {
                      _lastSelected = index;
                      _status = 'Selected: $index';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('With chevron right:'),
                const Spacer(),
                _PopupMenuTextButton(
                  buttonLabel: 'Options',
                  chevronIconName: 'chevron.right',
                  buttonTextColor: CupertinoColors.activeBlue,
                  menuItemLabels: const [
                    'Option 1',
                    'Option 2',
                    'Option 3',
                  ],
                  onItemSelected: (index) async {
                    setState(() {
                      _lastSelected = index;
                      _status = 'Selected Option ${index + 1}';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Custom colors:'),
                const Spacer(),
                _PopupMenuTextButton(
                  buttonLabel: 'Menu',
                  chevronIconName: 'chevron.up.circle.fill',
                  buttonTextColor: CupertinoColors.systemGreen,
                  chevronIconColor: CupertinoColors.systemOrange,
                  menuItemLabels: const [
                    'Settings',
                    'Help',
                    'About',
                  ],
                  menuItemIcons: const [
                    'gear',
                    'questionmark.circle',
                    'info.circle',
                  ],
                  onItemSelected: (index) async {
                    setState(() {
                      _lastSelected = index;
                      final items = ['Settings', 'Help', 'About'];
                      _status = 'Selected: ${items[index]}';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _status,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (_lastSelected != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Last selected index: $_lastSelected',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 1,
              color: CupertinoColors.separator,
            ),
            const SizedBox(height: 24),
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
              text: 'Native iOS popup menu (not bottom sheet)',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Custom chevron icon after text label',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Customizable chevron icon (down, up, right, etc.)',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Clean text + icon design',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Independent text and chevron colors',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Customizable text and icon colors',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'FlutterFlow compatible with async callbacks',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Optional menu item icons',
            ),
            const _FeatureItem(
              icon: CupertinoIcons.checkmark_alt,
              text: 'Divider support with "---" label',
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

// Simple inline implementation for the demo with text + chevron
class _PopupMenuTextButton extends StatelessWidget {
  const _PopupMenuTextButton({
    required this.buttonLabel,
    required this.menuItemLabels,
    this.menuItemIcons,
    this.onItemSelected,
    this.chevronIconName = 'chevron.down',
    this.buttonTextColor,
    this.chevronIconColor,
    this.fontSize,
  });

  final String buttonLabel;
  final List<String> menuItemLabels;
  final List<String>? menuItemIcons;
  final Future<dynamic> Function(int)? onItemSelected;
  final String chevronIconName;
  final Color? buttonTextColor;
  final Color? chevronIconColor;
  final double? fontSize;

  List<CNPopupMenuEntry> _buildMenuItems() {
    final entries = <CNPopupMenuEntry>[];

    for (var i = 0; i < menuItemLabels.length; i++) {
      final label = menuItemLabels[i];

      // Check for divider
      if (label.trim() == '---') {
        entries.add(const CNPopupMenuDivider());
        continue;
      }

      // Get icon if available
      CNSymbol? icon;
      if (menuItemIcons != null &&
          i < menuItemIcons!.length &&
          menuItemIcons![i].isNotEmpty) {
        icon = CNSymbol(
          menuItemIcons![i],
          size: 18,
        );
      }

      entries.add(CNPopupMenuItem(
        label: label,
        icon: icon,
        enabled: true,
      ));
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = buttonTextColor ??
        CupertinoColors.activeBlue;
    final defaultChevronColor = chevronIconColor ?? defaultTextColor;
    final defaultFontSize = fontSize ?? 17.0;

    const totalHeight = 44.0 + 20.0; // Add 20px for menu spacing
    
    return SizedBox(
      height: 44.0,
      child: Stack(
        clipBehavior: Clip.none, // Allow overflow
        children: [
          // Invisible native button - extended below to push menu down
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: -20.0, // Extend 20px below the visible area
            child: Opacity(
              opacity: 0.01,
              child: CNPopupMenuButton(
                buttonLabel: buttonLabel,
                items: _buildMenuItems(),
                onSelected: (index) {
                  if (onItemSelected != null) {
                    onItemSelected!(index);
                  }
                },
                buttonStyle: CNButtonStyle.plain,
                shrinkWrap: true,
                height: totalHeight,
              ),
            ),
          ),
          // Visual text + chevron overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          buttonLabel,
                          style: TextStyle(
                            color: defaultTextColor,
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      CNIcon(
                        symbol: CNSymbol(
                          chevronIconName,
                          size: 14,
                          color: defaultChevronColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

