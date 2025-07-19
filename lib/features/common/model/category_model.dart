class CategoryModel {
  final String title;
  final String id;
  final String iconUrl;

  CategoryModel({required this.title, required this.id, required this.iconUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> jsonData) {
    return CategoryModel(
      title: jsonData['title'],
      id: jsonData['_id'],
      iconUrl: jsonData['icon'],
    );
  }
}
