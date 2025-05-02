import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:task_manager_task/ui/controller/signup_controller.dart';
import '../widgets/screen_background.dart';
import '../widgets/validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailTEContrller = TextEditingController();
  final TextEditingController _firstNameTEContrller = TextEditingController();
  final TextEditingController _lastNameTEContrller = TextEditingController();
  final TextEditingController _mobileTEContrller = TextEditingController();
  final TextEditingController _passwordlTEContrller = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passwordVisibility = true;

  SignupController signupController = SignupController();

  _passwordVisibilityStateControl() {
    setState(() {
      passwordVisibility = !passwordVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Text(
                    'Join with Us',
                    style: TextTheme.of(context).headlineMedium,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: _emailTEContrller,
                    decoration: InputDecoration(hintText: 'Email'),
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (String? value) {
                      return validator(
                        value!,
                        isEmptyTitle: 'Enter your email address',
                        alertTitle: 'Enter a valid email',
                        regExp: RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _firstNameTEContrller,
                    decoration: InputDecoration(hintText: 'First Name'),
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (String? value) {
                      return validator(
                        value!,
                        isEmptyTitle: 'Enter your First Name',
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _lastNameTEContrller,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (String? value) {
                      return validator(
                        value!,
                        isEmptyTitle: 'Enter your Last Name',
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _mobileTEContrller,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (String? value) {
                      return validator(
                        value!,
                        regExp: RegExp(r'^(?:\+8801|8801|01)[3-9]\d{8}$'),
                        isEmptyTitle: 'Enter your Mobile Number',
                        alertTitle: 'Enter a valid Mobile number',
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (String? value) {
                      if (value!.isEmpty == true) {
                        return "Enter your password";
                      } else if (value.length < 6) {
                        return 'Password minimum 6 characters!';
                      }
                      return null;
                    },
                    obscureText: !passwordVisibility,
                    textInputAction: TextInputAction.next,
                    controller: _passwordlTEContrller,
                    decoration: InputDecoration(
                      suffix: IconButton(
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
                    child: GetBuilder<SignupController>(
                      builder: (context) {
                        return Visibility(
                          visible: signupController.isLoading == false,
                          replacement: Center(
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'Already Have an Account? '),
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = _onTapSignInButton,
                          ),
                        ],
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

  _onTapSubmit() {
    if (_formKey.currentState!.validate() == true) {
      register();
    }
  }

  Future<void> register() async {
    Map<String, dynamic> requestBody = {
      "email": _emailTEContrller.text.trim(),
      "firstName": _firstNameTEContrller.text.trim(),
      "lastName": _lastNameTEContrller.text.trim(),
      "mobile": _mobileTEContrller.text.trim(),
      "password": _passwordlTEContrller.text,
    };
    bool isSuccess = await signupController.signup(requestBody: requestBody);
    if (isSuccess) {
      _clearAllTextField();
    } else {
      return;
    }
  }

  _onTapSignInButton() {
    Navigator.pop(context);
  }

  void _clearAllTextField() {
    _emailTEContrller.clear();
    _firstNameTEContrller.clear();
    _lastNameTEContrller.clear();
    _mobileTEContrller.clear();
    _passwordlTEContrller.clear();
  }

  @override
  void dispose() {
    _emailTEContrller.dispose();
    _firstNameTEContrller.dispose();
    _lastNameTEContrller.dispose();
    _mobileTEContrller.dispose();
    _passwordlTEContrller.dispose();
    super.dispose();
  }
}
