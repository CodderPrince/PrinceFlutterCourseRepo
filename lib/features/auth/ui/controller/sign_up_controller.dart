import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/auth/data/model/sign_up_request_model.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  late String _message;

  String get message => _message;

  Future<bool> signUp(SignUpRequestModel model) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>()
        .postRequest(url: Urls.signUpUrl, body: model.toJson());
    if (response.isSuccess) {
      _message = response.responseData!['msg'];
      isSuccess = true;
    } else {
      _message = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
