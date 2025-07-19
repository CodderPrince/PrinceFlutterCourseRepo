import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/common/model/product_model.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController {
  bool _inProgress = false;

  bool get getInProgress => _inProgress;
  final List<ProductModel> _productList = [];

  List<ProductModel> get getPopularProductList => _productList;

  late String msg;

  Future<bool> getPopularProducts() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>().getRequest(
      url: Urls.popularProductListUrl,
    );
    if (response.isSuccess) {
      isSuccess = true;
      msg = response.responseData!['msg'];
      if (response.responseData!['results'] != null) {
        for (Map<String, dynamic> product
            in response.responseData!['results']) {
          _productList.add(ProductModel.fromJson(product));
        }
      }
    } else {
      msg = response.responseData!['msg'];
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
