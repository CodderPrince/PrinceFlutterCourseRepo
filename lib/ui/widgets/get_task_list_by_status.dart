import 'package:task_manager_task/data/model/task_details_model.dart';
import '../../data/model/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

Future<List<TaskDetailsModel>> getTaskListByStatus({
  required String status,
}) async {
  List<TaskDetailsModel> taskList = [];

  NetworkResponse response = await NetworkClient.getRequest(
    url: Urls.getTaskUrl(status),
  );
  if (response.statusCode == 200) {
    TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
    taskList = taskListModel.taskList;
  } else {
    taskList = [];
  }

  return taskList;
}
