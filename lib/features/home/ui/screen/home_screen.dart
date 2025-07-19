import 'package:craft_bay/app/asset_paths.dart';
import 'package:craft_bay/features/auth/ui/screens/profile_screen.dart';
import 'package:craft_bay/features/auth/ui/screens/signup_screen.dart';
import 'package:craft_bay/features/common/controller/auth_controller.dart';
import 'package:craft_bay/features/common/controller/category_list_controller.dart';
import 'package:craft_bay/features/common/controller/main_bottom_nav_controller.dart';
import 'package:craft_bay/features/common/controller/popular_product_controller.dart';
import 'package:craft_bay/features/common/ui/widget/popular_item.dart';
import 'package:craft_bay/features/home/ui/controller/home_slider_controller.dart';
import 'package:craft_bay/features/home/ui/widget/app_bar_action_button.dart';
import 'package:craft_bay/features/home/ui/widget/home_carousel_slider.dart';
import 'package:craft_bay/features/common/ui/widget/product_category_item.dart';
import 'package:craft_bay/features/home/ui/widget/product_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final String name = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _onTapProfile() async {
    if (await Get.find<AuthController>().isUserLoggedIn()) {
      Navigator.pushNamed(context, ProfileScreen.name);
    } else {
      Navigator.pushNamed(context, SignUpScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                ProductSearchBar(),
                GetBuilder<HomeSliderController>(
                  builder: (slider) {
                    if (slider.inProgress) {
                      return SizedBox(
                        height: 140,
                        child: Center(child: const CircularProgressIndicator()),
                      );
                    }
                    return HomeCarouselSlider();
                  },
                ),
                buildSectionTitle(
                  title: 'Categories',
                  onTapSeeAll: _goToCategoryScreen,
                ),
                buildCategoryList(),
                buildSectionTitle(title: 'Popular', onTapSeeAll: () {}),
                buildPopularItem(),
                buildSectionTitle(title: 'New', onTapSeeAll: () {}),
                buildSectionTitle(title: 'Special', onTapSeeAll: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToCategoryScreen() {
    Get.find<MainBottomNavController>().moveToCategory();
  }

  AppBar buildAppBar() {
    return AppBar(
      title: SvgPicture.asset(AssetPath.navAppLogoSvg),
      actions: [
        BuildNavActionButton(
          onTap: () {
            _onTapProfile();
          },
          iconData: Icons.person_2_outlined,
        ),
        SizedBox(width: 8),
        BuildNavActionButton(onTap: () {}, iconData: Icons.phone),
        SizedBox(width: 8),
        BuildNavActionButton(
          onTap: () {},
          iconData: Icons.notifications_active_outlined,
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget buildSectionTitle({
    required String title,
    required VoidCallback onTapSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        TextButton(onPressed: onTapSeeAll, child: Text('See all')),
      ],
    );
  }

  Widget buildCategoryList() {
    return SizedBox(
      height: 100,
      child: GetBuilder<CategoryListController>(
        builder: (controller) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.homeCategoryListItemLength,
            itemBuilder: (context, index) {
              return ProductCategoryItem(
                categoryModel: controller.getProductCategoryList[index],
              );
            },
          );
        },
      ),
    );
  }

  Widget buildPopularItem() {
    return SizedBox(
      child: GetBuilder<PopularProductController>(
        builder: (controller) {
          if (controller.getPopularProductList.isEmpty) {
            return Text('No Products');
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.getPopularProductList.length,
            itemBuilder: (context, index) {
              return PopularItem(
                productModel: controller.getPopularProductList[index],
              );
            },
          );
        },
      ),
    );
  }
}
