import 'package:craft_bay/features/common/controller/category_list_controller.dart';
import 'package:craft_bay/features/common/controller/main_bottom_nav_controller.dart';
import 'package:craft_bay/features/common/ui/widget/product_category_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({super.key});

  static final String name = '/product-category';

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreData);
  }

  void _loadMoreData() {
    if (_scrollController.position.extentAfter < 300) {
      Get.find<CategoryListController>().getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<MainBottomNavController>().backToHome();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Category'),
          leading: IconButton(
            onPressed: Get.find<MainBottomNavController>().backToHome,
            icon: Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: GetBuilder<CategoryListController>(
                    builder: (controller) {
                      return Visibility(
                        visible: !controller.initialLoadingProgress,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: GridView.builder(
                          controller: _scrollController,
                          itemCount: controller.getProductCategoryList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 5,
                              ),
                          itemBuilder: (context, index) {
                            return FittedBox(
                              child: ProductCategoryItem(
                                categoryModel:
                                    controller.getProductCategoryList[index],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                GetBuilder<CategoryListController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress,
                      replacement: const SizedBox.shrink(),
                      child: Center(child: const CircularProgressIndicator()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
