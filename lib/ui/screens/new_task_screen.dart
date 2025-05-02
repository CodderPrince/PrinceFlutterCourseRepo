import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:task_manager_task/ui/controller/get_task_by_status_controller.dart';
import 'package:task_manager_task/ui/controller/task_count_by_status_controller.dart';
import 'package:task_manager_task/ui/widgets/pop_up_message.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    getTask();
    getAllTaskStatusCount();
    super.initState();
  }

  GetTaskByStatusController getTaskByStatusController =
      Get.find<GetTaskByStatusController>();

  TaskCountByStatusController taskCountByStatusController =
      Get.find<TaskCountByStatusController>();

  Future<void> _refreshTask() async {
    await getTask();
    await getAllTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddTask,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.add),
      ),
      body: GetBuilder<GetTaskByStatusController>(
        builder: (controller) {
          return getTaskByStatusController.isLoading
              ? Center(child: const CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _refreshTask,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      GetBuilder<TaskCountByStatusController>(
                        builder: (controller) {
                          return buildSummarySection();
                        },
                      ),

                      getTaskByStatusController.taskList.isEmpty
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                              ),
                              Center(child: Text('Empty')),
                            ],
                          )
                          : ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemCount:
                                getTaskByStatusController.taskList.length,
                            separatorBuilder:
                                (context, index) => SizedBox(height: 10),
                            itemBuilder: (BuildContext context, int index) {
                              var task =
                                  getTaskByStatusController.taskList[index];
                              String dateTime = task.createdDate;
                              String dateOnly = dateTime.split('T')[0];
                              return TaskCard(
                                index: index,
                                id: task.id,
                                status: 'New',
                                taskTitle: task.title,
                                taskDescription: task.description,
                                date: dateOnly,
                              );
                            },
                          ),
                    ],
                  ),
                ),
              );
        },
      ),
    );
  }

  Widget buildSummarySection() {
    return SizedBox(
      height: 100,
      child: Builder(
        builder: (context) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: taskCountByStatusController.taskStatusCountList.length,
            itemBuilder: (context, index) {
              return SummaryCard(
                title:
                    taskCountByStatusController
                        .taskStatusCountList[index]
                        .status,
                count:
                    taskCountByStatusController
                        .taskStatusCountList[index]
                        .count,
              );
            },
          );
        },
      ),
    );
  }

  _onTapAddTask() {
    Navigator.pushNamed(
      context,
      '/AddNewTaskScreen',
      arguments: () {
        getAllTaskStatusCount();
        getTask();
        setState(() {});
      },
    );
  }

  Future<void> getAllTaskStatusCount() async {
    try {
      await taskCountByStatusController.getAllTaskStatusCount();
    } catch (e) {
      showPopUp(context, 'Something went wrong!', true);
    }
  }

  Future getTask() async {
    try {
      await getTaskByStatusController.getTaskListByStatus(status: 'New');
    } catch (e) {
      Logger().i('Failed to get Task from controller!');
    }
  }
}
