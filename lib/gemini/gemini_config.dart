import 'package:google_generative_ai/google_generative_ai.dart';

/// Google Gemini AI configuration for flood safety guidance chatbot.
/// Replace with your actual Gemini API key
const String geminiApiKey = 'AIzaSyAL7vnfhANXQTA7AjUj55FtP1CsWMhZh9c';

class GeminiClient {
  late final GenerativeModel _model;
  ChatSession? _chatSession;

  GeminiClient() {
    if (geminiApiKey.isEmpty || geminiApiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      throw Exception('Gemini API key not configured. Please add your API key in lib/gemini/gemini_config.dart');
    }

    // Use the correct model name for v1beta API
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );
  }

  /// Sends a chat message to Gemini AI.
  /// - [messages] should be a list of previous chat turns with 'role' and 'content'.
  /// - [languageLabel] is a human readable language (e.g., 'English', 'हिंदी').
  /// Returns the assistant reply text.
  Future<String> sendChat({
    required List<Map<String, dynamic>> messages,
    required String languageLabel,
  }) async {
    try {
      // Safety-focused system prompt enforcing language and style
      final systemPrompt = '''
You are a flood safety assistant for the Apadamitra app - a flood monitoring and safety system in India.

Your Role:
- Provide accurate, practical flood preparedness and emergency guidance
- Focus on Indian context (monsoons, river systems, dam safety)
- Always prioritize life safety over property
- Keep answers concise and actionable with numbered steps
- If user asks outside flood safety, gently redirect to flood-related topics
- Never claim to be a substitute for authorities - encourage contacting official helplines (NDRF: 011-24363260, State Disaster Management)
- Respond strictly in the user's selected language: $languageLabel

Topics you can help with:
- Flood preparedness and emergency kits
- Evacuation procedures and safety measures
- Understanding flood alerts and warnings
- Post-flood recovery and safety
- Dam safety and water level monitoring
- Monsoon safety tips
- What to do during flash floods
- Protecting family and property

Always be empathetic, clear, and action-oriented.
''';

      // If this is the first message, start a new chat session with system prompt
      if (_chatSession == null || messages.isEmpty) {
        _chatSession = _model.startChat(
          history: [
            Content.text(systemPrompt),
            Content.model([TextPart('I understand. I am your flood safety assistant for Apadamitra. I will provide practical guidance on flood preparedness, emergency response, and safety measures in $languageLabel. How can I help you stay safe today?')]),
          ],
        );
      }

      // Get the last user message
      final lastMessage = messages.isNotEmpty ? messages.last : null;
      if (lastMessage == null || lastMessage['role'] != 'user') {
        throw Exception('Invalid message format');
      }

      final userMessage = lastMessage['content'] as String;

      // Send message and get response
      final response = await _chatSession!.sendMessage(
        Content.text(userMessage),
      );

      final text = response.text;
      if (text == null || text.trim().isEmpty) {
        throw Exception('Empty response from Gemini');
      }

      return text.trim();
    } catch (e) {
      throw Exception('Failed to get response from Gemini: $e');
    }
  }

  /// Reset the chat session (useful for starting fresh conversation)
  void resetChat() {
    _chatSession = null;
  }
}
