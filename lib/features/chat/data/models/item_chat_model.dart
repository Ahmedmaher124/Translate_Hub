// import 'package:translate_hub/features/home/data/models/company_model.dart';
// import 'package:translate_hub/features/home/data/models/translator_model.dart';

// class ChatModel {
//   final String name;
//   final String image;
//   final String message;
//   final bool seen;
//   final String date;
//   final bool isSender;
//   final String? receiverId;
//   final CompanyModel? company;
//   final TranslatorModel? translator;

//   ChatModel({
//     required this.name,
//     required this.image,
//     required this.message,
//     required this.seen,
//     required this.date,
//     required this.isSender,
//     this.receiverId,
//     this.company,
//     this.translator,
//   });

//   factory ChatModel.fromJson(Map<String, dynamic> json) {
//     final receiverData = json['receiverId'];
//     final profilePic = receiverData?['profilePic'];
//     final List<dynamic> messages = json['messages'] ?? [];
//     final lastMessage = messages.isNotEmpty ? messages.last : null;

//     final name = receiverData?['name'] ?? 'Unknown';
//     final receiverIdString = receiverData?['_id']?.toString();

//     // معالجة الصورة
//     String image = '';
//     if (profilePic is Map && profilePic['secure_url'] != null) {
//       image = profilePic['secure_url'].toString();
//     } else if (profilePic is String) {
//       image = profilePic;
//     }

//     CompanyModel? company;
//     TranslatorModel? translator;

//     if (receiverData != null && receiverData['role'] == 'company') {
//       company = CompanyModel.fromJson(receiverData);
//     } else if (receiverData != null && receiverData['role'] == 'translator') {
//       translator = TranslatorModel.fromJson(receiverData);
//     }

//     return ChatModel(
//       name: name.toString(),
//       image: image,
//       message: lastMessage != null && lastMessage['body'] != null
//           ? lastMessage['body'].toString()
//           : 'No message yet',
//       seen: json['seen'] ?? false,
//       date: lastMessage != null && lastMessage['createdAt'] != null
//           ? lastMessage['createdAt'].toString()
//           : '',
//       isSender: lastMessage != null && lastMessage['isSender'] != null
//           ? lastMessage['isSender']
//           : false,
//       receiverId: receiverIdString,
//       company: company,
//       translator: translator,
//     );
//   }

//   ChatModel copyWith({
//     String? message,
//     String? date,
//     String? image,
//     String? name,
//     bool? seen,
//     String? receiverId,
//     CompanyModel? company,
//     TranslatorModel? translator,
//     bool? isSender,
//   }) {
//     return ChatModel(
//       name: name ?? this.name,
//       image: image ?? this.image,
//       message: message ?? this.message,
//       seen: seen ?? this.seen,
//       date: date ?? this.date,
//       isSender: isSender ?? this.isSender,
//       receiverId: receiverId ?? this.receiverId,
//       company: company ?? this.company,
//       translator: translator ?? this.translator,
//     );
//   }

//   factory ChatModel.localMessage(String messageText) {
//     return ChatModel(
//       name: 'You',
//       image: '', // ممكن تعدله ليكون صورة المستخدم
//       message: messageText,
//       seen: false,
//       date: DateTime.now().toIso8601String(),
//       isSender: true,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'image': image,
//       'message': message,
//       'seen': seen,
//       'date': date,
//       'isSender': isSender,
//       'receiverId': receiverId,
//       'company': company?.toJson(),
//       'translator': translator?.toJson(),
//     };
//   }
// }

import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';

class ChatModel {
  final String name;
  final String image;
  final String message;
  final bool seen;
  final String date;
  final bool isSender;
  final String? senderId;
  final String? receiverId;
  final CompanyModel? company;
  final TranslatorModel? translator;

  ChatModel({
    required this.name,
    required this.image,
    required this.message,
    required this.seen,
    required this.date,
    required this.isSender,
    this.senderId,
    this.receiverId,
    this.company,
    this.translator,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final receiverData = json['receiverId'];
    final profilePic = receiverData?['profilePic'];
    final List<dynamic> messages = json['messages'] ?? [];
    final lastMessage = messages.isNotEmpty ? messages.last : null;

    final name = receiverData?['name'] ?? 'Unknown';
    final receiverIdString = receiverData?['_id']?.toString();
    final senderIdString = lastMessage?['senderId']?.toString();

    String image = '';
    if (profilePic is Map && profilePic['secure_url'] != null) {
      image = profilePic['secure_url'].toString();
    } else if (profilePic is String) {
      image = profilePic;
    }

    CompanyModel? company;
    TranslatorModel? translator;

    if (receiverData != null && receiverData['role'] == 'company') {
      company = CompanyModel.fromJson(receiverData);
    } else if (receiverData != null && receiverData['role'] == 'translator') {
      translator = TranslatorModel.fromJson(receiverData);
    }

    return ChatModel(
      name: name.toString(),
      image: image,
      message: lastMessage != null && lastMessage['body'] != null
          ? lastMessage['body'].toString()
          : 'No message yet',
      seen: json['seen'] ?? false,
      date: lastMessage != null && lastMessage['createdAt'] != null
          ? lastMessage['createdAt'].toString()
          : '',
      isSender: lastMessage != null && lastMessage['isSender'] != null
          ? lastMessage['isSender']
          : false,
      senderId: senderIdString,
      receiverId: receiverIdString,
      company: company,
      translator: translator,
    );
  }

  ChatModel copyWith({
    String? name,
    String? image,
    String? message,
    bool? seen,
    String? date,
    bool? isSender,
    String? senderId,
    String? receiverId,
    CompanyModel? company,
    TranslatorModel? translator,
  }) {
    return ChatModel(
      name: name ?? this.name,
      image: image ?? this.image,
      message: message ?? this.message,
      seen: seen ?? this.seen,
      date: date ?? this.date,
      isSender: isSender ?? this.isSender,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      company: company ?? this.company,
      translator: translator ?? this.translator,
    );
  }

  factory ChatModel.localMessage(String messageText) {
    return ChatModel(
      name: 'You',
      image: '',
      message: messageText,
      seen: false,
      date: DateTime.now().toIso8601String(),
      isSender: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'message': message,
      'seen': seen,
      'date': date,
      'isSender': isSender,
      'senderId': senderId,
      'receiverId': receiverId,
      'company': company?.toJson(),
      'translator': translator?.toJson(),
    };
  }
}
