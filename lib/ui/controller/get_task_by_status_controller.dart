import 'package:get/get.dart';

import '../../data/model/task_details_model.dart';
import '../../data/model/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class GetTaskByStatusController extends GetxController {
  bool _isLoading = false;

  get isLoading => _isLoading;
  String? _errorMessage;
  List<TaskDetailsModel> taskList = [];

  get errorMessage => _errorMessage;

  Future<bool> getTaskListByStatus({required String status}) async {
    bool _isSuccess = false;
    _isLoading = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.getTaskUrl(status),
    );
    if (response.statusCode == 200) {
      _isSuccess = true;
      TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
      taskList = taskListModel.taskList.cast<TaskDetailsModel>();
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
      taskList = [];
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }
}
