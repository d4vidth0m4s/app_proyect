import 'package:flutter/material.dart';
import 'package:app_proyect/features/chat/chat_screen.dart';
import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/shared/widgets/app_feedback_snackbar.dart';
import 'package:app_proyect/core/utils/speech_to_text_service.dart';

class VoiceChatFAB extends StatefulWidget {
  const VoiceChatFAB({super.key});

  @override
  State<VoiceChatFAB> createState() => _VoiceChatFABState();
}

class _VoiceChatFABState extends State<VoiceChatFAB> {
  final SpeechToTextService _speechService = SpeechToTextService();
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    await _speechService.initialize();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _recognizedText = '';
    });

    _speechService.startListening(
      (result) {
        setState(() {
          _recognizedText = result;
        });
      },
      () {
        _handleRecognitionError();
      },
    );
  }

  Future<void> _stopListening() async {
    final result = await _speechService.stopListening();
    setState(() {
      _isListening = false;
      _recognizedText = '';
    });

    if (result.trim().isEmpty) {
      if (mounted) {
        AppFeedbackSnackBar.show(
          context,
          message: 'No se detectó ningún texto. Intenta de nuevo.',
          type: AppFeedbackType.error,
        );
      }
      return;
    }

    _sendVoiceMessage(result);
  }

  void _handleRecognitionError() {
    _speechService.cancel();
    setState(() {
      _isListening = false;
      _recognizedText = '';
    });

    if (mounted) {
      AppFeedbackSnackBar.show(
        context,
        message: 'Error al reconocer voz. Intenta de nuevo.',
        type: AppFeedbackType.error,
      );
    }
  }

  void _sendVoiceMessage(String message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(initialMessage: message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onLongPressStart: (_) {
            _startListening();
          },
          onLongPressEnd: (_) {
            _stopListening();
          },
          onTap: _isListening
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                },
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: _isListening
                ? const Color(0xFF6C63FF).withValues(alpha: 0.7)
                : AppColors.secondaryVariant,
            onPressed: null,
            child: AppIcons.user(start: false),
          ),
        ),
        if (_isListening)
          Positioned(
            bottom: 70,
            left: -120,
            child: _buildSpeechBubble(),
          ),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _recognizedText.isEmpty ? 'Escuchando...' : _recognizedText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_isListening) {
      _speechService.cancel();
    }
    super.dispose();
  }
}
