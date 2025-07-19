import 'package:craft_bay/core/services/network/network_client.dart';
import 'package:craft_bay/features/auth/ui/controller/login_controller.dart';
import 'package:craft_bay/features/auth/ui/controller/profile_screen_controller.dart';
import 'package:craft_bay/features/auth/ui/controller/sign_up_controller.dart';
import 'package:craft_bay/features/auth/ui/controller/verificatin_timer_controller.dart';
import 'package:craft_bay/features/auth/ui/controller/verification_controller.dart';
import 'package:craft_bay/features/auth/ui/screens/login_screen.dart';
import 'package:craft_bay/features/cart/ui/controller/cart_screen_controller.dart';
import 'package:craft_bay/features/common/controller/auth_controller.dart';
import 'package:craft_bay/features/common/controller/category_list_controller.dart';
import 'package:craft_bay/features/common/controller/main_bottom_nav_controller.dart';
import 'package:craft_bay/features/common/controller/popular_product_controller.dart';
import 'package:craft_bay/features/home/ui/controller/home_slider_controller.dart';
import 'package:craft_bay/features/product/controller/add_to_wishlist_controller.dart';
import 'package:craft_bay/features/product/controller/product_add_to_cart_controller.dart';
import 'package:craft_bay/features/product/controller/product_detail_controller.dart';
import 'package:craft_bay/features/reviews/controller/create_review_screen_controller.dart';
import 'package:craft_bay/features/reviews/controller/review_screen_controller.dart';
import 'package:craft_bay/features/wish%20list/controller/wishlist_screen_controller.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(MainBottomNavController());
    Get.put(VerificationTimerController());
    Get.put(SignUpController());
    Get.put(VerificationController());
    Get.put(AuthController());
    Get.put(HomeSliderController());
    Get.put(CategoryListController());
    Get.put(LoginController());
    Get.put(PopularProductController());
    Get.put(ProductDetailController());
    Get.put(ProductAddToCartController());
    Get.put(CartScreenController());
    Get.put(AddToWishListController());
    Get.put(WishListScreenController());
    Get.put(ReviewScreenController());
    Get.put(CreateReviewScreenController());
    Get.put(ProfileScreenController());
    Get.put(NetworkClient(onUnAuthorize: _onUnAuthorize));
  }

  Future<void> _onUnAuthorize() async {
    await Get.find<AuthController>().clearUserData();
    Get.to(() => LoginScreen());
  }
}
