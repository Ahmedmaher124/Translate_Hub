import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grade3/features/chat/data/models/get_chat_model/message.dart';
import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';
import 'package:intl/intl.dart'; // استيراد مكتبة intl لتنسيق الوقت
import 'package:grade3/core/services/token_storage_service.dart';
import 'package:grade3/features/chat/data/models/get_chat_model/get_chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatItemPage extends StatefulWidget {
  const ChatItemPage({
    super.key,
    this.company,
    this.translator,
    required this.imageUrl,
    required this.name,
    required this.recivedId,
  });

  final CompanyModel? company;
  final TranslatorModel? translator;
  final String imageUrl;
  final String name;
  final String recivedId;

  @override
  State<ChatItemPage> createState() => _ChatItemPageState();
}

class _ChatItemPageState extends State<ChatItemPage> {
  final TextEditingController _messageController = TextEditingController();
  final Dio _dio = Dio();
  List<Message> _messages = [];
  bool _isSending = false;
  bool _isLoading = true;
  String? token;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    token = await TokenStorageService.getToken();
    currentUserId = await TokenStorageService.getUserId();

    if (token == null || widget.recivedId.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('خطأ: لم يتم العثور على التوكن أو رقم المتلقي')),
      );
      return;
    }

    await _loadMessages();
    await _fetchChats();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'chat_messages_${widget.recivedId}';
    final messagesString = prefs.getString(key);

    if (messagesString != null) {
      final List<dynamic> decodedMessages = jsonDecode(messagesString);
      setState(() {
        _messages = decodedMessages
            .map((e) => Message.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    } else {
      log("No messages found for $key");
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedMessages =
        jsonEncode(_messages.map((e) => e.toJson()).toList());
    final key = 'chat_messages_${widget.recivedId}';
    await prefs.setString(key, encodedMessages);
    log("Messages saved successfully for $key!");
  }

  Future<void> _fetchChats() async {
    final receiverModel = widget.translator != null ? 'Translator' : 'Company';

    try {
      final response = await _dio.get(
        'https://translator-project-seven.vercel.app/user/get-chat-history/${widget.recivedId}?receiverModel=$receiverModel',
        options: Options(headers: {'token': token}),
      );

      log('API Response: ${response.data}');

      final data = response.data['chats'];

      if (data is List) {
        final newMessages = <Message>[];

        for (var chatData in data) {
          final chatModel = GetChatModel.fromJson(chatData);
          final chat = chatModel.chat;

          if (chat?.messages != null) {
            final isSender = chat?.senderId?.id == currentUserId;

            final messages = chat!.messages!.map(
              (msg) => msg.copyWith(isSender: isSender),
            );

            newMessages.addAll(messages);
          }
        }

        setState(() {
          _messages = newMessages;
          _isLoading = false;
        });

        await _saveMessages();
      } else {
        setState(() => _isLoading = false);
        log('No chat data found or wrong format: ${response.data}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      log('Error fetching chats: $e');
    }
  }

  Future<void> _handleSendMessage() async {
    if (_isSending || _messageController.text.trim().isEmpty) return;

    setState(() => _isSending = true);
    final text = _messageController.text.trim();

    final newMessage = Message(
      body: text,
      createdAt: DateTime.now(),
      isSender: true,
    );

    setState(() {
      _messages.add(newMessage);
    });

    final success = await _sendMessageToAPI(message: text);

    if (success) {
      _messageController.clear();
      // ignore: use_build_context_synchronously
      FocusScope.of(context).unfocus();

      await _fetchChats();
      await _saveMessages();
    } else {
      setState(() {
        _messages.removeLast();
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل إرسال الرسالة")),
      );
    }

    setState(() => _isSending = false);
  }

  Future<bool> _sendMessageToAPI({required String message}) async {
    try {
      final response = await _dio.post(
        'https://translator-project-seven.vercel.app/user/send-message/${widget.recivedId}',
        data: FormData.fromMap({
          'body': message,
          'receiverId': widget.recivedId,
        }),
        options: Options(
            contentType: 'multipart/form-data', headers: {'token': token}),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      log('Error sending message: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(widget.imageUrl, widget.name),
      body: Column(
        children: [
          _buildMessagesList(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(String imageUrl, String name) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop(
            _messages.isNotEmpty ? _messages.last : null,
          );
        },
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 20),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSent = message.isSender ?? true;

                // تنسيق الوقت
                String formattedTime =
                    DateFormat.jm().format(message.createdAt ?? DateTime.now());

                return Align(
                  alignment:
                      isSent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSent ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.body ?? '',
                          style: TextStyle(
                              color: isSent ? Colors.white : Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: isSent ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Write a message...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: _isSending
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : IconButton(
                    onPressed: _handleSendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
