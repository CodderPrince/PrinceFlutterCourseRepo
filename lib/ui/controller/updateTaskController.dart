import 'package:get/get.dart';
import 'package:task_manager_task/ui/controller/get_task_by_status_controller.dart';
import 'package:task_manager_task/ui/controller/task_count_by_status_controller.dart';

import '../../app.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/pop_up_message.dart';

class UpdateTaskController extends GetxController {
  GetTaskByStatusController getTaskByStatusController =
      Get.find<GetTaskByStatusController>();
  TaskCountByStatusController taskCountByStatusController =
      Get.find<TaskCountByStatusController>();

  Future<void> updateTaskStatus({id, status, currentStatus}) async {
    String url = Urls.updateTaskStatusUrl(taskId: id, status: status);
    NetworkResponse response = await NetworkClient.getRequest(url: url);
    if (response.statusCode == 200) {
      getTaskByStatusController.getTaskListByStatus(status: currentStatus);
      taskCountByStatusController.getAllTaskStatusCount();
      update();
      showPopUp(
        TaskManager.navigatorKey.currentContext,
        'Update Successfully!',
      );
    } else {
      showPopUp(TaskManager.navigatorKey.currentContext, 'Update failed!');
    }
  }
}
