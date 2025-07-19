import 'package:craft_bay/features/reviews/controller/review_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildReviewDetailSection extends StatelessWidget {
  const BuildReviewDetailSection({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<ReviewScreenController>(
                builder: (controller) {
                  return Text(
                    'Reviews(${controller.reviewList.length})',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.black54),
                  );
                },
              ),
              Material(
                shape: const CircleBorder(),
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircleAvatar(radius: 20.0, child: Icon(Icons.add)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
