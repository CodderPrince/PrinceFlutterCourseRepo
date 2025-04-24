import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:task_manager_task/data/model/profile_details_model.dart';
import 'package:task_manager_task/data/model/user_model.dart';
import 'package:task_manager_task/data/service/network_client.dart';
import 'package:task_manager_task/data/utils/urls.dart';
import 'package:task_manager_task/ui/controller/auth_controller.dart';
import '../widgets/screen_background.dart';
import '../widgets/tm_app_bar.dart';

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

  @override
  void initState() {
    UserModel userModel = AuthController.userInfoModel!;
    _emailTEController.text = userModel.email;
    _firstNameTEController.text = userModel.firstName;
    _lastNameTEController.text = userModel.lastName;
    _mobileTEController.text = userModel.mobile;
    super.initState();
  }

  VoidCallback? onUpdate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as VoidCallback;
    onUpdate = args;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromProfileScreen: true),
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

                  ElevatedButton(
                    onPressed: _onTapSubmit,
                    child: const Icon(Icons.arrow_circle_right_outlined),
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

  _onTapSubmit() {
    updateProfile();
    _passwordTEController.clear();
  }

  _onTapPhotoPicker() {
    // imagePicker();
    showAlertDialogue();
  }

  bool isCamera = true;
  final Logger _logger = Logger();

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
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );
    if (response.statusCode == 200) {
      getProfileDetails();
      setState(() {});
    } else {
      _logger.e(response.errorMessage);
    }
  }

  Future<void> getProfileDetails() async {
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.profileDetailsUrl,
    );
    if (response.statusCode == 200) {
      String token = AuthController.token!;

      Map<String, dynamic> userDetailsMap = response.data!['data'][0];
      _logger.w(userDetailsMap);
      UpdateProfileModel updateProfileModel = UpdateProfileModel.fromJson(
        response.data!,
      );

      Map<String, dynamic> prepareJsonDataForInitiatingUserModel = {
        "_id": updateProfileModel.data.id,
        "email": updateProfileModel.data.email,
        "firstName": updateProfileModel.data.firstName,
        "lastName": updateProfileModel.data.lastName,
        "mobile": updateProfileModel.data.mobile,
        "createdDate": updateProfileModel.data.createdDate,
        "photo": updateProfileModel.data.photo,
      };
      UserModel userModel = UserModel.convertJsonToDart(
        prepareJsonDataForInitiatingUserModel,
      );

      await AuthController.saveUserInformation(token, userModel);
      await AuthController.getUserInformation();
      if (AuthController.token != null) {
        _logger.i('State update Successfully ${AuthController.userInfoModel}');
        setState(() {});
        if (onUpdate != null) {
          _logger.w('Got the notifier from update screen');
          onUpdate!();
        } else {
          _logger.e('Failed to got the notifier form profile update screen');
        }
      } else {
        _logger.e('Fail to update the state');
      }
    }
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
