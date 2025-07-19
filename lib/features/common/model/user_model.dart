class UserModel {
  final String email;
  final String id;
  final String firstName;
  final String lastName;
  final String city;
  final String phone;
  final String avatarUrl;

  UserModel({
    required this.email,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.phone,
    required this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      id: jsonData['_id'].toString(),
      firstName: jsonData['first_name'].toString() ?? '',
      lastName: jsonData['last_name'].toString() ?? '',
      email: jsonData['email'] ?? '',
      phone: jsonData['phone'].toString() ?? '',
      city: jsonData['city'] ?? '',
      avatarUrl: jsonData['avatar_url'].toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
