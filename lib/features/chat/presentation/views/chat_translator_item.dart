import 'package:flutter/material.dart';
import 'package:grade3/features/chat/presentation/views/widgets/chat_item_page.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';

class ChatTranslatorPage extends StatelessWidget {
  const ChatTranslatorPage({super.key, required this.translator});

  final TranslatorModel translator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatItemPage(
        translator: translator,
        imageUrl: translator.image,
        name: translator.name,
        recivedId: translator.userId,
      ),
    );
  }
}
