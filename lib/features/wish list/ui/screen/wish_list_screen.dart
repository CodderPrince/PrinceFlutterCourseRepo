import 'package:craft_bay/features/common/controller/main_bottom_nav_controller.dart';
import 'package:craft_bay/features/common/ui/widget/popular_item.dart';
import 'package:craft_bay/features/product/ui/screen/product_detail_screen.dart';
import 'package:craft_bay/features/wish%20list/controller/wishlist_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  void _moveToProductDetailScreen(String productId) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.name,
      arguments: productId,
    );
  }

  @override
  void initState() {
    super.initState();
    Get.find<WishListScreenController>().getWishListProducts();
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
          leading: IconButton(
            onPressed: () {
              Get.find<MainBottomNavController>().backToHome();
            },
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),
          title: Text('Wish List'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GetBuilder<WishListScreenController>(
              builder: (controller) {
                if (controller.getProductWishList.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Visibility(
                  visible: controller.inProgress == false,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: GridView.builder(
                    itemCount: controller.getProductWishList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      return FittedBox(
                        child: InkWell(
                          onTap: () {
                            _moveToProductDetailScreen(
                              controller.getProductWishList[index].id,
                            );
                          },
                          child: PopularItem(
                            productModel: controller.getProductWishList[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
