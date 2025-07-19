class Urls {
  static const String _baseUrl = 'https://ecom-rs8e.onrender.com/api';
  static const String signUpUrl = '$_baseUrl/auth/signup';
  static const String logInUrl = '$_baseUrl/auth/login';
  static const String verifyOtpUrl = '$_baseUrl/auth/verify-otp';
  static const String resendOtpUrl = '$_baseUrl/auth/resend-otp';
  static const String sliderUrl = '$_baseUrl/slides';

  static String categoryUrl({required int count, required int page}) =>
      '$_baseUrl/categories?count=$count&page=$page';

  static String productListByCategoryUrl({
    required int count,
    required int page,
    required String categoryId,
  }) => '$_baseUrl/products?count=$count&page=$page&category=$categoryId';

  static const String popularProductListUrl = '$_baseUrl/products?tag=popular';

  static String productDetailsUrls({required String id}) =>
      '$_baseUrl/products/id/$id';
  static const String addToCartUrls = '$_baseUrl/cart';
  static const String cartListUrls = '$_baseUrl/cart';
  static const String addToWishListUrls = '$_baseUrl/wishlist';
  static const String wishListUrls = '$_baseUrl/wishlist?count=30';

  static String deleteCartItemUrl({required String id}) => '$_baseUrl/cart/$id';

  static String reviewUrl({required String id}) =>
      '$_baseUrl/reviews?product=$id';
  static const String createView = '$_baseUrl/review';
  static const String profileDetailUrl = '$_baseUrl/auth/profile';
}
