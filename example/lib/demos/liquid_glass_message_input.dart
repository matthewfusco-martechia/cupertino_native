import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

class LiquidGlassMessageInputDemoPage extends StatefulWidget {
  const LiquidGlassMessageInputDemoPage({super.key});

  @override
  State<LiquidGlassMessageInputDemoPage> createState() =>
      _LiquidGlassMessageInputDemoPageState();
}

class _LiquidGlassMessageInputDemoPageState
    extends State<LiquidGlassMessageInputDemoPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  String _status = 'Idle';
  // Removed const from here to stick to simple lists if that was the issue, 
  // but these are CNPopupMenuItem which should be const-compatible if defined so.
  // To be safe, I will make it not const for now and use it in build.
  final List<CNPopupMenuEntry> _plusMenuItems = [
    const CNPopupMenuItem(label: 'Photo'),
    const CNPopupMenuItem(label: 'Document'),
    const CNPopupMenuDivider(),
    const CNPopupMenuItem(label: 'Location'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(text);
      _status = 'Sent "${text.length > 20 ? '${text.substring(0, 20)}…' : text}"';
    });
    _controller.clear();
  }

  void _toggleMic() {
    setState(() {
      _status = _status.startsWith('Recording') ? 'Stopped recording' : 'Recording…';
    });
    // Add dummy message for feedback
    Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() => _messages.add("Voice transcription text..."));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Liquid Glass Message Input'),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(               
            // Only use local asset if we know it exists, otherwise use a network placeholder or color to avoid crashes
            // The previous code used 'assets/search.jpg'. Assuming it exists.
            image: NetworkImage("https://images.unsplash.com/photo-1550684848-fac1c5b4e853?q=80&w=2670&auto=format&fit=crop"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Message Composer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _status,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CNGlassEffectContainer(
                          glassStyle: CNGlassStyle.regular,
                          cornerRadius: 14,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              message,
                              style: const TextStyle(
                                color: CupertinoColors.label,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: LiquidGlassMessageInput(
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                  plusMenuItems: _plusMenuItems,
                  onPlusMenuSelected: (index) {
                    setState(() => _status = 'Plus menu $index tapped');
                  },
                  onSearchPressed: () {
                    setState(() => _status = 'Search tapped');
                  },
                  onMicPressed: _toggleMic,
                  onSendPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
