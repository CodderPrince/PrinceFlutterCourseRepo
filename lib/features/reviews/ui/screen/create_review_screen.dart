import 'package:craft_bay/features/auth/ui/widgets/show_snackbar.dart';
import 'package:craft_bay/features/reviews/controller/create_review_screen_controller.dart';
import 'package:craft_bay/features/reviews/controller/review_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({super.key, required this.productId});

  static final String name = 'create-review-screen';
  final String productId;

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Review'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Column(
                spacing: 15.0,
                children: [
                  TextFormField(
                    controller: _reviewController,
                    maxLines: 8,
                    decoration: InputDecoration(hintText: 'Write Review'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter comment';
                      }
                    },
                  ),
                  GetBuilder<CreateReviewScreenController>(
                    builder: (controller) {
                      if (controller.inProgress) {
                        return Text('Wait! Adding Reviews');
                      }
                      return ElevatedButton(
                        onPressed: _onTapSubmit,
                        child: Text('Submit'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapSubmit() async {
    if (_globalKey.currentState!.validate()) {
      final String comment = _reviewController.text.trim();
      Map<String, dynamic> body = {
        "product": widget.productId,
        "comment": comment,
      };
      final bool isSuccess = await Get.find<CreateReviewScreenController>()
          .createReview(body);
      if (isSuccess) {
        Navigator.pop(context);
        Get.find<ReviewScreenController>().getReviews(
          productId: widget.productId,
        );
      }
      showSnackBar(
        context: context,
        message: Get.find<CreateReviewScreenController>().message,
      );
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
