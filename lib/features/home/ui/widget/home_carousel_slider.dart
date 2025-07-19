import 'package:carousel_slider/carousel_slider.dart';
import 'package:craft_bay/app/app_colors.dart';
import 'package:craft_bay/features/home/data/model/slider_model.dart';
import 'package:craft_bay/features/home/ui/controller/home_slider_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCarouselSlider extends StatelessWidget {
  HomeCarouselSlider({super.key});

  final ValueNotifier<int> currentSlider = ValueNotifier<int>(0);
  final HomeSliderController _homeSliderController =
      Get.find<HomeSliderController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150.0,
            viewportFraction: 1,
            autoPlay: true,
            onPageChanged: (index, _) {
              currentSlider.value = index;
            },
          ),
          items:
              _homeSliderController.getSliderList.map((SliderModel slide) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(slide.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
        ),
        const SizedBox(height: 5),
        ValueListenableBuilder(
          valueListenable: currentSlider,
          builder: (context, index, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (
                  int i = 0;
                  i < _homeSliderController.getSliderList.length;
                  i++
                )
                  Container(
                    height: 12,
                    width: 12,
                    margin: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == i ? AppColors.themeColor : null,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
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
