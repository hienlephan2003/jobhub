import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:jobhub/models/request/chats/create_chat.dart';
import 'package:jobhub/models/response/chats/initial_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/response/chats/get_chat.dart';
import '../config.dart';

class ChatHelper {
  static var client = https.Client();
  static Future<List<dynamic>> apply(CreateChat model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {
      'Content-Type': "application/json",
      'token': "Bearer $token"
    };
    var url = Uri.https(Config.apiUrl, Config.profileUrl);
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model));
    if (response.statusCode == 200) {
      var first = initialChatFromJson(response.body);
      return [true, first];
    } else {
      return [false];
    }
  }

  //Get all conversation of user
  static Future<List<GetChats>> getConversations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {
      'Content-Type': "application/json",
      'token': "Bearer $token"
    };
    var url = Uri.https(Config.apiUrl, Config.chatUrl);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var chats = getChatsFromJson(response.body);
      return chats;
    } else {
      throw Exception("Couldn't get chats");
    }
  }
}
