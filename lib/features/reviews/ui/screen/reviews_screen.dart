import 'package:craft_bay/features/reviews/controller/review_screen_controller.dart';
import 'package:craft_bay/features/reviews/ui/screen/create_review_screen.dart';
import 'package:craft_bay/features/reviews/ui/widget/build_review_detail_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.productId});

  static final String name = 'review-screen';

  final String productId;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ReviewScreenController>().getReviews(productId: widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<ReviewScreenController>(
                builder: (controller) {
                  if (controller.inProgress) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: controller.reviewList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 5.0,
                        ),
                        child: buildReviewContainer(context, index),
                      );
                    },
                  );
                },
              ),
            ),
            BuildReviewDetailSection(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CreateReviewScreen.name,
                  arguments: widget.productId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReviewContainer(BuildContext context, int index) {
    return GetBuilder<ReviewScreenController>(
      builder: (controller) {
        return Container(
          decoration: buildBoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade50,
                      child: Icon(Icons.person, color: Colors.grey),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      "${controller.reviewList[index].userModel.firstName} ${controller.reviewList[index].userModel.lastName}",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  controller.reviewList[index].comment,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.black54),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade100),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(color: Colors.grey.shade200, spreadRadius: 1, blurRadius: 3),
      ],
    );
  }
}
