import 'dart:convert';

import '../model/productModel.dart';
import '../utils/urls.dart';
import 'package:http/http.dart' as http;

class ProductController {
  List<Data> products = [];

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(Urls.readProduct));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Product productModel = Product.fromJson(data);
      products = productModel.data ?? [];
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<void> createProduct(
      String name, String image, int qty, int unitPrice, int totalPrice) async {
    final response = await http.post(Uri.parse(Urls.createProduct),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ProductName': name,
          'ProductCode': DateTime.now().millisecondsSinceEpoch,
          'Img': image,
          'Qty': qty,
          'UnitPrice': unitPrice,
          'TotalPrice': totalPrice,
        }));

    if (response.statusCode == 201) {
      fetchProducts();
    }
  }

  Future<void> updateProduct(String id, String name, String image, int qty,
      int unitPrice, int totalPrice) async {
    final response = await http.post(Uri.parse(Urls.updateProduct(id)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ProductName': name,
          'ProductCode': DateTime.now().millisecondsSinceEpoch,
          'Img': image,
          'Qty': qty,
          'UnitPrice': unitPrice,
          'TotalPrice': totalPrice,
        }));

    if (response.statusCode == 201) {
      fetchProducts();
    }
  }

  Future<bool> deleteProduct(String id) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(id)));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
