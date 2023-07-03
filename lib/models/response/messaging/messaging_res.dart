import 'dart:convert';

List<MessageRes> messageResFromJson(String str) =>
    List<MessageRes>.from(json.decode(str).map((x) => MessageRes.fromJson(x)));

class MessageRes {
  final Sender sender;
  final Chat chat;
  final String content;
  final List<dynamic> readBy;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageRes({
    required this.sender,
    required this.chat,
    required this.content,
    required this.readBy,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageRes.fromJson(Map<String, dynamic> json) => MessageRes(
        sender: Sender.fromJson(json["sender"]),
        chat: Chat.fromJson(json["chat"]),
        content: json["content"],
        readBy: List<dynamic>.from(json["readBy"].map((x) => x)),
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}

class Chat {
  final String id;

  Chat({
    required this.id,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
      };
}

class Sender {
  final String id;
  final String username;
  final String email;
  final String profile;

  Sender({
    required this.id,
    required this.username,
    required this.email,
    required this.profile,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        profile: json["profile"],
      );
}
