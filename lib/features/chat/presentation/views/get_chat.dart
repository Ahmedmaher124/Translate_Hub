// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:translate_hub/core/utils/const.dart';
// import 'package:translate_hub/features/chat/data/models/item_chat_model.dart';
// import 'package:translate_hub/features/chat/presentation/views/widgets/chat_item.dart';

// class GetChat extends StatefulWidget {
//   const GetChat({super.key});

//   @override
//   _GetChatState createState() => _GetChatState();
// }

// class _GetChatState extends State<GetChat> {
//   final Dio _dio = Dio();
//   bool _isLoading = true;
//   List<ChatModel> chats = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchChats();
//   }

//   Future<void> _fetchChats() async {
//     try {
//       final response = await _dio.get(
//           'https://translator-project-seven.vercel.app/user/get-chat-history/$?receiverModel=Company'); // تحقق من رابط الـ API

//       if (response.statusCode == 200) {
//         final data = response.data as List;
//         setState(() {
//           chats = data.map((chatData) => ChatModel.fromJson(chatData)).toList();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print('Error fetching chats: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : ListView.separated(
//             itemCount: chats.length,
//             separatorBuilder: (_, __) => const Divider(),
//             itemBuilder: (context, index) {
//               return ChatItem(chat: chats[index]);
//             },
//           );
//   }
// }
