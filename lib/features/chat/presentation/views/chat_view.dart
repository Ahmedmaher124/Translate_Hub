import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grade3/core/services/token_storage_service.dart';
import 'package:grade3/features/chat/data/models/item_chat_model.dart';
import 'package:grade3/features/chat/presentation/views/widgets/chat_item_page.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final Dio _dio = Dio();
  bool _isLoading = true;
  List<ChatModel> chats = [];
  List<ChatModel> filteredChats = []; // List to hold filtered chats
  String searchQuery = ''; // Variable to hold
  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    setState(() => _isLoading = true);
    final token = await TokenStorageService.getToken();
    try {
      final response = await _dio.get(
        'https://translator-project-seven.vercel.app/user/get-last-chats',
        options: Options(headers: {'token': token}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final List rawData = responseData['chats'] ?? [];

        final parsedChats =
            rawData.map((chat) => ChatModel.fromJson(chat)).toList();
        setState(() {
          chats = parsedChats;
          filteredChats = chats; // Initialize filteredChats with all chats
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTimeUtc = DateTime.parse(dateTimeString);
      final localTime = dateTimeUtc.toLocal(); // تحويل إلى التوقيت المحلي
      return DateFormat.jm().format(localTime); // مثل 2:30 PM
    } catch (e) {
      return '';
    }
  }

  void _filterChats(String query) {
    setState(() {
      searchQuery = query;
      filteredChats = chats
          .where((chat) =>
              chat.name.toLowerCase().contains(query.toLowerCase()) ||
              (chat.company?.name.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (chat.translator?.name
                      .toLowerCase()
                      .contains(query.toLowerCase()) ??
                  false))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat',
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: _filterChats, // Filter chats as the user types
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200, // Light background for search
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Loading and chat list display
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredChats.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat,
                                size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            const Text('No chats available',
                                style: TextStyle(fontSize: 18)),
                            TextButton(
                                onPressed: _fetchChats,
                                child: const Text('Retry')),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchChats,
                        child: ListView.separated(
                          itemCount: filteredChats.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 0,
                            thickness: 0,
                          ),
                          itemBuilder: (context, index) {
                            final chat = filteredChats[index];

                            // تحديد إذا كان الشركة أو المترجم متاحين لعرضهم
                            final name = chat.company?.name ??
                                chat.translator?.name ??
                                chat.name;
                            final image = chat.company?.logo ??
                                chat.translator?.image ??
                                chat.image;

                            return ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: image.isNotEmpty
                                    ? NetworkImage(image)
                                    : const AssetImage(
                                            'assets/images/man_picture.jpg')
                                        as ImageProvider,
                              ),
                              title: Text(name),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    chat.seen
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                    color:
                                        chat.seen ? Colors.green : Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(chat.message)),
                                ],
                              ),
                              trailing: Text(_formatTime(chat.date),
                                  style: const TextStyle(fontSize: 12)),
                              onTap: () async {
                                final receiverId = chat.receiverId ?? '';

                                if (receiverId.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Receiver ID missing")),
                                  );
                                  return;
                                }

                                final updatedChat = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatItemPage(
                                      company: chat.company,
                                      translator: chat.translator,
                                      imageUrl: chat.image,
                                      name: chat.name,
                                      recivedId: receiverId,
                                    ),
                                  ),
                                );

                                if (updatedChat != null &&
                                    updatedChat is ChatModel) {
                                  setState(() {
                                    chats[index] = chats[index].copyWith(
                                      message: updatedChat.message,
                                      date: updatedChat.date,
                                    );
                                    // Re-filter chats after updating
                                    _filterChats(searchQuery);
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
