import 'package:http/http.dart' as https;
import 'package:jobhub/models/bookmark_res.dart';
import 'package:jobhub/models/request/bookmarks/bookmarks_model.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class BookMarkHelper {
  static var client = https.Client();
  // static Future<JobsResponse> getProfile() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   Map<String, String> requestHeaders = {
  //     'Content-Type': "application/json",
  //     'token': "Bearer $token"
  //   };
  //   var url = Uri.https(Config.apiUrl, Config.bookmarkUrl);
  //   var response = await client.get(url, headers: requestHeaders);
  //   if (response.statusCode == 200) {
  //     BookmarkResModel res = bookmarkResModelFromJson(response.body);
  //     return res;
  //   } else {
  //     throw Exception("Fail to get the profile");
  //   }
  // }
}
