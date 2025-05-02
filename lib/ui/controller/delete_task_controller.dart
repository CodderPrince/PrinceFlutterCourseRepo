import 'package:get/get.dart';
import 'package:task_manager_task/ui/controller/get_task_by_status_controller.dart';
import 'package:task_manager_task/ui/controller/task_count_by_status_controller.dart';
import '../../app.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/pop_up_message.dart';

class DeleteTaskController extends GetxController {
  GetTaskByStatusController getTaskByStatusController =
      Get.find<GetTaskByStatusController>();
  TaskCountByStatusController taskCountByStatusController =
      Get.find<TaskCountByStatusController>();

  Future<void> deleteTask({
    required String id,
    required int index,
    required String taskTitle,
  }) async {
    String url = Urls.deleteTaskUrl(id);

    getTaskByStatusController.taskList.removeAt(index);
    getTaskByStatusController.update();

    NetworkResponse response = await NetworkClient.getRequest(url: url);
    await taskCountByStatusController.getAllTaskStatusCount();

    if (response.statusCode == 200) {
      showPopUp(TaskManager.navigatorKey.currentContext, '$taskTitle deleted');
    } else {
      showPopUp(
        TaskManager.navigatorKey.currentContext,
        'Something went wrong!',
      );
    }
  }
}
