import 'package:craft_bay/constants.dart';
import 'package:craft_bay/features/product/controller/product_add_to_cart_controller.dart';
import 'package:craft_bay/features/product/controller/product_quantity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildAddToCartSection extends StatelessWidget {
  const BuildAddToCartSection({
    super.key,
    required this.onTap,
    required this.price,
  });

  final VoidCallback onTap;
  final int price;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.black54),
                  ),
                  GetBuilder<ProductQuantityController>(
                    builder: (controller) {
                      return Text(
                        '${Constants.takaSign}${controller.getQuantity * price}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(color: Colors.teal),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                width: 140,
                height: 35,
                child: GetBuilder<ProductAddToCartController>(
                  builder: (controller) {
                    if (controller.getInProgress) {
                      return Text('Loading...');
                    }
                    return ElevatedButton(
                      onPressed: onTap,
                      child: Text('Add To Cart'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
