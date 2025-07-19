import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/common/model/product_model.dart';
import 'package:get/get.dart';

class SingleCategoryProductListController extends GetxController {
  final int _count = 30;
  int _currentPage = 0;
  int? _lastPage;

  bool _inProgress = false;
  bool _initialLoadingProgress = false;

  bool get inProgress => _inProgress;

  bool get initialLoadingProgress => _initialLoadingProgress;

  late String _message;

  String get message => _message;

  final List<ProductModel> _productList = [];

  List<ProductModel> get getProductList => _productList;

  Future<void> getProductsByCategory({required String categoryId}) async {
    _currentPage++;

    if (_lastPage != null && _lastPage! < _currentPage) {
      return;
    }
    if (_currentPage == 1) {
      _productList.clear();
      _initialLoadingProgress = true;
    } else {
      _inProgress = true;
    }
    update();

    final NetworkResponse response = await Get.find<NetworkClient>().getRequest(
      url: Urls.productListByCategoryUrl(
        count: _count,
        page: _currentPage,
        categoryId: categoryId,
      ),
    );

    if (response.isSuccess) {
      if (_currentPage == 1) {
        _lastPage = response.responseData!['data']['last_page'];
      }
      List<ProductModel> list = [];
      for (Map<String, dynamic> products
          in response.responseData!['data']['results']) {
        list.add(ProductModel.fromJson(products));
      }
      _productList.addAll(list);
      _message = response.responseData!['msg'];
    } else {
      _message = response.errorMessage!;
    }
    if (_currentPage == 1) {
      _initialLoadingProgress = false;
    } else {
      _inProgress = false;
    }
    update();
  }
}
