import 'package:flutter/material.dart';
import 'package:riverwise/openai/openai_config.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatMessage {
  final String role; // 'user' | 'assistant'
  final String content;
  final DateTime timestamp;
  _ChatMessage({required this.role, required this.content, required this.timestamp});
}

class _ChatbotScreenState extends State<ChatbotScreen> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _client = OpenAIClient();
  bool _isLoading = false;
  String _language = 'English';
  final List<_ChatMessage> _messages = [];

  final List<String> _languages = const [
    'English',
    'हिंदी',
    'ಕನ್ನಡ',
    'తెలుగు',
    'मराठी',
    'বাংলা',
    'தமிழ்',
    'ગુજરાતી',
    'ଓଡ଼ିଆ',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;
    setState(() {
      _messages.add(_ChatMessage(role: 'user', content: text, timestamp: DateTime.now()));
      _isLoading = true;
      _controller.clear();
    });

    // Build history for API (limit last 10 exchanges for brevity)
    final apiMessages = _messages
        .takeLast(12)
        .map((m) => {
              'role': m.role,
              'content': m.content,
            })
        .toList();

    try {
      final reply = await _client.sendChat(messages: apiMessages, languageLabel: _language);
      setState(() {
        _messages.add(_ChatMessage(role: 'assistant', content: reply, timestamp: DateTime.now()));
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add(_ChatMessage(
            role: 'assistant',
            content: 'Sorry, I ran into a problem connecting to the safety assistant. Please try again. ($e)',
            timestamp: DateTime.now()));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.support_agent, color: cs.primary),
            const SizedBox(width: 8),
            Text('Safety Assistant', style: theme.textTheme.titleLarge),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _LanguageDropdown(
              value: _language,
              items: _languages,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _language = value);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _HeaderBanner(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == _messages.length) {
                  return _TypingBubble(color: cs.primaryContainer, onColor: cs.onPrimaryContainer);
                }
                final m = _messages[index];
                final isUser = m.role == 'user';
                return _MessageBubble(
                  isUser: isUser,
                  text: m.content,
                  timestamp: m.timestamp,
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: _Composer(
                controller: _controller,
                isLoading: _isLoading,
                onSend: _send,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [cs.primary.withValues(alpha: 0.12), cs.primaryContainer.withValues(alpha: 0.3)]),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shield_moon, color: cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Get quick, actionable guidance for flood preparedness and emergencies. Stay safe! 🛟',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _LanguageDropdown({required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.primaryContainer),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(Icons.keyboard_arrow_down, color: cs.primary),
          style: theme.textTheme.labelLarge,
          onChanged: onChanged,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final bool isUser;
  final String text;
  final DateTime timestamp;
  const _MessageBubble({required this.isUser, required this.text, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bg = isUser ? cs.primary : cs.primaryContainer;
    final fg = isUser ? cs.onPrimary : cs.onPrimaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(radius: 14, backgroundColor: cs.primaryContainer, child: Icon(Icons.safety_check, size: 16, color: cs.onPrimaryContainer)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: fg, height: 1.5)),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(radius: 14, backgroundColor: cs.primary, child: Icon(Icons.person, size: 16, color: cs.onPrimary)),
          ],
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  final Color color;
  final Color onColor;
  const _TypingBubble({required this.color, required this.onColor});
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();
  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: AnimatedBuilder(
          animation: _ac,
          builder: (context, _) {
            final t = _ac.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final opacity = (0.2 + 0.6 * ((t + i / 3) % 1)).clamp(0.2, 0.8);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(Icons.circle, size: 8, color: widget.onColor.withValues(alpha: opacity)),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;
  const _Composer({required this.controller, required this.isLoading, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: cs.primaryContainer),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: 'Ask about flood safety, preparedness, or emergencies…',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: isLoading ? null : onSend,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isLoading ? cs.primary.withValues(alpha: 0.5) : cs.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(Icons.send_rounded, color: cs.onPrimary),
          ),
        )
      ],
    );
  }
}

extension _IterableTail<T> on List<T> {
  Iterable<T> takeLast(int n) => skip(length > n ? length - n : 0);
}
