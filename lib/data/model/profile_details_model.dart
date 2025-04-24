class UpdateProfileModel {
  late final String status;
  late final Data data;

  UpdateProfileModel.fromJson(Map<String, dynamic> jsonData) {
    status = jsonData['status'] ?? '';
    data = Data.fromJson(jsonData['data'][0] ?? {});
  }
}

class Data {
  late final String id;
  late final String email;
  late final String firstName;
  late final String lastName;
  late final String mobile;
  late final String password;
  late final String createdDate;
  late final String photo;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    email = json['email'] ?? '';
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    mobile = json['mobile'] ?? '';
    password = json['password'] ?? '';
    createdDate = json['createdDate'] ?? '';
    photo = json['photo'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobile'] = mobile;
    data['password'] = password;
    data['createdDate'] = createdDate;
    data['photo'] = photo;
    return data;
  }
}
