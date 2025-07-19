import 'package:craft_bay/features/common/model/user_model.dart';

class ReviewModel {
  final String id;
  final int rating;
  final String comment;
  final UserModel userModel;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.userModel,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> jsonData) {
    return ReviewModel(
      id: jsonData['_id'] ?? '',
      rating: jsonData['rating'] ?? 0,
      comment: jsonData['comment'] ?? '',
      userModel: UserModel.fromJson(jsonData['user']),
    );
  }
}
