import 'dart:convert';
import 'package:http/http.dart' as http;

/// OpenAI configuration and client for flood safety guidance chatbot.
/// Values are provided at runtime via environment variables.
/// Do not hardcode keys or endpoints.
const String openAIApiKey = String.fromEnvironment('OPENAI_PROXY_API_KEY');
const String openAIEndpoint = String.fromEnvironment('OPENAI_PROXY_ENDPOINT');

class OpenAIClient {
  OpenAIClient();

  /// Sends a chat completion request to OpenAI.
  /// - [messages] should be a list of previous chat turns.
  /// - [languageLabel] is a human readable language (e.g., 'English', 'हिंदी').
  /// Returns the assistant reply text.
  Future<String> sendChat({
    required List<Map<String, dynamic>> messages,
    required String languageLabel,
    String model = 'gpt-4o',
    Duration timeout = const Duration(seconds: 45),
  }) async {
    if (openAIApiKey.isEmpty || openAIEndpoint.isEmpty) {
      throw Exception('OpenAI environment not configured.');
    }

    final base = openAIEndpoint.endsWith('/')
        ? openAIEndpoint.substring(0, openAIEndpoint.length - 1)
        : openAIEndpoint;
    final uri = Uri.parse('$base/chat/completions');

    // Safety-focused system prompt enforcing language and style.
    final systemPrompt = '''
You are a flood safety assistant for the Apadamitra app.
Goals:
- Provide accurate, practical, location-agnostic flood preparedness and emergency guidance.
- Always prioritize life safety over property.
- Keep answers concise and scannable: use short paragraphs and numbered steps.
- If the user asks outside flood safety, gently steer back.
- Never claim to be a substitute for authorities. Encourage contacting official helplines when needed.
- Respond strictly in the user's selected language: $languageLabel.
''';

    final payload = {
      'model': model,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...messages,
      ],
      'temperature': 0.5,
      'max_tokens': 500,
    };

    final headers = {
      'Authorization': 'Bearer $openAIApiKey',
      'Content-Type': 'application/json',
    };

    final res = await http
        .post(uri, headers: headers, body: utf8.encode(jsonEncode(payload)))
        .timeout(timeout);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      String msg = 'OpenAI API error: HTTP ${res.statusCode}';
      try {
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        if (body is Map && body['error'] != null) {
          msg += ' - ${body['error']}';
        }
      } catch (_) {}
      throw Exception(msg);
    }

    final body = jsonDecode(utf8.decode(res.bodyBytes));
    final choices = body['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('No response from model');
    }
    final content = choices.first['message']?['content'];
    if (content is String && content.trim().isNotEmpty) {
      return content.trim();
    }
    throw Exception('Malformed response from model');
  }
}
