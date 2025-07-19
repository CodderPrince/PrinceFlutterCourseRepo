class ProductDetailsModel {
  final String id;
  final String title;
  final int currentPrice;
  final List<String> photoUrls;
  final String description;
  final List<String> colors;
  final List<String> size;

  ProductDetailsModel({
    required this.id,
    required this.title,
    required this.currentPrice,
    required this.photoUrls,
    required this.description,
    required this.size,
    required this.colors,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> jsonData) {
    return ProductDetailsModel(
      id: jsonData['_id'] ?? '',
      title: jsonData['title'] ?? '',
      currentPrice: jsonData['current_price'] ?? '',
      photoUrls: List<String>.from(jsonData['photos']),
      description: jsonData['description'] ?? '',
      colors: List<String>.from(jsonData['colors']),
      size: List<String>.from(jsonData['sizes']),
    );
  }
}
