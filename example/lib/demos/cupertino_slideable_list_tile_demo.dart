import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

class CupertinoSlideableListTileDemoPage extends StatefulWidget {
  const CupertinoSlideableListTileDemoPage({super.key});

  @override
  State<CupertinoSlideableListTileDemoPage> createState() =>
      _CupertinoSlideableListTileDemoPageState();
}

class _CupertinoSlideableListTileDemoPageState
    extends State<CupertinoSlideableListTileDemoPage> {
  final List<ConversationItem> _conversations = [
    ConversationItem(
      title: 'Could you please provide a concise su...',
      subtitle: '21 hours ago',
    ),
    ConversationItem(
      title: 'Based on my interest in fiction novels with...',
      subtitle: '2 days ago',
    ),
    ConversationItem(
      title: 'Based on my interest in fiction novels with...',
      subtitle: '2 days ago',
    ),
    ConversationItem(
      title: 'What is ai',
      subtitle: '3 days ago',
    ),
    ConversationItem(
      title: 'New conversation',
      subtitle: '5 days ago',
    ),
    ConversationItem(
      title: 'Why am I motion sick all the time',
      subtitle: '5 days ago',
    ),
  ];

  void _handleRename(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Rename'),
        content: const Text('Rename conversation feature'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _handleDelete(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete'),
        content: Text('Delete "${_conversations[index].title}"?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              setState(() {
                _conversations.removeAt(index);
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _handleTilePressed(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Tile Pressed'),
        content: Text('You tapped: "${_conversations[index].title}"'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Slideable List Tile'),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cupertino Slideable List Tile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap a tile to open it. Swipe left to reveal actions.',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _conversations.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = _conversations[index];
                  return CupertinoSlideableListTile(
                    title: item.title,
                    subtitle: item.subtitle,
                    borderRadius: 12,
                    onTilePressed: () => _handleTilePressed(index),
                    actions: [
                      SlideAction(
                        label: 'Rename',
                        iconName: 'pencil',
                        color: CupertinoColors.systemBlue,
                        onPressed: () => _handleRename(index),
                      ),
                      SlideAction(
                        label: 'Delete',
                        iconName: 'trash',
                        color: CupertinoColors.systemRed,
                        onPressed: () => _handleDelete(index),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConversationItem {
  ConversationItem({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
}
