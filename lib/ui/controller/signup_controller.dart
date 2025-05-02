import 'package:get/get.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class SignupController extends GetxController {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> signup({Map<String, dynamic>? requestBody}) async {
    _isLoading = false;
    update();
    bool _isSuccess = false;

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.registerUrl,
      body: requestBody,
    );
    if (response.statusCode == 200) {
      bool _isSuccess = true;
      Get.snackbar('Congratulation!', 'Registration Successfully!');
    } else {
      Get.snackbar('Sorry!', '${response.errorMessage}');
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }
}
