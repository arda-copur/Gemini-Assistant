import 'package:flutter/material.dart';
import 'package:gemini_chatbot/base/base_state.dart';
import 'package:gemini_chatbot/service/gemini_provider.dart';
import 'package:provider/provider.dart';

class GeminiView extends StatefulWidget {
  const GeminiView({super.key});

  @override
  State<GeminiView> createState() => _GeminiViewState();
}

class _GeminiViewState extends BaseState<GeminiView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gemini = Provider.of<GeminiProvider>(context);
    gemini.addListener(() {
      if (_scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gemini = Provider.of<GeminiProvider>(context);
    return Column(
      children: [
        SizedBox(
          height: mediaQuery.size.height * 0.7,
          width: mediaQuery.size.height * 0.8,
          child: ListView.builder(
              controller: _scrollController,
              itemCount: gemini.messages.length,
              itemBuilder: (context, index) {
                final message = gemini.messages[index];
                return ListTile(
                  leading: message.isUser
                      ? null
                      : const CircleAvatar(
                          backgroundImage: AssetImage('YOURS-CHATBOTS-IMAGE'),
                        ),
                  title: Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: message.isUser
                                ? theme.colorScheme.background
                                : theme.colorScheme.onSecondary,
                            borderRadius: message.isUser
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20))
                                : const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                        child: Text(message.text,
                            style: message.isUser
                                ? theme.textTheme.bodyMedium
                                    ?.copyWith(color: Colors.green)
                                : theme.textTheme.bodyMedium
                                    ?.copyWith(color: Colors.red))),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(
              bottom: 12, top: 16.0, left: 16.0, right: 16),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3))
                ]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: gemini.chatController,
                    style: theme.textTheme.titleSmall,
                    decoration: InputDecoration(
                        hintText:
                            'Yapay zeka asistanınızla konuşmaya başlayın...',
                        hintStyle: theme.textTheme.titleSmall!
                            .copyWith(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20)),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                gemini.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          gemini.talkToGemini();
                        },
                        child: const Text(
                          "Gönder",
                          style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
