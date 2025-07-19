import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/product/data/model/product_details_model.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  bool _inProgress = false;

  bool get getInProgress => _inProgress;

  late String msg;
  late ProductDetailsModel _productDetailsModel;

  ProductDetailsModel get productDetailModel => _productDetailsModel;

  Future<bool> getProductDetails({required String productId}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>().getRequest(
      url: Urls.productDetailsUrls(id: productId),
    );
    if (response.isSuccess) {
      msg = response.responseData!['msg'];
      isSuccess = true;
      _productDetailsModel = ProductDetailsModel.fromJson(
        response.responseData!['data'],
      );
    } else {
      msg = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
