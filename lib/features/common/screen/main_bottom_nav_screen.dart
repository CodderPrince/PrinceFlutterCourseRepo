import 'package:craft_bay/features/cart/ui/screen/cart_screen.dart';
import 'package:craft_bay/features/common/controller/category_list_controller.dart';
import 'package:craft_bay/features/common/controller/main_bottom_nav_controller.dart';
import 'package:craft_bay/features/common/controller/popular_product_controller.dart';
import 'package:craft_bay/features/home/ui/controller/home_slider_controller.dart';
import 'package:craft_bay/features/home/ui/screen/home_screen.dart';
import 'package:craft_bay/features/product/ui/screen/product_category_screen.dart';
import 'package:craft_bay/features/wish%20list/ui/screen/wish_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  static final String name = '/main-bottom-nav';

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  final _mainBottomNavController = Get.find<MainBottomNavController>();

  final List<Widget> _screens = [
    HomeScreen(),
    ProductCategoryScreen(),
    CartScreen(),
    WishListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeSliderController>().getSlides();
      Get.find<CategoryListController>().getProducts();
      Get.find<PopularProductController>().getPopularProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainBottomNavController>(
      builder: (context) {
        return Scaffold(
          body: _screens[_mainBottomNavController.selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _mainBottomNavController.selectedIndex,
            onDestinationSelected: (int index) {
              _mainBottomNavController.setCurrentIndex(index);
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.category_rounded),
                label: 'Category',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_rounded),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_rounded),
                label: 'Wishlist',
              ),
            ],
          ),
        );
      },
    );
  }
}
