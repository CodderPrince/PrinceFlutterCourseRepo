import 'package:craft_bay/constants.dart';
import 'package:craft_bay/features/cart/ui/controller/cart_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildCheckoutSection extends StatelessWidget {
  const BuildCheckoutSection({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Total Price',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.black54),
                  ),
                  GetBuilder<CartScreenController>(
                    builder: (controller) {
                      return Text(
                        '${Constants.takaSign}${controller.totalPrice}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(color: Colors.teal),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                width: 120,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Checkout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
