import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'demos/slider.dart';
import 'demos/switch.dart';
import 'demos/segmented_control.dart';
import 'demos/tab_bar.dart';
import 'demos/icon.dart';
import 'demos/popup_menu_button.dart';
import 'demos/popup_menu_text_button.dart';
import 'demos/button.dart';
import 'demos/liquid_glass_text_button.dart';
import 'demos/liquid_glass_text_button_w_dialog.dart';
import 'demos/navigation_bar.dart';
import 'demos/glass_effect_container.dart';
import 'demos/input.dart';
import 'demos/liquid_glass_text_field.dart';
import 'demos/liquid_glass_container_2_row.dart';
// import 'demos/liquid_glass_container_1_row.dart'; // File doesn't exist
import 'demos/liquid_glass_dialog_button.dart';
import 'demos/liquid_glass_input_dialog_demo.dart';
import 'demos/liquid_glass_icon_container.dart';
import 'demos/liquid_glass_snackbar_demo.dart';
import 'demos/cupertino_slideable_list_tile_demo.dart';
import 'demos/liquid_glass_message_input.dart';
import 'demos/liquid_glass_search_text_field.dart';
import 'demos/model_tab_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  Color _accentColor = CupertinoColors.systemBlue;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _setAccentColor(Color color) {
    setState(() {
      _accentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: _accentColor,
      ),
      home: HomePage(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
        accentColor: _accentColor,
        onSelectAccentColor: _setAccentColor,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.accentColor,
    required this.onSelectAccentColor,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final Color accentColor;
  final ValueChanged<Color> onSelectAccentColor;

  static const _systemColors = <MapEntry<String, Color>>[
    MapEntry('Red', CupertinoColors.systemRed),
    MapEntry('Orange', CupertinoColors.systemOrange),
    MapEntry('Yellow', CupertinoColors.systemYellow),
    MapEntry('Green', CupertinoColors.systemGreen),
    MapEntry('Teal', CupertinoColors.systemTeal),
    MapEntry('Blue', CupertinoColors.systemBlue),
    MapEntry('Indigo', CupertinoColors.systemIndigo),
    MapEntry('Purple', CupertinoColors.systemPurple),
    MapEntry('Pink', CupertinoColors.systemPink),
    MapEntry('Gray', CupertinoColors.systemGrey),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        border: null,
        middle: const Text('Cupertino Native'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CNPopupMenuButton.icon(
              buttonIcon: CNSymbol(
                'paintpalette.fill',
                size: 18,
                mode: CNSymbolRenderingMode.multicolor,
              ),
              tint: accentColor,
              items: [
                for (final entry in _systemColors)
                  CNPopupMenuItem(
                    label: entry.key,
                    icon: CNSymbol('circle.fill', size: 18, color: entry.value),
                  ),
              ],
              onSelected: (index) {
                if (index >= 0 && index < _systemColors.length) {
                  onSelectAccentColor(_systemColors[index].value);
                }
              },
            ),
            const SizedBox(width: 8),
            CNButton.icon(
              icon: CNSymbol(isDarkMode ? 'sun.max' : 'moon', size: 18),
              onPressed: onToggleTheme,
            ),
          ],
        ),
      ),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          CupertinoListSection.insetGrouped(
            header: Text('Components'),
            children: [
              CupertinoListTile(
                title: Text('Slider'),
                leading: CNIcon(
                  symbol: CNSymbol('slider.horizontal.3', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const SliderDemoPage()),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Switch'),
                leading: CNIcon(
                  symbol: CNSymbol('switch.2', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const SwitchDemoPage()),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Segmented Control'),
                leading: CNIcon(
                  symbol: CNSymbol('rectangle.split.3x1', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const SegmentedControlDemoPage(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Icon'),
                leading: CNIcon(symbol: CNSymbol('app', color: accentColor)),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const IconDemoPage()),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Popup Menu Button'),
                leading: CNIcon(
                  symbol: CNSymbol('ellipsis.circle', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const PopupMenuButtonDemoPage(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Popup Menu Text Button'),
                leading: CNIcon(
                  symbol: CNSymbol('chevron.down.square', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const PopupMenuTextButtonDemoPage(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Button'),
                leading: CNIcon(
                  symbol: CNSymbol('hand.tap', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const ButtonDemoPage()),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Liquid Glass Text Button'),
                leading: CNIcon(
                  symbol: CNSymbol('hand.tap.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassTextButtonDemoPage(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Liquid Glass Button w/ Dialog'),
                leading: CNIcon(
                  symbol: CNSymbol('rectangle.stack.badge.plus', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassTextButtonWDialogDemoPage(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Input'),
                leading: CNIcon(
                  symbol: CNSymbol('text.cursor', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const InputDemo()),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Liquid Glass Input'),
                leading: CNIcon(
                  symbol: CNSymbol('drop.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassTextFieldDemoPage(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Liquid Glass Message Input'),
                leading: CNIcon(
                  symbol: CNSymbol('bubble.left.and.bubble.right.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassMessageInputDemoPage(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Liquid Glass Search Input'),
                leading: CNIcon(
                  symbol: CNSymbol('magnifyingglass.circle.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) =>
                          const LiquidGlassSearchTextFieldDemoPage(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Slideable List Tile'),
                leading: CNIcon(
                  symbol: CNSymbol('list.bullet.rectangle', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const CupertinoSlideableListTileDemoPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: Text('Navigation'),
            children: [
              CupertinoListTile(
                title: Text('Tab Bar'),
                leading: CNIcon(
                  symbol: CNSymbol('square.grid.2x2', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const TabBarDemoPage()),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Model Tab Bar'),
                leading: CNIcon(
                  symbol: CNSymbol('arrow.down.circle', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const ModelTabBarDemoPage()),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Navigation Bar'),
                leading: CNIcon(
                  symbol: CNSymbol('menubar.rectangle', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const NavigationBarDemoPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: Text('Effects'),
            children: [
              CupertinoListTile(
                title: Text('Glass Effect Container'),
                leading: CNIcon(
                  symbol: CNSymbol('rectangle.stack.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const GlassEffectContainerDemoPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: Text('Liquid Glass Containers'),
            children: [
              CupertinoListTile(
                title: Text('2 rows of text within container'),
                leading: CNIcon(
                  symbol: CNSymbol('square.fill.on.square.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassContainerDemo(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('1 row of text within container'),
                leading: CNIcon(
                  symbol: CNSymbol('square.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassContainerDemo(), // Using same demo for now
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Liquid Glass Dialog Button'),
                leading: CNIcon(
                  symbol: CNSymbol('exclamationmark.bubble.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassDialogButtonDemo(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Input Dialog Action'),
                leading: CNIcon(
                  symbol: CNSymbol('pencil.line', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassInputDialogDemo(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Icon Container (2 Icons)'),
                leading: CNIcon(
                  symbol: CNSymbol('square.grid.2x2.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassIconContainerDemo(),
                    ),
                  );
                },
              ),
              CupertinoListTile(
                title: Text('Snackbar Notification'),
                leading: CNIcon(
                  symbol: CNSymbol('bell.badge.fill', color: accentColor),
                ),
                trailing: CupertinoListTileChevron(),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => const LiquidGlassSnackbarDemoPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
