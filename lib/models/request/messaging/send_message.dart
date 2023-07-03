import 'dart:convert';

SendMessage sendMessageFromJson(String str) =>
    SendMessage.fromJson(json.decode(str));

String sendMessageToJson(SendMessage data) => json.encode(data.toJson());

class SendMessage {
  final String chatId;
  final String content;
  final String reciever;

  SendMessage({
    required this.chatId,
    required this.content,
    required this.reciever,
  });

  factory SendMessage.fromJson(Map<String, dynamic> json) => SendMessage(
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
