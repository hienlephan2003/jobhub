import 'package:flutter/foundation.dart';
import 'package:jobhub/models/response/jobs/get_job.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:jobhub/services/helpers/jobs_helper.dart';

class JobsNotifier extends ChangeNotifier {
  late Future<List<JobsResponse>> jobList;
  late Future<JobsResponse> jobRecent;
  late Future<GetJobRes> job;
  getJobs() {
    jobList = JobsHelper.getJobs();
  }

  getRecent() {
    jobRecent = JobsHelper.getRecent();
  }

  getJob(String id) {
    job = JobsHelper.getJob(id);
  }
}
