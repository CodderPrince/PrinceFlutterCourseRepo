import 'package:get/get.dart';
import '../../data/model/login_model.dart';
import '../../data/model/user_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  bool _isLoading = false;

  get isLoading => _isLoading;
  String? _errorMessage;

  get errorMessage => _errorMessage;

  Future<bool> logIn({required String email, required String password}) async {
    bool isSuccess = false;

    _isLoading = true;
    update();

    Map<String, dynamic> body = {"email": email, "password": password};
    final NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.logInrUrl,
      body: body,
    );
    if (response.statusCode == 200) {
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      await AuthController.saveUserInformation(
        loginModel.token,
        loginModel.userModel as UserModel,
      );
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _isLoading = false;
    update();

    return isSuccess;
  }
}
