import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:get/get.dart';

class AddToWishListController extends GetxController {
  bool _inProgress = false;

  bool get getInProgress => _inProgress;

  late String _msg;

  String get getMessage => _msg;

  Future<bool> addToWishList({required String productId}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> body = {"product": productId};
    final NetworkResponse response = await Get.find<NetworkClient>()
        .postRequest(url: Urls.addToWishListUrls, body: body);

    if (response.isSuccess) {
      _msg = response.responseData!['msg'];
      isSuccess = true;
    } else {
      _msg = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
