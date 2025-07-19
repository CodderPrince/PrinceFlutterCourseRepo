import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/common/model/product_model.dart';
import 'package:get/get.dart';

class WishListScreenController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  late String _message;

  String get message => _message;

  final List<ProductModel> _productWishList = [];

  List<ProductModel> get getProductWishList => _productWishList;

  Future<void> getWishListProducts() async {
    _inProgress = true;
    update();

    final NetworkResponse response = await Get.find<NetworkClient>().getRequest(
      url: Urls.wishListUrls,
    );

    if (response.isSuccess) {
      for (Map<String, dynamic> products
          in response.responseData!['data']['results']) {
        _productWishList.add(ProductModel.fromJson(products['product']));
      }
      _message = response.responseData!['msg'];
    } else {
      _message = response.errorMessage!;
    }
    _inProgress = false;
    update();
  }
}
