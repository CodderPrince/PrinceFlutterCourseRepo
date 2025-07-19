import 'package:craft_bay/features/common/ui/widget/build_icon_button.dart';
import 'package:craft_bay/features/product/controller/add_to_wishlist_controller.dart';
import 'package:craft_bay/features/reviews/ui/screen/reviews_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildReviewsSection extends StatelessWidget {
  const BuildReviewsSection({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '⭐ '),
              TextSpan(
                text: '4.8',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: Colors.black45),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              ReviewsScreen.name,
              arguments: productId,
            );
          },
          child: Text(
            'Reviews',
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(color: Colors.teal),
          ),
        ),
        GetBuilder<AddToWishListController>(
          builder: (controller) {
            if (controller.getInProgress) {
              return SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              );
            }
            return BuildIconButton(
              onTap: _onTapWishlistIcon,
              icon: Icons.favorite_border,
            );
          },
        ),
      ],
    );
  }

  Future<void> _onTapWishlistIcon() async {
    final bool isSuccess = await Get.find<AddToWishListController>()
        .addToWishList(productId: productId);
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
