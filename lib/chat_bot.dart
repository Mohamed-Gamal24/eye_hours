import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage('Hello! I\'m ChatBot. How can I help you today?');
  }

  void _addBotMessage(String text) async {
    setState(() {
      _messages.add(ChatMessage(
        text: '',
        isUser: false,
        isAnimating: true,
      ));
    });

    // تأثير الكتابة التدريجية
    for (int i = 0; i <= text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) return;
      setState(() {
        _messages.last.text = text.substring(0, i);
      });
      _scrollToBottom();
    }

    setState(() {
      _messages.last.isAnimating = false;
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _scrollToBottom();
    _simulateBotResponse(text);
  }

  void _simulateBotResponse(String userMessage) {
    setState(() => _isTyping = true);

    Future.delayed(const Duration(seconds: 1), () {
      _addBotMessage(_generateResponse(userMessage));
      setState(() => _isTyping = false);
    });
  }

  String _generateResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();

    if (userMessage.contains("hello") || userMessage.contains("hi")) {
      return "Hello there! How can I help you today?";
    } else if (userMessage.contains("thank") ||
        userMessage.contains("thanks")) {
      return "You're welcome! Is there anything else?";
    } else if (userMessage.contains("your name") ||
        userMessage.contains("who are you")) {
      return "I'm an intelligent chatbot";
    }
    return "I didn't understand your question, could you clarify?";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ChatBot 𓂀',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _messages.length) return _buildTypingIndicator();
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) _buildBotAvatar(),
          Flexible(child: _buildMessageContent(message)),
          if (message.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.transparent,
        backgroundImage:
            AssetImage('assets/image/483720d21e5105ecbf32b62355020d39.jpg'),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return const Padding(
      padding: EdgeInsets.only(left: 8),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.isUser ? Colors.blue : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isUser ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage:
                AssetImage('assets/image/483720d21e5105ecbf32b62355020d39.jpg'),
            child: Icon(Icons.android, color: Colors.white),
          ),
          SizedBox(width: 8),
          Text("Typing...", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  String text;
  final bool isUser;
  bool isAnimating;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isAnimating = false,
  });
}
