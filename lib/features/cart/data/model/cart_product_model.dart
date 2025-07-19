class CartProductsModel {
  final String productId;
  final String title;
  final String description;
  final List<dynamic> photos;
  final int current_price;

  CartProductsModel({
    required this.productId,
    required this.title,
    required this.description,
    required this.photos,
    required this.current_price,
  });

  factory CartProductsModel.fromJson(Map<String, dynamic> jsonData) {
    return CartProductsModel(
      productId: jsonData['_id']?.toString() ?? '',
      title: jsonData['title']?.toString() ?? '',
      description: jsonData['description']?.toString() ?? '',
      photos: jsonData['photos'] ?? [],
      current_price: jsonData['current_price'] ?? 0,
    );
  }
}
