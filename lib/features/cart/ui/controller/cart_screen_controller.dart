import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/cart/data/model/cart_model.dart';
import 'package:get/get.dart';

class CartScreenController extends GetxController {
  bool _inProgress = false;

  bool get getInProgress => _inProgress;

  late String _msg;

  String get getMessage => _msg;

  final List<CartModel> _list = [];

  List<CartModel> get getCartList => _list;

  Future<bool> getCartData() async {
    _list.clear();
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await Get.find<NetworkClient>().getRequest(
      url: Urls.cartListUrls,
    );
    if (response.isSuccess) {
      isSuccess = true;
      _msg = response.responseData!['msg'];
      if (response.responseData!['data']['results'] != null) {
        for (Map<String, dynamic> product
            in response.responseData!['data']['results']) {
          _list.add(CartModel.fromJson(product));
        }
      }
    } else {
      _msg = response.errorMessage!;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }

  Future<String> deleteCartItem({required String id}) async {
    String msg = '';
    final NetworkResponse response = await Get.find<NetworkClient>()
        .deleteRequest(Urls.deleteCartItemUrl(id: id));
    if (response.responseData != null) {
      msg = response.responseData!['msg'];
    }
    return msg;
  }

  int get totalPrice {
    int total = 0;
    for (CartModel cartModel in _list) {
      total += (cartModel.productsModel.current_price * cartModel.quantity);
    }
    return total;
  }
}
