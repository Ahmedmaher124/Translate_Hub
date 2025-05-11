import 'sender_id.dart';

class Message {
  SenderId? senderId;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? body;

  /// خاصية محلية لتحديد إن كانت الرسالة مرسلة من المستخدم الحالي
  bool? isSender;

  Message({
    this.senderId,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.body,
    this.isSender,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        senderId: json['senderId'] == null
            ? null
            : SenderId.fromJson(json['senderId'] as Map<String, dynamic>),
        id: json['_id'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        body: json['body'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'senderId': senderId?.toJson(),
        '_id': id,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'body': body,
      };

  /// نسخة من الرسالة مع خصائص معدلة (مفيد لتعديل isSender)
  Message copyWith({
    SenderId? senderId,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? body,
    bool? isSender,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      body: body ?? this.body,
      isSender: isSender ?? this.isSender,
    );
  }
}
