import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/auth/data/model/verification_request_model.dart';
import 'package:craft_bay/features/common/controller/auth_controller.dart';
import 'package:craft_bay/features/common/model/user_model.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  bool _inProgress = false;
  late String _message;

  bool get inProgress => _inProgress;

  String get message => _message;

  Future<bool> verifyOTP(VerificationRequestModel model) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>()
        .postRequest(url: Urls.verifyOtpUrl, body: model.toJson());
    if (response.isSuccess) {
      _message = response.responseData!['msg'];
      Get.find<AuthController>().saveUserData(
        token: response.responseData!['data']['token'],
        model: UserModel.fromJson(response.responseData!['data']['user']),
      );
      isSuccess = true;
    } else {
      _message = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }

  Future<bool> resendOTP({required String email}) async {
    Map<String, dynamic> body = {"email": email};
    bool isSuccess = false;
    final NetworkResponse response = await Get.find<NetworkClient>()
        .postRequest(url: Urls.resendOtpUrl, body: body);
    if (response.isSuccess) {
      _message = response.responseData!['msg'];
      isSuccess = true;
    } else {
      _message = response.errorMessage!;
    }
    update();
    return isSuccess;
  }
}
