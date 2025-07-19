import 'package:craft_bay/features/cart/data/model/cart_product_model.dart';

class CartModel {
  final String id;
  final String? color;
  final String? size;
  final int quantity;
  final CartProductsModel productsModel;

  CartModel({
    required this.id,
    required this.color,
    required this.size,
    required this.quantity,
    required this.productsModel,
  });

  factory CartModel.fromJson(Map<String, dynamic> jsonData) {
    return CartModel(
      id: jsonData['_id']?.toString() ?? '',
      color: jsonData['color'],
      size: jsonData['size'],
      quantity: jsonData['quantity'] ?? 0,
      productsModel: CartProductsModel.fromJson(jsonData['product']),
    );
  }
}
