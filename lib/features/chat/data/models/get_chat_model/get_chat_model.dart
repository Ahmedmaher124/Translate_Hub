import 'chat.dart';

class GetChatModel {
  String? message;
  Chat? chat;

  GetChatModel({this.message, this.chat});

  factory GetChatModel.fromJson(Map<String, dynamic> json) => GetChatModel(
        message: json['message'] as String?,
        chat: json['chat'] == null
            ? null
            : Chat.fromJson(json['chat'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'chat': chat?.toJson(),
      };
}
