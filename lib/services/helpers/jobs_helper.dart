import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/response/jobs/get_job.dart';
import '../../models/response/jobs/jobs_response.dart';
import '../config.dart';

class JobsHelper {
  static var client = https.Client();
  static Future<List<JobsResponse>> getJobs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {
      'Content-Type': "application/json",
      'token': "Bearer $token"
    };
    var url = Uri.https(Config.apiUrl, Config.jobs);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      List<JobsResponse> res = jobsResponseFromJson(response.body);
      return res;
    } else {
      throw Exception("Fail to get the job");
    }
  }

  static Future<JobsResponse> getRecent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {
      'Content-Type': "application/json",
      'token': "Bearer $token"
    };
    var url = Uri.https(Config.apiUrl, Config.jobs);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      List<JobsResponse> res = jobsResponseFromJson(response.body);
      return res.first;
    } else {
      throw Exception("Fail to get the job");
    }
  }

  static Future<GetJobRes> getJob(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> requestHeaders = {
      'Content-Type': "application/json",
      'token': "Bearer $token"
    };
    var url = Uri.https(Config.apiUrl, "${Config.jobs}/$jobId");
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      GetJobRes res = getJobResFromJson(response.body);
      return res;
    } else {
      throw Exception("Fail to get the job");
    }
  }
}
