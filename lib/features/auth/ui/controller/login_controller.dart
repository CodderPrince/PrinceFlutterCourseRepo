import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/common/controller/auth_controller.dart';
import 'package:craft_bay/features/common/model/user_model.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  bool _inProgress = false;

  bool get getInProgress => _inProgress;
  late String _message;

  String get getMessage => _message;

  Future<bool> logIn({required String email, required String password}) async {
    Map<String, dynamic> body = {"email": email, "password": password};
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>()
        .postRequest(url: Urls.logInUrl, body: body);
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
}
