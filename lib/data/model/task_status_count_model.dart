class TaskStatusCountModel {
  final String status;
  final String count;

  TaskStatusCountModel({required this.status, required this.count});

  factory TaskStatusCountModel.convertJsonToDart(
    Map<String, dynamic> jsonData,
  ) {
    return TaskStatusCountModel(
      status: jsonData['_id'],
      count: jsonData['sum'].toString(),
    );
  }
}
