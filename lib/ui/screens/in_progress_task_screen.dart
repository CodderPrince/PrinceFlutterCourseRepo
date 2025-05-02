import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:task_manager_task/ui/controller/get_task_by_status_controller.dart';
import '../widgets/task_card.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool isLoading = false;

  GetTaskByStatusController getTaskByStatusController =
      Get.find<GetTaskByStatusController>();

  @override
  void initState() {
    super.initState();
    getTask();
  }

  Future<void> _onRefresh() async {
    await getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GetTaskByStatusController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child:
                getTaskByStatusController.isLoading
                    ? ListView(
                      children: const [
                        SizedBox(height: 300),
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                    : getTaskByStatusController.taskList.isEmpty
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                        const Center(child: Text("Empty")),
                      ],
                    )
                    : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: getTaskByStatusController.taskList.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int index) {
                        var task = getTaskByStatusController.taskList[index];
                        String dateOnly = task.createdDate.split('T')[0];
                        return TaskCard(
                          index: index,
                          id: task.id,
                          status: 'Progress',
                          taskTitle: task.title,
                          taskDescription: task.description,
                          date: dateOnly,
                        );
                      },
                    ),
          );
        },
      ),
    );
  }

  Future<void> getTask() async {
    try {
      await getTaskByStatusController.getTaskListByStatus(status: 'Progress');
    } catch (e) {
      Logger().i(e);
    }
  }
}
