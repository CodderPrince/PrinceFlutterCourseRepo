import 'package:carousel_slider/carousel_slider.dart';
import 'package:craft_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class ProductSlider extends StatefulWidget {
  const ProductSlider({super.key, required this.photoUrls});

  final List<String> photoUrls;

  @override
  State<ProductSlider> createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  final ValueNotifier<int> currentSlider = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items:
              widget.photoUrls.map((url) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child:
                      widget.photoUrls.isNotEmpty
                          ? Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
                          )
                          : Icon(Icons.error),
                );
              }).toList(),
          options: CarouselOptions(
            height: 150.0,
            viewportFraction: 1,
            autoPlay: true,
            onPageChanged: (index, _) {
              currentSlider.value = index;
            },
          ),
        ),
        const SizedBox(height: 3),
        ValueListenableBuilder(
          valueListenable: currentSlider,
          builder: (context, int value, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.photoUrls.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        color: value == i ? AppColors.themeColor : null,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
