import 'package:craft_bay/features/auth/ui/screens/login_screen.dart';
import 'package:craft_bay/features/auth/ui/widgets/show_snackbar.dart';
import 'package:craft_bay/features/common/controller/auth_controller.dart';
import 'package:craft_bay/features/product/controller/product_add_to_cart_controller.dart';
import 'package:craft_bay/features/product/controller/product_detail_controller.dart';
import 'package:craft_bay/features/product/controller/product_quantity_controller.dart';
import 'package:craft_bay/features/product/ui/widget/build_add_to_cart_section.dart';
import 'package:craft_bay/features/product/ui/widget/build_review_section.dart';
import 'package:craft_bay/features/product/ui/widget/build_title_section.dart';
import 'package:craft_bay/features/product/ui/widget/color_picker.dart';
import 'package:craft_bay/features/product/ui/widget/product_slider.dart';
import 'package:craft_bay/features/product/ui/widget/size_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  static final String name = '/product-detail-screen';
  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailController _productDetailController =
      Get.find<ProductDetailController>();

  @override
  void initState() {
    _productDetailController.getProductDetails(productId: widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProductQuantityController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Get.delete<ProductQuantityController>();
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SafeArea(
        child: GetBuilder<ProductDetailController>(
          builder: (_) {
            if (_productDetailController.getInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 2.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _productDetailController
                                  .productDetailModel
                                  .photoUrls
                                  .isEmpty
                              ? Center(
                                child: SizedBox(
                                  height: 150,
                                  child: Icon(Icons.error_sharp),
                                ),
                              )
                              : ProductSlider(
                                photoUrls:
                                    _productDetailController
                                        .productDetailModel
                                        .photoUrls,
                              ),
                          BuildTitleSection(),
                          BuildReviewsSection(productId: widget.productId),
                          const SizedBox(height: 1),
                          _productDetailController
                                  .productDetailModel
                                  .colors
                                  .isNotEmpty
                              ? Column(
                                children: [
                                  Text(
                                    'Color',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.black54),
                                  ),
                                  ColorPicker(
                                    colors:
                                        _productDetailController
                                            .productDetailModel
                                            .colors,
                                    onSelected: (String value) {},
                                  ),
                                ],
                              )
                              : const SizedBox.shrink(),
                          _productDetailController
                                  .productDetailModel
                                  .size
                                  .isNotEmpty
                              ? Column(
                                children: [
                                  Text(
                                    'Size',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.black54),
                                  ),
                                  SizePicker(
                                    sizes:
                                        _productDetailController
                                            .productDetailModel
                                            .size,
                                    onSelected: (String value) {},
                                  ),
                                ],
                              )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 2.0),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: Colors.black54),
                          ),
                          Text(
                            _productDetailController
                                .productDetailModel
                                .description,
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                BuildAddToCartSection(
                  onTap: _onTapAddToCart,
                  price:
                      _productDetailController.productDetailModel.currentPrice,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _onTapAddToCart() async {
    if (await Get.find<AuthController>().isUserLoggedIn()) {
      debugPrint('logged in');
      final bool isSuccess = await Get.find<ProductAddToCartController>()
          .addToCartRequest(productId: widget.productId);
      if (isSuccess) {
        showSnackBar(
          context: context,
          message: Get.find<ProductAddToCartController>().getMessage,
        );
      } else {
        showSnackBar(
          context: context,
          message: Get.find<ProductAddToCartController>().getMessage,
          isError: true,
        );
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.name,
        (predicate) => false,
      );
      showSnackBar(context: context, message: 'Please login first');
    }
  }
}
