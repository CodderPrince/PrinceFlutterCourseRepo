import 'package:craft_bay/features/common/model/category_model.dart';
import 'package:craft_bay/features/common/ui/widget/popular_item.dart';
import 'package:craft_bay/features/product/controller/single_category_product_list_controller.dart';
import 'package:craft_bay/features/product/ui/screen/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleCategoryProductListScreen extends StatefulWidget {
  const SingleCategoryProductListScreen({super.key, required this.args});

  static final String name = 'single-category-products';
  final CategoryModel args;

  @override
  State<SingleCategoryProductListScreen> createState() =>
      _SingleCategoryProductListScreenState();
}

class _SingleCategoryProductListScreenState
    extends State<SingleCategoryProductListScreen> {
  final SingleCategoryProductListController _productListController =
      SingleCategoryProductListController();

  final ScrollController _scrollController = ScrollController();

  void _moveToProductDetailScreen({required String productId}) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.name,
      arguments: productId,
    );
  }

  void _loadMoreData() {
    if (_scrollController.position.extentAfter < 300) {
      _productListController.getProductsByCategory(categoryId: widget.args.id);
    }
  }

  @override
  void initState() {
    _productListController.getProductsByCategory(categoryId: widget.args.id);
    _scrollController.addListener(_loadMoreData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.args.title;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        title: Text(title),
      ),
      body: SafeArea(
        child: GetBuilder(
          init: _productListController,
          builder: (context) {
            if (_productListController.initialLoadingProgress) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 0,
                    ),
                    child: GridView.builder(
                      itemCount: _productListController.getProductList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        //childAspectRatio: 4/5
                      ),
                      itemBuilder: (context, index) {
                        return FittedBox(
                          child: InkWell(
                            onTap: () {
                              _moveToProductDetailScreen(
                                productId:
                                    _productListController
                                        .getProductList[index]
                                        .id,
                              );
                            },
                            child: PopularItem(
                              productModel:
                                  _productListController.getProductList[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _productListController.inProgress,
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
