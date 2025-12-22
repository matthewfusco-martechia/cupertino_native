import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TabController, TabBarView;
import 'package:cupertino_native/cupertino_native.dart';

class ModelTabBarDemoPage extends StatefulWidget {
  const ModelTabBarDemoPage({super.key});

  @override
  State<ModelTabBarDemoPage> createState() => _ModelTabBarDemoPageState();
}

class _ModelTabBarDemoPageState extends State<ModelTabBarDemoPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      final i = _controller.index;
      if (i != _index) setState(() => _index = i);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Model Tab Bar'),
      ),
      child: Stack(
        children: [
          // Content below
          Positioned.fill(
            child: TabBarView(
              controller: _controller,
              children: const [
                _ModelListPage(
                  title: 'Available Models',
                  models: [
                    'Gemma 3 4B',
                    'LLaMA 3.2 3B',
                    'Phi-3 Mini',
                    'Mistral 7B',
                    'Qwen 2.5 3B',
                  ],
                ),
                _ModelListPage(
                  title: 'Downloaded Models',
                  models: [
                    'Gemma 3 4B',
                    'LLaMA 3.2 3B',
                  ],
                ),
              ],
            ),
          ),
          // Native tab bar overlay at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: CNTabBar(
              items: const [
                CNTabBarItem(
                  label: 'Available',
                  icon: CNSymbol('square.grid.2x2'),
                ),
                CNTabBarItem(
                  label: 'Downloaded',
                  icon: CNSymbol('arrow.down.circle.fill'),
                ),
              ],
              currentIndex: _index,
              shrinkCentered: true,
              onTap: (i) {
                setState(() => _index = i);
                _controller.animateTo(i);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelListPage extends StatelessWidget {
  const _ModelListPage({required this.title, required this.models});
  final String title;
  final List<String> models;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: models.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.cube_box,
                        color: CupertinoTheme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          models[index],
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      if (title == 'Available Models')
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(CupertinoIcons.cloud_download),
                          onPressed: () {},
                        )
                      else
                        const Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: CupertinoColors.activeGreen,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Add bottom padding to account for tab bar
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
