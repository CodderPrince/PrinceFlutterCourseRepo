import 'package:craft_bay/features/auth/ui/controller/profile_screen_controller.dart';
import 'package:craft_bay/features/auth/ui/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static final String name = '/profile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    callProfileDetail();
  }

  Future<void> callProfileDetail() async {
    final isSuccess =
        await Get.find<ProfileScreenController>().getProfileDetail();
    if (isSuccess == false) {
      showSnackBar(
        context: context,
        message: Get.find<ProfileScreenController>().message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(radius: 26, child: Icon(Icons.person)),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal,
                      blurRadius: 5,
                      spreadRadius: 0.6,
                    ),
                  ],
                ),
                child: GetBuilder<ProfileScreenController>(
                  builder: (controller) {
                    if (controller.inProgress) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'First Name: ${controller.profileModel.firstName}',
                        ),
                        Text('Last Name: ${controller.profileModel.lastName}'),
                        Text('Email: ${controller.profileModel.email}'),
                        Text('Phone: ${controller.profileModel.phone}'),
                        Text('City: ${controller.profileModel.city}'),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
