import 'package:task_manager_task/data/model/task_status_count_model.dart';

class TaskStatusCountListModel {
  late final String status;
  late final List<TaskStatusCountModel> statusCountList;

  TaskStatusCountListModel.fromJson(Map<String, dynamic> jsonData) {
    status = jsonData['status'];
    if (jsonData['data'] != null) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> data in jsonData['data']) {
        list.add(TaskStatusCountModel.convertJsonToDart(data));
      }
      statusCountList = list;
    } else {
      statusCountList = [];
    }
  }
}
