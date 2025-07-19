class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> jsonData) {
    return ProfileModel(
      id: jsonData['_id'] ?? '',
      firstName: jsonData['first_name'] ?? '',
      lastName: jsonData['last_name'] ?? '',
      email: jsonData['email'] ?? '',
      city: jsonData['city'] ?? '',
      phone: jsonData['phone'] ?? '',
    );
  }
}
