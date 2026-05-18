import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechToTextService {
  static final SpeechToTextService _instance = SpeechToTextService._internal();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  bool _isListening = false;
  String _recognizedText = '';
  bool _isInitialized = false;

  factory SpeechToTextService() {
    return _instance;
  }

  SpeechToTextService._internal();

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;

  Future<bool> initialize() async {
    if (_isInitialized && _speechToText.isAvailable) {
      return true;
    }

    final available = await _speechToText.initialize(
      onError: (error) => print('Speech error: $error'),
      onStatus: (status) => print('Speech status: $status'),
    );
    _isInitialized = available;
    return available;
  }

  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  void startListening(
    Function(String) onResult,
    Function() onError,
  ) async {
    if (_isListening) return;

    final hasPermission = await requestMicrophonePermission();
    if (!hasPermission) {
      onError();
      return;
    }

    final initialized = await initialize();
    if (!initialized) {
      onError();
      return;
    }

    _isListening = true;
    _recognizedText = '';

    try {
      await _speechToText.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          onResult(_recognizedText);
        },
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
        ),
      );
    } catch (e) {
      _isListening = false;
      onError();
    }
  }

  Future<String> stopListening() async {
    if (!_isListening) {
      return _recognizedText;
    }
    _isListening = false;
    await _speechToText.stop();
    return _recognizedText;
  }

  void cancel() async {
    _isListening = false;
    _recognizedText = '';
    await _speechToText.cancel();
  }
}
