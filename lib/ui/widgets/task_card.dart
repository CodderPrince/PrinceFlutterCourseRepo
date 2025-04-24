import 'package:flutter/material.dart';
import 'package:task_manager_task/app.dart';
import 'package:task_manager_task/data/service/network_client.dart';
import 'package:task_manager_task/data/utils/urls.dart';
import 'package:task_manager_task/ui/widgets/pop_up_message.dart';

enum TaskStatusControl { sNew, progress, canceled, completed }

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.status,
    this.taskTitle,
    this.taskDescription,
    this.date,
    required this.id,
    this.onDelete,
  });

  final TaskStatusControl status;
  final String? taskTitle;
  final String? taskDescription;
  final String? date;
  final String id;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskTitle ?? "Title will be here",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(taskDescription ?? "Description will be here"),
            Text(date ?? "Date will be here"),
            Row(
              children: [
                Chip(
                  label: Text(
                    '${_getCheapStatus()}',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _statusColorBuilder(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  side: BorderSide.none,
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                IconButton(
                  onPressed: () => onTapDelete(id),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onTapDelete(id) {
    deleteTask(id);
  }

  Future<void> deleteTask(id) async {
    String url = Urls.deleteTaskUrl(id);
    NetworkResponse response = await NetworkClient.getRequest(url: url);
    if (response.statusCode == 200) {
      if (onDelete != null) {
        onDelete!();
      }

      showPopUp(TaskManager.navigatorKey.currentContext, '$taskTitle deleted');
    } else {
      showPopUp(
        TaskManager.navigatorKey.currentContext,
        'Something went wrong',
      );
    }
  }

  _statusColorBuilder() {
    if (status == TaskStatusControl.sNew) {
      return Colors.blue;
    } else if (status == TaskStatusControl.progress) {
      return Colors.purple;
    } else if (status == TaskStatusControl.canceled) {
      return Colors.redAccent;
    } else if (status == TaskStatusControl.completed) {
      return Colors.green;
    }
  }

  _getCheapStatus() {
    if (status == TaskStatusControl.sNew) {
      return "New";
    } else if (status == TaskStatusControl.progress) {
      return "Progress";
    } else if (status == TaskStatusControl.canceled) {
      return "Canceled";
    } else if (status == TaskStatusControl.completed) {
      return "Completed";
    }
  }
}
