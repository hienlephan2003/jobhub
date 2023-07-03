import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:jobhub/models/request/messaging/send_message.dart';
import 'package:jobhub/models/response/messaging/messaging_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class MessagingHelper {
  static var client = https.Client();

  static Future<List<dynamic>> sendMessage(SendMessage model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {
      'Content-Type': "application/json",
      'token': "Bearer $token"
    };
    var url = Uri.https(Config.apiUrl, Config.messageUrl);
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model));
    if (response.statusCode == 200) {
      var first = MessageRes.fromJson(json.decode(response.body));
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      return [true, first, responseMap];
    } else {
      return [false];
    }
  }

  static Future<List<MessageRes>> recieveMessage(
      String chatId, int offset) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {
      'Content-Type': "application/json",
      'token': "Bearer $token"
    };
    var url = Uri.https(Config.apiUrl, "${Config.messageUrl}/$chatId",
        {"page": offset.toString()});
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var messages = messageResFromJson(response.body);
      return messages;
    } else {
      throw Exception("Couldn't get messages");
    }
  }
}
