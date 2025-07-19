import 'package:craft_bay/features/auth/data/model/sign_up_request_model.dart';
import 'package:craft_bay/features/auth/ui/controller/sign_up_controller.dart';
import 'package:craft_bay/features/auth/ui/screens/login_screen.dart';
import 'package:craft_bay/features/auth/ui/screens/verification_screen.dart';
import 'package:craft_bay/features/auth/ui/widgets/show_snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:craft_bay/features/auth/ui/widgets/app_logo.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static final String name = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shippingAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final SignUpController _signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 44),
                  AppLogo(width: 90, height: 90),
                  const SizedBox(height: 24),
                  Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Get started with us with your details',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter First Name';
                      }
                      final isOnlyLetters = RegExp(r'^[a-zA-Z\s]+$');
                      if (!isOnlyLetters.hasMatch(value.trim())) {
                        return 'Only letters are allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter Last Name';
                      }
                      final isOnlyLetters = RegExp(r'^[a-zA-Z\s]+$');
                      if (!isOnlyLetters.hasMatch(value.trim())) {
                        return 'Only letters are allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Phone'),
                    validator: (String? value) {
                      String pattern = r'^(?:\+?88|0088)?01[13-9]\d{8}$';
                      RegExp regExp = RegExp(pattern);
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter mobile number';
                      } else if (!regExp.hasMatch(value!)) {
                        return 'Please enter valid mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (value == null ||
                          EmailValidator.validate(value) == false) {
                        return 'Enter valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: false,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                      );
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else {
                        if (value.length < 8) {
                          return 'At least 8 character';
                        }
                        if (!regex.hasMatch(value)) {
                          return "Must contain at least one\nlowercase,uppercase,special,digit";
                        } else {
                          return null;
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cityController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'City'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter City';
                      }
                      final isOnlyLetters = RegExp(r'^[a-zA-Z\s]+$');
                      if (!isOnlyLetters.hasMatch(value.trim())) {
                        return 'Only letters are allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _shippingAddressController,
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Shipping Address'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter Shipping Address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  GetBuilder<SignUpController>(
                    builder: (context) {
                      return Visibility(
                        visible: !_signUpController.inProgress,
                        replacement: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: _onTapNext,
                          child: Text('Sign Up'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account ? ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'LogIn',
                          style: TextStyle(color: Colors.teal),
                          recognizer:
                              TapGestureRecognizer()..onTap = _onTapLogin,
                        ),
                      ],
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

  Future<void> _onTapNext() async {
    if (_formKey.currentState!.validate()) {
      final SignUpRequestModel model = SignUpRequestModel(
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        password: _passwordController.text.trim(),
        city: _cityController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      final bool isSuccess = await _signUpController.signUp(model);
      if (isSuccess) {
        Navigator.pushNamed(
          context,
          VerificationScreen.name,
          arguments: _emailController.text.trim(),
        );
        showSnackBar(context: context, message: _signUpController.message);
        _clearText();
      } else {
        showSnackBar(
          context: context,
          message: _signUpController.message,
          isError: true,
        );
      }
    }
  }

  void _onTapLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.name,
      (predicate) => false,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _shippingAddressController.dispose();
    super.dispose();
  }

  void _clearText() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _cityController.clear();
    _shippingAddressController.clear();
  }
}
