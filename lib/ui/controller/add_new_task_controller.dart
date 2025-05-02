import 'package:get/get.dart';
import 'package:task_manager_task/ui/controller/task_count_by_status_controller.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import 'get_task_by_status_controller.dart';

class AddNewTaskController extends GetxController {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> createTask({required Map<String, dynamic> requestBody}) async {
    _isLoading = true;
    update();
    String url = Urls.createTaskUrl;
    NetworkResponse response = await NetworkClient.postRequest(
      url: url,
      body: requestBody,
    );
    if (response.statusCode == 200) {
      Get.snackbar('Successfully!', 'TaskAdded');
      await Get.find<GetTaskByStatusController>().getTaskListByStatus(
        status: 'New',
      );
      await Get.find<TaskCountByStatusController>().getAllTaskStatusCount();
      update();
    } else {
      if (response.errorMessage == null) {
        Get.snackbar('Fail!', 'Something went wrong!');
      } else {
        Get.snackbar('Fail!', '${response.errorMessage}');
      }
    }
    _isLoading = false;
    update();
  }
}
