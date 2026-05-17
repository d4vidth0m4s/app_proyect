import 'package:app_proyect/data/remote/chat_api.dart';
import 'package:app_proyect/features/chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;

  const ChatScreen({super.key, this.initialMessage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ChatApi _chatApi = ChatApi();
  bool _isWaitingForResponse = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _sendInitialMessage();
  }

  void _initializeChat() {
    _addMessage(
      text: 'Hola. Soy tu asistente experto en cerdos PIGBOT. En que puedo ayudarte hoy?',
      isUser: false,
    );
  }

  void _sendInitialMessage() {
    final initialMessage = widget.initialMessage?.trim();
    if (initialMessage == null || initialMessage.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handleSubmitted(initialMessage);
    });
  }

  void _addMessage({
    required String text,
    required bool isUser,
    bool isTyping = false,
    bool isError = false,
  }) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: isUser,
          timestamp: DateTime.now(),
          isTyping: isTyping,
          isError: isError,
        ),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  bool _isValidMessage(String text) {
    return text.trim().isNotEmpty && !_isWaitingForResponse;
  }

  void _showTypingIndicator() {
    _addMessage(text: '...', isUser: false, isTyping: true);
  }

  void _removeLastMessage() {
    if (_messages.isEmpty) return;

    setState(() {
      _messages.removeLast();
    });
  }

  void _handleApiError(dynamic error) {
    _removeLastMessage();
    _addMessage(
      text: 'Error: ${error.toString()}',
      isUser: false,
      isError: true,
    );
  }

  void _handleApiResponse(String response) {
    _removeLastMessage();
    _addMessage(text: response, isUser: false);
  }

  void _sendUserMessage(String text) {
    _messageController.clear();
    _addMessage(text: text, isUser: true);
  }

  void _setWaitingState(bool isWaiting) {
    setState(() {
      _isWaitingForResponse = isWaiting;
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (!_isValidMessage(text)) return;

    _sendUserMessage(text);
    _setWaitingState(true);
    _showTypingIndicator();

    try {
      final response = await _chatApi.sendMessage(text);
      _handleApiResponse(response);
    } catch (e) {
      _handleApiError(e);
    } finally {
      _setWaitingState(false);
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: const Text('Asistente de IA Pigbot'),
      centerTitle: true,
    );
  }

  Widget _buildMessagesList() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) => _messages[index],
      ),
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: TextField(
        controller: _messageController,
        enabled: !_isWaitingForResponse,
        textCapitalization: TextCapitalization.sentences,
        decoration: _getTextFieldDecoration(),
        onSubmitted: _handleSubmitted,
      ),
    );
  }

  InputDecoration _getTextFieldDecoration() {
    return InputDecoration(
      hintText: 'Escribe un mensaje...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 233, 232, 245),
    );
  }

  Widget _buildSendButton() {
    return IconButton(
      icon: const Icon(Icons.send),
      onPressed: _isWaitingForResponse
          ? null
          : () => _handleSubmitted(_messageController.text),
      color: Colors.green,
    );
  }

  BoxDecoration _getComposerDecoration() {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, -1),
        ),
      ],
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: _getComposerDecoration(),
      child: Row(
        children: [_buildTextField(), _buildSendButton()],
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [_buildMessagesList(), _buildMessageComposer()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  @override
  void dispose() {
    _chatApi.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
