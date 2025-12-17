import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

class LiquidGlassSearchTextFieldDemoPage extends StatefulWidget {
  const LiquidGlassSearchTextFieldDemoPage({super.key});

  @override
  State<LiquidGlassSearchTextFieldDemoPage> createState() =>
      _LiquidGlassSearchTextFieldDemoPageState();
}

class _LiquidGlassSearchTextFieldDemoPageState
    extends State<LiquidGlassSearchTextFieldDemoPage> {
  String _status = 'Idle';
  List<String> _searchResults = [];

  void _handleSearch(String query) {
    setState(() {
      _status = 'Searching for "$query"';
      if (query.isNotEmpty) {
        // Mock search results
        _searchResults = [
          'Result 1 for "$query"',
          'Result 2 for "$query"',
          'Result 3 for "$query"',
        ];
      } else {
        _searchResults = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Search Input'),
      ),
      child: Stack(
        children: [
          // Background Image to demonstrate "Liquid" effect
          Positioned.fill(
            child: Image.asset(
              'assets/search.jpg',
              fit: BoxFit.cover,
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LiquidGlassSearchTextField(
                    placeholder: 'Search content...',
                    height: 45.0,
                    isDarkMode: true, // Show dark mode version against dark bg usually
                    onSubmitted: _handleSearch,
                    onCancel: () {
                      setState(() {
                         _status = 'Cancelled';
                         _searchResults = [];
                      });
                    },
                    onChanged: (text) {
                      // Optional live search
                      print('Text changed: $text');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _status,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CNGlassEffectContainer(
                          glassStyle: CNGlassStyle.regular,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              _searchResults[index],
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
