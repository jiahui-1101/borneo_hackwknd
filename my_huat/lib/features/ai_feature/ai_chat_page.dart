// lib/features/ai_feature/ai_chat_page.dart
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; // 🌟 导入刚刚安装的 AI 包

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();
  
  // 🌟 1. 在这里填入你刚才复制的 API Key！
  static const String _apiKey = 'AIzaSyAPgN5NVMtpEnc82YFRUvI58Wy0cu_oHzc'; 
  
  late final GenerativeModel _model;

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! I am your MHuat AI Assistant. Want some tips on how to save money or analyze your spending today?',
      'isUser': false, 
    },
  ];

  @override
  void initState() {
    super.initState();
    // 🌟 2. 初始化 Gemini 大脑 (使用 gemini-1.5-flash 模型，速度最快)
    _model = GenerativeModel(
      model: 'gemini-1.5-flash', 
      apiKey: _apiKey,
    );
  }

  // 🌟 3. 真正发送消息给 AI 的核心逻辑
  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text;
    
    setState(() {
      // 把用户的话显示出来，清空输入框
      _messages.add({'text': userText, 'isUser': true});
      _controller.clear();
      // 显示 AI 正在思考的动画
      _messages.add({'text': 'Thinking...', 'isUser': false, 'isTyping': true});
    });

    try {
      // 把用户的话打包发给 Gemini API
      final content = [Content.text(userText)];
      final response = await _model.generateContent(content);

      if (mounted) {
        setState(() {
          _messages.removeLast(); // 删掉 "Thinking..." 的加载动画
          // 把真正的 AI 回答显示出来！
          _messages.add({
            'text': response.text ?? 'Sorry, I got confused for a second!',
            'isUser': false
          });
        });
      }
    } catch (e) {
      // 如果网络不好或者 API Key 填错了，给个错误提示
      if (mounted) {
        setState(() {
          _messages.removeLast();
          _messages.add({
            'text': 'Oops! Connection error. Please check your API Key and internet.',
            'isUser': false
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.amber), 
            SizedBox(width: 10),
            Text('MHuat AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
        backgroundColor: const Color(0xFF0D3A6D),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(
                  text: msg['text'],
                  isUser: msg['isUser'],
                  isTyping: msg['isTyping'] ?? false,
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble({required String text, required bool isUser, required bool isTyping}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF0D3A6D) : Colors.white,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: isTyping 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0D3A6D)))
          : Text(text, style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 15)),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12).copyWith(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -3))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ask MHuat AI something...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF0D3A6D),
            child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white), onPressed: _sendMessage),
          ),
        ],
      ),
    );
  }
}