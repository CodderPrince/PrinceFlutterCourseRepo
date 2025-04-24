// Beginner Model;

// class UserModel{
//   late final String id;
//   late final String email;
//   late final String firstName;
//   late final String lastName;
//   late final String mobile;
//   late final String createDate;
//
//
//
//   void convertJsonToDart(Map<String, dynamic>jsonData ){
//     id=jsonData['_id'];
//     email = jsonData['email'];
//     firstName = jsonData['firstName'];
//     lastName = jsonData['lastName'];
//     mobile = jsonData['mobile'];
//     createDate = jsonData['createdDate'];
//   }
// }

// "data": {
// "_id": "672ddc84ea7d73dfecf4e384",
// "email": "email@gmail.com",
// "firstName": "abc",
// "lastName": "abc",
// "mobile": "01601942144",
// "createdDate": "2025-11-01T12:20:25.401Z"
// },

//
// intermediate model style

class UserModel {
  late final String id;
  late final String email;
  late final String firstName;
  late final String lastName;
  late final String mobile;
  late final String createDate;
  late final String photo;

  UserModel.convertJsonToDart(Map<String, dynamic> jsonData) {
    id = jsonData['_id'] ?? '';
    email = jsonData['email'] ?? '';
    firstName = jsonData['firstName'] ?? '';
    lastName = jsonData['lastName'] ?? '';
    mobile = jsonData['mobile'] ?? '';
    createDate = jsonData['createdDate'] ?? '';
    photo = jsonData['photo'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'createdDate': createDate,
      'photo': photo,
    };
  }
}

//professionalModel;

// class UserModel {
//   final String id;
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String mobile;
//   final String createdDate;
//
//   UserModel({
//     required this.id,
//     required this.email,
//     required this.firstName,
//     required this.lastName,
//     required this.mobile,
//     required this.createdDate,
//   });
//
//   factory UserModel.convertJsonToDart(Map<String, dynamic> jsonData) {
//     return UserModel(
//       id: jsonData['_id'] ?? '',
//       email: jsonData['_id'] ?? '',
//       firstName: jsonData['_id'] ?? '',
//       lastName: jsonData['_id'] ?? '',
//       mobile: jsonData['_id'] ?? '',
//       createdDate: jsonData['_id'] ?? '',
//     );
//   }
// }
