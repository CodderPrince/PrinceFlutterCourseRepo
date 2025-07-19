import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/reviews/model/review_model.dart';
import 'package:get/get.dart';

class ReviewScreenController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  String _msg = '';

  String get message => _msg;

  final List<ReviewModel> _reviewList = [];

  List<ReviewModel> get reviewList => _reviewList;

  Future<bool> getReviews({required String productId}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>().getRequest(
      url: Urls.reviewUrl(id: productId),
    );
    if (response.isSuccess && response.responseData != null) {
      isSuccess = true;
      for (Map<String, dynamic> reviews
          in response.responseData!['data']['results']) {
        _reviewList.add(ReviewModel.fromJson(reviews));
      }
    } else {
      _msg = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
