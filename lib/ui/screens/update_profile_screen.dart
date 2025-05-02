import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_task/data/model/user_model.dart';
import 'package:task_manager_task/ui/controller/auth_controller.dart';
import 'package:task_manager_task/ui/controller/update_profile_controller.dart';
import 'package:task_manager_task/ui/widgets/pop_up_message.dart';
import '../widgets/screen_background.dart';
import '../widgets/tm_app_bar.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool passwordVisibility = true;

  _passwordVisibilityStateControl() {
    setState(() {
      passwordVisibility = !passwordVisibility;
    });
  }

  XFile? pickedImage;

  UpdateProfileController updateProfileController =
      Get.find<UpdateProfileController>();

  @override
  void initState() {
    UserModel userModel = AuthController.userInfoModel!;
    _emailTEController.text = userModel.email;
    _firstNameTEController.text = userModel.firstName;
    _lastNameTEController.text = userModel.lastName;
    _mobileTEController.text = userModel.mobile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromUpdateProfileScreen: true),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 120),
                  Text(
                    'Join with Us',
                    style: TextTheme.of(context).headlineMedium,
                  ),
                  const SizedBox(height: 20),

                  _buildPhotoPickerWidgets(),
                  SizedBox(height: 10),

                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: _emailTEController,
                    enabled: false,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: 'First Name'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: 'Last Name'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _mobileTEController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: !passwordVisibility,
                    textInputAction: TextInputAction.next,
                    controller: _passwordTEController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: _passwordVisibilityStateControl,
                        icon:
                            passwordVisibility
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                      ),
                      hintText: 'Password',
                    ),
                  ),
                  SizedBox(height: 10),

                  Visibility(
                    child: ElevatedButton(
                      onPressed: _onTapSubmit,
                      child: GetBuilder<UpdateProfileController>(
                        builder: (context) {
                          return Visibility(
                            visible: updateProfileController.isLoading == false,
                            replacement: CircularProgressIndicator(),
                            child: Icon(Icons.arrow_circle_right_outlined),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerWidgets() {
    return GestureDetector(
      onTap: _onTapPhotoPicker,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text('Photo', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 210,
              child: Text(
                pickedImage == null ? 'Select your photo' : pickedImage!.name,
                overflow: TextOverflow.ellipsis,
                style: TextTheme.of(context).bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onTapSubmit() async {
    bool isUserMadeAnyChange =
        pickedImage != null ||
        AuthController.userInfoModel?.firstName !=
            _firstNameTEController.text.trim() ||
        AuthController.userInfoModel?.lastName !=
            _lastNameTEController.text.trim() ||
        AuthController.userInfoModel?.mobile != _mobileTEController.text.trim();
    bool isPasswordChange = _passwordTEController.text.trim().isNotEmpty;
    if (isUserMadeAnyChange || isPasswordChange) {
      await updateProfile();
      _passwordTEController.clear();
    } else {
      showPopUp(context, 'You did not make any changes to update.', true);
    }
  }

  _onTapPhotoPicker() {
    // imagePicker();
    showAlertDialogue();
  }

  bool isCamera = true;

  Future<void> updateProfile() async {
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };
    if (_passwordTEController.text.isNotEmpty) {
      requestBody['password'] = _passwordTEController.text;
    }
    if (pickedImage != null) {
      List<int> imageByte = await pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageByte);
      requestBody['photo'] = encodedImage;
    }
    await updateProfileController.updateProfile(requestBody: requestBody);
  }

  Future<void> imagePicker() async {
    final picker = ImagePicker();
    final pickFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickFile != null) {
      setState(() {
        pickedImage = pickFile;
      });
    }
  }

  void showAlertDialogue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        isCamera = true;
                        imagePicker();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.camera, color: Colors.blue, size: 50),
                    ),
                    Text('Camera'),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        isCamera = false;
                        imagePicker();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.image, color: Colors.blue, size: 50),
                    ),
                    Text('Gallery'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
