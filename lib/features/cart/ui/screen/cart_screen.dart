import 'package:craft_bay/constants.dart';
import 'package:craft_bay/features/cart/ui/controller/cart_screen_controller.dart';
import 'package:craft_bay/features/cart/ui/widget/build_checkout_section.dart';
import 'package:craft_bay/features/common/controller/main_bottom_nav_controller.dart';
import 'package:craft_bay/features/common/ui/widget/build_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartScreenController _cartScreenController =
      Get.find<CartScreenController>();

  @override
  void initState() {
    _cartScreenController.getCartData();
    super.initState();
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
          title: Text('Cart'),
        ),
        body: SafeArea(
          child: Column(children: [buildProductList(), BuildCheckoutSection()]),
        ),
      ),
    );
  }

  Widget buildProductList() {
    return Expanded(
      child: SizedBox(
        child: GetBuilder<CartScreenController>(
          builder: (_) {
            if (_cartScreenController.getInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: _cartScreenController.getCartList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.maxFinite,
                    height: 90,
                    decoration: buildBoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 70,
                            child:
                                _cartScreenController
                                        .getCartList[index]
                                        .productsModel
                                        .photos
                                        .isNotEmpty
                                    ? Image.network(
                                      _cartScreenController
                                          .getCartList[index]
                                          .productsModel
                                          .photos
                                          .first,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, _, __) {
                                        return const Icon(Icons.error);
                                      },
                                    )
                                    : Icon(Icons.error),
                          ),
                          buildProductInfo(context, index),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              buildDeleteButton(
                                _cartScreenController.getCartList[index].id,
                              ),
                              buildIconButtonRow(index),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.grey.shade200, spreadRadius: 2, blurRadius: 5),
      ],
    );
  }

  Widget buildProductInfo(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _cartScreenController.getCartList[index].productsModel.title,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        _cartScreenController.getCartList[index].color == 'null' ||
                _cartScreenController.getCartList[index].size == 'null'
            ? Text(
              'Color: ${_cartScreenController.getCartList[index].color}, Size: ${_cartScreenController.getCartList[index].size}',
              style: Theme.of(context).textTheme.bodySmall,
            )
            : const SizedBox.shrink(),
        const SizedBox(height: 8),
        Text(
          '${Constants.takaSign}${_cartScreenController.getCartList[index].productsModel.current_price * _cartScreenController.getCartList[index].quantity}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget buildDeleteButton(String cartId) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        splashColor: Colors.red,
        onTap: () {
          _onTapDeleteItem(cartId);
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.red.shade100,
            child: Icon(Icons.delete_outline, size: 18, color: Colors.teal),
          ),
        ),
      ),
    );
  }

  Widget buildIconButtonRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BuildIconButton(onTap: () {}, icon: Icons.horizontal_rule_rounded),
        const SizedBox(width: 2),
        Text('${_cartScreenController.getCartList[index].quantity}'),
        const SizedBox(width: 2),
        BuildIconButton(onTap: () {}, icon: Icons.add),
      ],
    );
  }

  Future<void> _onTapDeleteItem(String cartId) async {
    final String msg = await Get.find<CartScreenController>().deleteCartItem(
      id: cartId,
    );
    Get.find<CartScreenController>().getCartData();
    Get.snackbar(
      '',
      msg,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.teal,
      colorText: Colors.white,
    );
  }
}
