import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:get/get.dart';

class ProductAddToCartController extends GetxController {
  bool _inProgress = false;

  bool get getInProgress => _inProgress;

  late String _msg;

  String get getMessage => _msg;

  Future<bool> addToCartRequest({required String productId}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> body = {"product": productId};
    final NetworkResponse response = await Get.find<NetworkClient>()
        .postRequest(url: Urls.addToCartUrls, body: body);

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
