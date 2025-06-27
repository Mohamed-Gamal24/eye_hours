import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String _detectedLanguage = 'en'; // Default language

  // API URL
  final String apiUrl = 'https://web-production-ad8d.up.railway.app/api/ask';

  // Enhanced language detection patterns
  final Map<String, RegExp> languagePatterns = {
    'ar': RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]'),
    'fr': RegExp(
        r'\b(le|la|les|un|une|des|et|ou|de|du|dans|pour|avec|sur|par|ce|cette|que|qui|où|comment|pourquoi|bonjour|merci|oui|non|je|tu|il|elle|nous|vous|ils|elles|avoir|être|faire|aller|venir|voir|savoir|pouvoir|vouloir|devoir)\b',
        caseSensitive: false),
    'es': RegExp(
        r'\b(el|la|los|las|un|una|y|o|de|del|en|para|con|por|que|quien|donde|como|porque|hola|gracias|si|no|yo|tu|él|ella|nosotros|vosotros|ellos|ellas|ser|estar|tener|hacer|ir|venir|ver|saber|poder|querer|deber)\b',
        caseSensitive: false),
    'de': RegExp(
        r'\b(der|die|das|ein|eine|und|oder|von|im|zu|mit|auf|für|dass|wer|wo|wie|warum|hallo|danke|ja|nein|ich|du|er|sie|es|wir|ihr|sie|haben|sein|werden|können|müssen|sollen|wollen|dürfen)\b',
        caseSensitive: false),
    'it': RegExp(
        r'\b(il|la|lo|gli|le|un|una|e|o|di|del|in|per|con|su|che|chi|dove|come|perche|ciao|grazie|si|no|io|tu|lui|lei|noi|voi|loro|essere|avere|fare|andare|venire|vedere|sapere|potere|volere|dovere)\b',
        caseSensitive: false),
    'pt': RegExp(
        r'\b(o|a|os|as|um|uma|e|ou|de|do|em|para|com|por|que|quem|onde|como|porque|ola|obrigado|sim|nao|eu|tu|ele|ela|nos|vos|eles|elas|ser|estar|ter|fazer|ir|vir|ver|saber|poder|querer|dever)\b',
        caseSensitive: false),
    'ru': RegExp(r'[\u0400-\u04FF]'),
    'zh': RegExp(r'[\u4e00-\u9fff]'),
    'ja': RegExp(r'[\u3040-\u309f\u30a0-\u30ff\u4e00-\u9faf]'),
    'ko': RegExp(r'[\uac00-\ud7af]'),
  };

  // Language names for better API communication
  final Map<String, String> languageNames = {
    'ar': 'Arabic',
    'en': 'English',
    'fr': 'French',
    'es': 'Spanish',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ko': 'Korean',
  };

  // Multi-language welcome messages
  final Map<String, String> welcomeMessages = {
    'ar': 'مرحباً! أنا ChatBot. كيف يمكنني مساعدتك اليوم؟',
    'en': 'Hello! I\'m ChatBot. How can I help you today?',
    'fr': 'Bonjour! Je suis ChatBot. Comment puis-je vous aider aujourd\'hui?',
    'es': '¡Hola! Soy ChatBot. ¿Cómo puedo ayudarte hoy?',
    'de': 'Hallo! Ich bin ChatBot. Wie kann ich Ihnen heute helfen?',
    'it': 'Ciao! Sono ChatBot. Come posso aiutarti oggi?',
    'pt': 'Olá! Eu sou ChatBot. Como posso ajudá-lo hoje?',
    'ru': 'Привет! Я ChatBot. Как я могу помочь вам сегодня?',
    'zh': '你好！我是ChatBot。今天我可以为您提供什么帮助？',
    'ja': 'こんにちは！私はChatBotです。今日はどのようにお手伝いできますか？',
    'ko': '안녕하세요! 저는 ChatBot입니다. 오늘 어떻게 도와드릴까요?',
  };

  // Error messages in different languages
  final Map<String, String> errorMessages = {
    'ar': 'عذراً، حدث خطأ في الاتصال',
    'en': 'Sorry, there was a connection error',
    'fr': 'Désolé, il y a eu une erreur de connexion',
    'es': 'Lo siento, hubo un error de conexión',
    'de': 'Entschuldigung, es gab einen Verbindungsfehler',
    'it': 'Spiacente, si è verificato un errore di connessione',
    'pt': 'Desculpe, houve um erro de conexão',
    'ru': 'Извините, произошла ошибка подключения',
    'zh': '抱歉，连接出现错误',
    'ja': '申し訳ございません、接続エラーが発生しました',
    'ko': '죄송합니다. 연결 오류가 발생했습니다',
  };

  @override
  void initState() {
    super.initState();
    _addBotMessage(welcomeMessages['en']!);
  }

  // Enhanced language detection function
  String _detectLanguage(String text) {
    text = text.toLowerCase().trim();

    // If text is empty, return current detected language
    if (text.isEmpty) return _detectedLanguage;

    // Score-based detection for better accuracy
    Map<String, double> scores = {};

    for (String langCode in languagePatterns.keys) {
      RegExp pattern = languagePatterns[langCode]!;
      Iterable<Match> matches = pattern.allMatches(text);

      if (matches.isNotEmpty) {
        // Calculate score based on number of matches and text length
        double score = matches.length / text.split(' ').length;
        scores[langCode] = score;
      }
    }

    // Return language with highest score
    if (scores.isNotEmpty) {
      String detectedLang =
          scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      return detectedLang;
    }

    // Default to English if no pattern matches
    return 'en';
  }

  void _addBotMessage(String text) async {
    setState(() {
      _messages.add(ChatMessage(
        text: '',
        isUser: false,
        isAnimating: true,
      ));
    });

    // Typing effect with variable speed based on language
    int delay = _detectedLanguage == 'ar' ||
            _detectedLanguage == 'zh' ||
            _detectedLanguage == 'ja' ||
            _detectedLanguage == 'ko'
        ? 50
        : 30;

    for (int i = 0; i <= text.length; i++) {
      await Future.delayed(Duration(milliseconds: delay));
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

    // Detect language of user message
    String newDetectedLanguage = _detectLanguage(text);

    // Update detected language if it changed
    if (newDetectedLanguage != _detectedLanguage) {
      setState(() {
        _detectedLanguage = newDetectedLanguage;
      });
      print('Language changed to: $_detectedLanguage');
    }

    _messageController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _scrollToBottom();
    _getBotResponse(text);
  }

  Future<void> _getBotResponse(String userMessage) async {
    setState(() => _isTyping = true);

    try {
      // Enhanced request data with multiple language instructions
      final Map<String, dynamic> requestData = {
        'question': userMessage,
        'message': userMessage,
        'query': userMessage,
        'language': _detectedLanguage,
        'language_code': _detectedLanguage,
        'language_name': languageNames[_detectedLanguage] ?? 'English',
        'respond_in_language': _detectedLanguage,
        'target_language': _detectedLanguage,
        'instructions': _buildLanguageInstructions(),
        'system_prompt': _buildSystemPrompt(),
        'context': {
          'user_language': _detectedLanguage,
          'user_language_name': languageNames[_detectedLanguage] ?? 'English',
          'response_language': _detectedLanguage,
        }
      };

      print('Sending request to: $apiUrl');
      print('Request data: ${jsonEncode(requestData)}');
      print(
          'Detected language: $_detectedLanguage (${languageNames[_detectedLanguage]})');

      // Enhanced headers for language specification
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
              'Accept-Language': _detectedLanguage,
              'X-Language': _detectedLanguage,
              'X-Response-Language': _detectedLanguage,
              'User-Agent': 'FlutterChatBot/1.0',
            },
            body: jsonEncode(requestData),
          )
          .timeout(const Duration(seconds: 30));

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        print('Parsed response data: $responseData');

        String botResponse = _extractBotResponse(responseData);

        if (botResponse.isEmpty || botResponse == 'null') {
          botResponse = _getErrorMessage("Empty response received");
        }

        // Validate that response is in correct language
        String responseLanguage = _detectLanguage(botResponse);
        if (responseLanguage != _detectedLanguage &&
            _detectedLanguage != 'en') {
          print(
              'Warning: Response language ($responseLanguage) differs from expected ($_detectedLanguage)');
          // Optionally add a note about language mismatch
          if (_detectedLanguage == 'ar') {
            botResponse += '\n\n(ملاحظة: قد تكون الإجابة بلغة مختلفة)';
          } else {
            botResponse +=
                '\n\n(Note: Response may be in a different language)';
          }
        }

        _addBotMessage(botResponse);
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      _handleException(e);
    } finally {
      setState(() => _isTyping = false);
    }
  }

  // Build comprehensive language instructions for the API
  String _buildLanguageInstructions() {
    String languageName = languageNames[_detectedLanguage] ?? 'English';

    switch (_detectedLanguage) {
      case 'ar':
        return 'يرجى الرد باللغة العربية فقط. تأكد من أن جميع النصوص باللغة العربية. المستخدم يتحدث بالعربية.';
      case 'fr':
        return 'Veuillez répondre uniquement en français. Assurez-vous que tout le texte est en français. L\'utilisateur communique en français.';
      case 'es':
        return 'Por favor responde únicamente en español. Asegúrate de que todo el texto esté en español. El usuario se comunica en español.';
      case 'de':
        return 'Bitte antworten Sie nur auf Deutsch. Stellen Sie sicher, dass der gesamte Text auf Deutsch ist. Der Benutzer kommuniziert auf Deutsch.';
      case 'it':
        return 'Si prega di rispondere solo in italiano. Assicurati che tutto il testo sia in italiano. L\'utente comunica in italiano.';
      case 'pt':
        return 'Por favor, responda apenas em português. Certifique-se de que todo o texto esteja em português. O usuário se comunica em português.';
      case 'ru':
        return 'Пожалуйста, отвечайте только на русском языке. Убедитесь, что весь текст на русском языке. Пользователь общается на русском языке.';
      case 'zh':
        return '请只用中文回复。确保所有文本都是中文。用户使用中文交流。';
      case 'ja':
        return '日本語でのみ返答してください。すべてのテキストが日本語であることを確認してください。ユーザーは日本語でコミュニケーションを取っています。';
      case 'ko':
        return '한국어로만 응답해 주세요. 모든 텍스트가 한국어인지 확인하십시오. 사용자는 한국어로 소통합니다.';
      default:
        return 'Please respond only in $languageName. Make sure all text is in $languageName. The user is communicating in $languageName.';
    }
  }

  // Build system prompt for the API
  String _buildSystemPrompt() {
    String languageName = languageNames[_detectedLanguage] ?? 'English';

    return 'You are a helpful AI assistant. The user is communicating in $languageName (language code: $_detectedLanguage). '
        'You must respond ONLY in $languageName. Do not use any other language in your response. '
        'Maintain natural conversation flow while staying in $languageName throughout the entire response.';
  }

  // Extract bot response from API response
  String _extractBotResponse(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['response'] ??
          responseData['answer'] ??
          responseData['reply'] ??
          responseData['message'] ??
          responseData['text'] ??
          responseData['result'] ??
          responseData['output'] ??
          responseData['content'] ??
          responseData.toString();
    } else if (responseData is String) {
      return responseData;
    } else {
      return responseData.toString();
    }
  }

  // Get error message in current language
  String _getErrorMessage(String additionalInfo) {
    String baseError = errorMessages[_detectedLanguage] ?? errorMessages['en']!;

    if (_detectedLanguage == 'ar') {
      return '$baseError. $additionalInfo';
    } else {
      return '$baseError. $additionalInfo';
    }
  }

  // Handle HTTP error responses
  void _handleErrorResponse(http.Response response) {
    String errorMessage = _getErrorMessage("HTTP ${response.statusCode}");

    try {
      final errorData = jsonDecode(response.body);
      if (errorData is Map && errorData.containsKey('error')) {
        String apiError = errorData['error'].toString();
        errorMessage += _detectedLanguage == 'ar'
            ? ". خطأ: $apiError"
            : ". Error: $apiError";
      }
    } catch (e) {
      errorMessage += _detectedLanguage == 'ar'
          ? ". الرد: ${response.body.length > 100 ? response.body.substring(0, 200) + '...' : response.body}"
          : ". Response: ${response.body.length > 100 ? response.body.substring(0, 200) + '...' : response.body}";
    }

    _addBotMessage(errorMessage);
    print('Request failed with status: ${response.statusCode}');
  }

  // Handle exceptions
  void _handleException(dynamic error) {
    String errorMessage = _getErrorMessage("Exception occurred");
    errorMessage += ": ${error.toString()}";
    _addBotMessage(errorMessage);
    print('Exception occurred: $error');
  }

  // Enhanced API testing with language detection
  Future<void> _testAPI() async {
    print('Testing API connection with enhanced language detection...');

    final testMessages = [
      'Hello, how are you?', // English
      'مرحبا، كيف حالك؟', // Arabic
      'Bonjour, comment allez-vous?', // French
      'Hola, ¿cómo estás?', // Spanish
      'Hallo, wie geht es dir?', // German
      '你好吗？', // Chinese
      'こんにちは、元気ですか？', // Japanese
    ];

    for (String testMessage in testMessages) {
      String detectedLang = _detectLanguage(testMessage);
      String languageName = languageNames[detectedLang] ?? 'Unknown';
      print(
          'Test message: "$testMessage" - Detected: $detectedLang ($languageName)');

      try {
        final response = await http
            .post(
              Uri.parse(apiUrl),
              headers: {
                'Content-Type': 'application/json; charset=utf-8',
                'Accept-Language': detectedLang,
                'X-Language': detectedLang,
              },
              body: jsonEncode({
                'question': testMessage,
                'language': detectedLang,
                'language_name': languageName,
                'respond_in_language': detectedLang,
                'instructions': _buildLanguageInstructions(),
                'system_prompt': _buildSystemPrompt(),
              }),
            )
            .timeout(const Duration(seconds: 10));

        print(
            'Response (${response.statusCode}): ${response.body.length > 200 ? response.body.substring(0, 200) + '...' : response.body}\n');
      } catch (e) {
        print('Test failed for "$testMessage": $e\n');
      }
    }
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
        actions: [
          // Enhanced language indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _detectedLanguage.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  _getLanguageFlag(_detectedLanguage),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.white),
            onPressed: _testAPI,
            tooltip: 'Test API',
          ),
        ],
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

  // Get language flag emoji
  String _getLanguageFlag(String langCode) {
    switch (langCode) {
      case 'ar':
        return '🇪🇬';
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      case 'es':
        return '🇪🇸';
      case 'de':
        return '🇩🇪';
      case 'it':
        return '🇮🇹';
      case 'pt':
        return '🇵🇹';
      case 'ru':
        return '🇷🇺';
      case 'zh':
        return '🇨🇳';
      case 'ja':
        return '🇯🇵';
      case 'ko':
        return '🇰🇷';
      default:
        return '𓂀';
    }
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
    return const Padding(
      padding: EdgeInsets.only(right: 8),
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
        textDirection:
            _isRTL(message.text) ? TextDirection.rtl : TextDirection.ltr,
      ),
    );
  }

  // Enhanced RTL detection
  bool _isRTL(String text) {
    return languagePatterns['ar']!.hasMatch(text) ||
        text.contains(RegExp(r'[\u0590-\u05FF]')); // Hebrew support
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage:
                AssetImage('assets/image/483720d21e5105ecbf32b62355020d39.jpg'),
          ),
          const SizedBox(width: 8),
          Text(
            _getTypingText(),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _getTypingText() {
    switch (_detectedLanguage) {
      case 'ar':
        return 'يكتب...';
      case 'fr':
        return 'Tape...';
      case 'es':
        return 'Escribiendo...';
      case 'de':
        return 'Tippt...';
      case 'it':
        return 'Sta scrivendo...';
      case 'pt':
        return 'Digitando...';
      case 'ru':
        return 'Печатает...';
      case 'zh':
        return '正在输入...';
      case 'ja':
        return '入力中...';
      case 'ko':
        return '입력 중...';
      default:
        return 'Typing...';
    }
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
                hintText: _getInputHint(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
              textDirection: _detectedLanguage == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
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

  String _getInputHint() {
    switch (_detectedLanguage) {
      case 'ar':
        return 'اكتب رسالتك...';
      case 'fr':
        return 'Tapez votre message...';
      case 'es':
        return 'Escribe tu mensaje...';
      case 'de':
        return 'Nachricht eingeben...';
      case 'it':
        return 'Scrivi il tuo messaggio...';
      case 'pt':
        return 'Digite sua mensagem...';
      case 'ru':
        return 'Введите сообщение...';
      case 'zh':
        return '输入您的消息...';
      case 'ja':
        return 'メッセージを入力...';
      case 'ko':
        return '메시지를 입력하세요...';
      default:
        return 'Type your message...';
    }
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
