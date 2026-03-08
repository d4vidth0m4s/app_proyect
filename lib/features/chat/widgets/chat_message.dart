import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:app_proyect/features/chat/widgets/typing_indicator.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;
  final bool isError;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
    this.isError = false,
  });

  // FunciÃ³n para obtener el color del avatar
  Color _getAvatarColor() {
    if (isError) return Colors.red;
    if (isUser) return AppColors.secondary;
    return AppColors.secondaryVariant;
  }

  // FunciÃ³n para construir el contenido del avatar
  Widget _buildAvatarContent() {
    if (isUser) {
      return const Icon(Icons.person, color: Colors.white, size: 35);
    }
    if (isError) {
      return const Icon(Icons.error, color: Colors.white);
    }
    return AppIcons.user(width: 35, height: 35, start: false);
  }

  // FunciÃ³n para construir el avatar
  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: _getAvatarColor(),
      child: _buildAvatarContent(),
      maxRadius: 25,
    );
  }

  // FunciÃ³n para obtener el color de fondo del mensaje
  Color _getMessageBackgroundColor() {
    if (isUser) return AppColors.primary;
    if (isError) return Colors.red[100]!;
    return Colors.white;
  }

  // FunciÃ³n para obtener el color del texto
  Color _getTextColor() {
    if (isUser) return Colors.black87;
    if (isError) return Colors.red[900]!;
    return Colors.black87;
  }

  // FunciÃ³n para obtener el color del timestamp
  Color _getTimestampColor() {
    if (isUser) return Colors.black54;
    if (isError) return Colors.red[700]!;
    return Colors.black54;
  }

  // FunciÃ³n para formatear la hora
  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  // FunciÃ³n para construir la decoraciÃ³n del contenedor del mensaje
  BoxDecoration _getMessageDecoration() {
    return BoxDecoration(
      color: _getMessageBackgroundColor(),
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  // FunciÃ³n para construir el contenido del mensaje
  Widget _buildMessageContent() {
    if (isTyping) {
      return const TypingIndicator();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(color: _getTextColor())),
        const SizedBox(height: 4),
        Text(
          _formatTime(timestamp),
          style: TextStyle(color: _getTimestampColor(), fontSize: 10),
        ),
      ],
    );
  }

  // FunciÃ³n para construir el contenedor del mensaje
  Widget _buildMessageContainer() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: _getMessageDecoration(),
        child: _buildMessageContent(),
      ),
    );
  }

  // FunciÃ³n para construir los elementos de la fila
  List<Widget> _buildRowChildren() {
    List<Widget> children = [];

    if (!isUser) {
      children.addAll([_buildAvatar(), const SizedBox(width: 16)]);
    }

    children.add(_buildMessageContainer());

    if (isUser) {
      children.addAll([const SizedBox(width: 16), _buildAvatar()]);
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: _buildRowChildren(),
      ),
    );
  }
}
