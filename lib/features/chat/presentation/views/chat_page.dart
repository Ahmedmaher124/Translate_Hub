import 'package:flutter/material.dart';
import 'package:grade3/features/chat/presentation/views/widgets/chat_item_page.dart';
import 'package:grade3/features/home/data/models/company_model.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.company});

  final CompanyModel company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChatItemPage(
      company: company,
      imageUrl: company.logo,
      name: company.name,
      recivedId: company.id, // تأكد من إرسال المعرف الصحيح هنا
    ));
  }
}
