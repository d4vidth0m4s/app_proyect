// api.dart
import 'dart:convert';
import 'dart:io';

class ChatApi {
  static const _apiKey = String.fromEnvironment('GROQ_API_KEY');
  static const _apiUrl = String.fromEnvironment(
    'GROQ_API_URL',
    defaultValue: 'https://api.groq.com/openai/v1/chat/completions',
  );

  // Modelo correcto para Groq
  static const _model = String.fromEnvironment(
    'GROQ_MODEL',
    defaultValue: 'llama-3.1-8b-instant',
  );

  final HttpClient _httpClient = HttpClient();

  final List<Map<String, String>> _history = [
    {
      'role': 'system',
      'content':
          'Eres un asistente experto en el cuidado, alimentación y manejo de cerdos. Tu nombre es Pigbot, pero no lo menciones en cada respuesta. Usa lenguaje claro y sencillo. Cada vez que te hagan una pregunta referente al diagnóstico responderás iniciando con el número "1".',
    },
  ];

  Future<String> sendMessage(String message) async {
    if (_apiKey.isEmpty) {
      throw StateError(
        'Falta GROQ_API_KEY. Define --dart-define=GROQ_API_KEY=TU_API_KEY '
        '(o usa --dart-define-from-file) antes de ejecutar la app.',
      );
    }

    _history.add({'role': 'user', 'content': message});

    try {
      final request = await _httpClient.postUrl(Uri.parse(_apiUrl));

      request.headers
        ..set('Content-Type', 'application/json')
        ..set('Authorization', 'Bearer $_apiKey');

      // Payload corregido
      request.write(
        jsonEncode({
          'model': _model,
          'messages': _history,
          'temperature': 0.3,
          'max_completion_tokens': 1024, // CORRECCIÓN IMPORTANTE
          'top_p': 1,
          'stream': false, // si quieres streaming, cámbialo a true
        }),
      );

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final json = jsonDecode(body);

        final content = json['choices'][0]['message']['content'] as String;

        _history.add({'role': 'assistant', 'content': content});

        return content;
      } else {
        final json = jsonDecode(body);
        final errorMsg = json['error']?['message'] ?? body;
        throw HttpException('Error ${response.statusCode}: $errorMsg');
      }
    } on SocketException {
      throw const SocketException('Error de conexión: Verifica tu internet');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void dispose() => _httpClient.close();
}
