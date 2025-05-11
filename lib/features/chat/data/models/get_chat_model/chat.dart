import 'message.dart';
import 'sender_id.dart';

class Chat {
  String? iD;
  SenderId? senderId;
  dynamic receiverId;
  String? receiverModel;
  List<Message>? messages;
  String? mediaCloudFolder;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? id;

  Chat({
    this.iD,
    this.senderId,
    this.receiverId,
    this.receiverModel,
    this.messages,
    this.mediaCloudFolder,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.id,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        iD: json['_id'] as String?,
        senderId: json['senderId'] == null
            ? null
            : SenderId.fromJson(json['senderId'] as Map<String, dynamic>),
        receiverId: json['receiverId'] as dynamic,
        receiverModel: json['receiverModel'] as String?,
        messages: (json['messages'] as List<dynamic>?)
            ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
            .toList(),
        mediaCloudFolder: json['mediaCloudFolder'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': iD,
        'senderId': senderId?.toJson(),
        'receiverId': receiverId,
        'receiverModel': receiverModel,
        'messages': messages?.map((e) => e.toJson()).toList(),
        'mediaCloudFolder': mediaCloudFolder,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'id': id,
      };
}
