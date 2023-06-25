import 'dart:convert';

GetChats getChatsFromJson(String str) => GetChats.fromJson(json.decode(str));

String getChatsToJson(GetChats data) => json.encode(data.toJson());

class GetChats {
  final String chatId;
  final String content;
  final String reciever;

  GetChats({
    required this.chatId,
    required this.content,
    required this.reciever,
  });

  factory GetChats.fromJson(Map<String, dynamic> json) => GetChats(
        chatId: json["chatId"],
        content: json["content"],
        reciever: json["reciever"],
      );

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "content": content,
        "reciever": reciever,
      };
}
