class UserModel {
  final String id;
  final String first_name;
  final String last_name;
  final String? avatar_url;

  UserModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.avatar_url,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      id: jsonData['_id'] ?? '',
      first_name: jsonData['first_name'] ?? '',
      last_name: jsonData['last_name'] ?? '',
      avatar_url: jsonData['avatar_url'],
    );
  }
}
