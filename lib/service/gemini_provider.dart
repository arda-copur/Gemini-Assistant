import 'package:flutter/material.dart';
import 'package:gemini_chatbot/model/gemini_message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiProvider with ChangeNotifier {
  static const String geminiApi = 'GEMINI API KEY';

  final TextEditingController chatController = TextEditingController();
  final List<GeminiMessage> messages = [];
  bool isLoading = false;
  Future<void> talkToGemini() async {
    try {
      if (chatController.text.isNotEmpty) {
        messages.add(GeminiMessage(text: chatController.text, isUser: true));
        isLoading = true;
        notifyListeners();

        final model = GenerativeModel(model: 'gemini-pro', apiKey: geminiApi);
        final prompt = chatController.text.trim();
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);

        messages.add(GeminiMessage(text: response.text!, isUser: false));
        isLoading = false;
        chatController.clear();
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  void welcomeMessage() {
    messages.add(GeminiMessage(
      text:
          'Merhaba, ben yapay zeka asistanınız. Lütfen yardıma ihtiyacınız varsa bana iletin. Size yardım etmek için buradayım!',
      isUser: false,
    ));
    notifyListeners();
  }
}
