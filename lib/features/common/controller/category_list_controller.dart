import 'package:craft_bay/app/urls.dart';
import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/common/model/category_model.dart';
import 'package:get/get.dart';

class CategoryListController extends GetxController {
  final int _count = 30;
  int _currentPage = 0;
  int? _lastPage;

  bool _inProgress = false;
  bool _initialLoadingProgress = false;

  bool get inProgress => _inProgress;

  bool get initialLoadingProgress => _initialLoadingProgress;

  late String _message;

  String get message => _message;

  final List<CategoryModel> _productCategoryList = [];

  List<CategoryModel> get getProductCategoryList => _productCategoryList;

  int get homeCategoryListItemLength =>
      _productCategoryList.length > 10 ? 10 : _productCategoryList.length;

  Future<void> getProducts() async {
    _currentPage++;

    if (_lastPage != null && _lastPage! < _currentPage) {
      return;
    }
    if (_currentPage == 1) {
      _productCategoryList.clear();
      _initialLoadingProgress = true;
    } else {
      _inProgress = true;
    }
    update();

    final NetworkResponse response = await Get.find<NetworkClient>().getRequest(
      url: Urls.categoryUrl(count: _count, page: _currentPage),
    );

    if (response.isSuccess) {
      if (_currentPage == 1) {
        _lastPage = response.responseData!['data']['last_page'];
      }
      List<CategoryModel> list = [];
      for (Map<String, dynamic> categories
          in response.responseData!['data']['results']) {
        list.add(CategoryModel.fromJson(categories));
      }
      _productCategoryList.addAll(list);
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
