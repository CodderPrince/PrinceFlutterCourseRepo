import 'package:get/get.dart';

class ProductQuantityController extends GetxController {
  int _quantity = 1;

  int get getQuantity => _quantity;

  void incrementQuantity() {
    if (_quantity < 20) {
      _quantity++;
    }
    update();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
    }
    update();
  }
}
