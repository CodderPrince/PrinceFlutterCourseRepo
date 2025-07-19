import 'package:craft_bay/features/common/ui/widget/build_icon_button.dart';
import 'package:craft_bay/features/product/controller/product_detail_controller.dart';
import 'package:craft_bay/features/product/controller/product_quantity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildTitleSection extends StatelessWidget {
  const BuildTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.7,
          child: GetBuilder<ProductDetailController>(
            builder: (controller) {
              return Text(
                controller.productDetailModel.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: Colors.black54),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
        GetBuilder<ProductQuantityController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 3,
              children: [
                BuildIconButton(
                  onTap: () {
                    controller.decrementQuantity();
                  },
                  icon: Icons.horizontal_rule_rounded,
                ),
                Text('${controller.getQuantity}'),
                BuildIconButton(
                  onTap: () {
                    controller.incrementQuantity();
                  },
                  icon: Icons.add,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
