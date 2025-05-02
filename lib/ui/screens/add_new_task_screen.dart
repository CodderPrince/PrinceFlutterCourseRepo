import 'package:flutter/material.dart';
import 'package:task_manager_task/ui/controller/add_new_task_controller.dart';
import '../widgets/screen_background.dart';
import 'package:get/get.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  AddNewTaskController addNewTaskController = Get.find<AddNewTaskController>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Text(
                    'Add new task',
                    style: TextTheme.of(context).headlineMedium,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                    validator: (value) {
                      if (value!.trim().isEmpty == true) {
                        return "Title Can't be empty!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _detailsController,
                    maxLines: 8,
                    validator: (value) {
                      if (value!.trim().isEmpty == true) {
                        return "Description Can't be empty!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Details',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _onTaskSubmit,
                    child: GetBuilder<AddNewTaskController>(
                      builder: (controller) {
                        return Visibility(
                          visible: addNewTaskController.isLoading == false,
                          replacement: Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: Icon(Icons.arrow_circle_right_outlined),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTaskSubmit() {
    if (_formKey.currentState!.validate() == true) {
      createTask();
    }
    return;
  }

  Future<void> createTask() async {
    Map<String, dynamic> requestBody = {
      "title": _titleController.text.trim(),
      "description": _detailsController.text.trim(),
      "status": "New",
    };
    _titleController.clear();
    _detailsController.clear();
    await addNewTaskController.createTask(requestBody: requestBody);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
