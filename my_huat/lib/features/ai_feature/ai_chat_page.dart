// lib/features/ai_feature/ai_chat_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_huat/shared/widgets/arc_header.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _chipsScrollController = ScrollController();

  late final GenerativeModel _model;
  late stt.SpeechToText _speech;
  late FlutterTts _tts;

  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isTyping = false;

  final Color navyBlue = const Color(0xFF0D3A6D);

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello Christ! I am your MHuat Financial Assistant. 💰\n\nAsk me about saving, investing, or insurance.',
      'isUser': false,
    },
  ];

  final List<String> _suggestions = const [
    '💡 Best saving tips',
    '📈 Low‑risk investment',
    '📊 Emergency fund size',
    '💰 Budgeting for students',
  ];

  @override
  void initState() {
    super.initState();
    _initVoice();
    _initModel();
  }

  void _initModel() {
    // 🌟 Using your working gemini-2.0-flash logic
    _model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      generationConfig: GenerationConfig(temperature: 0.8),
    );
  }

  // --- Voice Methods ---
  Future<void> _initVoice() async {
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    _tts.setStartHandler(() => setState(() => _isSpeaking = true));
    _tts.setCompletionHandler(() => setState(() => _isSpeaking = false));
  }

  // --- UI Decoration (Unified MHuat Style) ---
  BoxDecoration _softModuleDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.black.withOpacity(0.05), width: 1),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.02), offset: const Offset(0, 8), blurRadius: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Column(
        children: [
          // 1. Unified ArcHeader
          ArcHeader(title: "MHuat"),

          // 2. Navigation Row
          _buildNavRow(),

          // 3. Grouped Chat Module with Avatars
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: _softModuleDecoration(),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isTyping && index == _messages.length) {
                      return _buildTypingIndicator();
                    }
                    final msg = _messages[index];
                    return _buildChatBubble(text: msg['text'], isUser: msg['isUser']);
                  },
                ),
              ),
            ),
          ),

          // 4. Input & Interaction
          _buildSuggestionChips(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildNavRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text("AI Assistant", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navyBlue)),
          const Spacer(),
          if (_isSpeaking) const Icon(Icons.volume_up, color: Colors.amber, size: 20),
        ],
      ),
    );
  }

  Widget _buildChatBubble({required String text, required bool isUser}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) // 🤖 AI Avatar
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: navyBlue.withOpacity(0.1),
                child: Icon(Icons.auto_awesome, color: navyBlue, size: 16),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? navyBlue : Colors.grey[100],
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 14, height: 1.4),
              ),
            ),
          ),
          if (isUser) // 👤 User Avatar
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: navyBlue,
                child: const Icon(Icons.person, color: Colors.white, size: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Thinking...", style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        controller: _chipsScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(_suggestions[index], style: const TextStyle(fontSize: 12)),
              onPressed: () => _sendMessage(_suggestions[index]),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: navyBlue.withOpacity(0.1)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isListening ? Icons.stop_circle : Icons.mic_none, color: _isListening ? Colors.red : navyBlue),
            onPressed: _isListening ? _stopListening : _startListening,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Ask me anything...', border: InputBorder.none),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          GestureDetector(
            onTap: () => _sendMessage(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: navyBlue, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // --- Logic Methods ---
  Future<void> _sendMessage([String? preset]) async {
    final text = preset ?? _controller.text.trim();
    if (text.isEmpty || _isTyping) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _controller.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final prompt = 'You are a helpful financial advisor for students. User: $text';
      final response = await _model.generateContent([Content.text(prompt)]);
      final reply = response.text ?? 'I could not generate a response.';

      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({'text': reply, 'isUser': false});
        });
        _speak(reply);
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) setState(() => _isTyping = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        _controller.text = result.recognizedWords;
        if (result.finalResult) {
          _stopListening();
          _sendMessage(result.recognizedWords);
        }
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _speak(String text) async {
    String clean = text.replaceAll('*', '').replaceAll('#', '');
    await _tts.speak(clean);
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();
    setState(() => _isSpeaking = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _chipsScrollController.dispose();
    _tts.stop();
    super.dispose();
  }
}