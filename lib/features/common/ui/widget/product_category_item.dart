import 'package:craft_bay/features/common/model/category_model.dart';
import 'package:craft_bay/features/product/ui/screen/single_category_product_list_screen.dart';
import 'package:flutter/material.dart';

class ProductCategoryItem extends StatelessWidget {
  const ProductCategoryItem({super.key, required this.categoryModel});

  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          SingleCategoryProductListScreen.name,
          arguments: categoryModel,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(categoryModel.iconUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              getTitle(categoryModel.title),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String getTitle(String title) {
    if (title.length > 7) {
      return title.substring(0, 6) + '...';
    }
    return title;
  }
}
