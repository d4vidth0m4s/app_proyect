import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_proyect/data/remote/chat_api.dart';
import 'package:app_proyect/features/chat/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
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
  }

  // FunciÃ³n para inicializar el chat con mensaje de bienvenida
  void _initializeChat() {
    _addMessage(
      text:
          "Â¡Hola! Soy tu asistente experto en cerdos PIGBOT. Â¿En quÃ© puedo ayudarte hoy?",
      isUser: false,
    );
  }

  // FunciÃ³n para agregar mensajes a la lista
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

  // FunciÃ³n para hacer scroll hacia abajo
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

  // FunciÃ³n para validar el mensaje antes de enviarlo
  bool _isValidMessage(String text) {
    return text.trim().isNotEmpty && !_isWaitingForResponse;
  }

  // FunciÃ³n para mostrar el indicador de escritura
  void _showTypingIndicator() {
    _addMessage(text: "...", isUser: false, isTyping: true);
  }

  // FunciÃ³n para remover el Ãºltimo mensaje (usado para el indicador de escritura)
  void _removeLastMessage() {
    if (_messages.isNotEmpty) {
      setState(() {
        _messages.removeLast();
      });
    }
  }

  // FunciÃ³n para manejar errores de la API
  void _handleApiError(dynamic error) {
    _removeLastMessage();
    _addMessage(
      text: "Error: ${error.toString()}",
      isUser: false,
      isError: true,
    );
  }

  // FunciÃ³n para manejar respuesta exitosa de la API
  void _handleApiResponse(String response) {
    _removeLastMessage();
    _addMessage(text: response, isUser: false);
  }

  // FunciÃ³n para enviar mensaje del usuario
  void _sendUserMessage(String text) {
    _messageController.clear();
    _addMessage(text: text, isUser: true);
  }

  // FunciÃ³n para establecer el estado de espera
  void _setWaitingState(bool isWaiting) {
    setState(() {
      _isWaitingForResponse = isWaiting;
    });
  }

  // FunciÃ³n principal para manejar el envÃ­o de mensajes
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

  // FunciÃ³n para construir el AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: const Text('Asistente de IA Pigbot'),
      centerTitle: true,
    );
  }

  // FunciÃ³n para construir la lista de mensajes
  Widget _buildMessagesList() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemBuilder: (context, index) => _messages[index],
      ),
    );
  }

  // FunciÃ³n para construir el campo de texto
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

  // FunciÃ³n para obtener la decoraciÃ³n del TextField
  InputDecoration _getTextFieldDecoration() {
    return InputDecoration(
      hintText: 'Escribe un mensaje...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 233, 232, 245),
    );
  }

  // FunciÃ³n para construir el botÃ³n de envÃ­o
  Widget _buildSendButton() {
    return IconButton(
      icon: const Icon(Icons.send),
      onPressed: _isWaitingForResponse
          ? null
          : () => _handleSubmitted(_messageController.text),
      color: Colors.green,
    );
  }

  // FunciÃ³n para obtener la decoraciÃ³n del contenedor del compositor
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

  // FunciÃ³n para construir el compositor de mensajes
  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: _getComposerDecoration(),
      child: Row(children: [_buildTextField(), _buildSendButton()]),
    );
  }

  // FunciÃ³n para construir el cuerpo principal
  Widget _buildBody() {
    return SafeArea(
      child: Column(children: [_buildMessagesList(), _buildMessageComposer()]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  // FunciÃ³n para liberar recursos
  void _disposeResources() {
    _chatApi.dispose();
    _messageController.dispose();
    _scrollController.dispose();
  }
}
