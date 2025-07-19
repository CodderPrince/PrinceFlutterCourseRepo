import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:get/get.dart';

class CreateReviewScreenController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  String _msg = '';

  String get message => _msg;

  Future<bool> createReview(Map<String, dynamic> body) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>()
        .postRequest(url: Urls.createView, body: body);
    if (response.isSuccess) {
      isSuccess = true;
      _msg = response.responseData!['msg'];
    } else {
      _msg = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
