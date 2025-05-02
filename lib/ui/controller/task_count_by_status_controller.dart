import 'package:get/get.dart';

import '../../data/model/task_status_count_list_model.dart';
import '../../data/model/task_status_count_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class TaskCountByStatusController extends GetxController {
  List<TaskStatusCountModel> _taskStatusCountList = [];

  get taskStatusCountList => _taskStatusCountList;
  bool _isLoading = false;

  get isLoading => _isLoading;

  Future<void> getAllTaskStatusCount() async {
    _isLoading = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusCountUrl,
    );
    if (response.statusCode == 200) {
      TaskStatusCountListModel taskStatusListModel =
          TaskStatusCountListModel.fromJson(response.data ?? {});
      _taskStatusCountList =
          taskStatusListModel.statusCountList.cast<TaskStatusCountModel>();
    } else {
      _taskStatusCountList = [];
    }
    _isLoading = false;
    update();
  }
}
