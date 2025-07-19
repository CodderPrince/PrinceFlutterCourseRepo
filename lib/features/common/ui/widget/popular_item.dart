import 'dart:math';
import 'package:craft_bay/constants.dart';
import 'package:craft_bay/features/common/model/product_model.dart';
import 'package:craft_bay/features/common/ui/widget/build_icon_button.dart';
import 'package:craft_bay/features/product/controller/add_to_wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularItem extends StatelessWidget {
  const PopularItem({super.key, required this.productModel});

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    double review = 3.5 + (Random().nextDouble() * (4.9 - 3.5));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(4, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:
                    productModel.photoUrls.isEmpty
                        ? Icon(Icons.error)
                        : Image.network(
                          productModel.photoUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      productModel.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          '${Constants.takaSign}${productModel.currentPrice}',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),

                        Text(
                          '⭐${review.toStringAsFixed(1)}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.black),
                        ),
                        GetBuilder<AddToWishListController>(
                          builder: (controller) {
                            return BuildIconButton(
                              onTap: _onTapWishlistIcon,
                              icon: Icons.favorite_border,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapWishlistIcon() async {
    final bool isSuccess = await Get.find<AddToWishListController>()
        .addToWishList(productId: productModel.id);
    if (isSuccess) {
      Get.snackbar(
        '',
        Get.find<AddToWishListController>().getMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        '',
        Get.find<AddToWishListController>().getMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
