import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_task/ui/controller/auth_controller.dart';
import 'package:task_manager_task/ui/controller/login_controller.dart';
import '../widgets/screen_background.dart';
import '../widgets/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool visiblePassword = false;

  LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Text(
                    'Get Started with',
                    style: TextTheme.of(context).headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      return validator(
                        value!,
                        regExp: RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ),
                        isEmptyTitle: 'Enter your email address',
                        alertTitle: 'Enter a valid email',
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: visiblePassword,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: _onTapPasswordVisibilityChange,
                        icon:
                            visiblePassword == true
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                      ),
                      hintText: 'Password',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value!.length < 6) {
                        return 'Password minimum 6 characters!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  GetBuilder<LoginController>(
                    builder: (controller) {
                      return Visibility(
                        visible: loginController.isLoading == false,
                        replacement: Center(child: CircularProgressIndicator()),
                        child: ElevatedButton(
                          onPressed: _onTapSignInButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _onTapForgotPasswordButton,
                          child: Text('Forget Password'),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = _onTapSignUpButton,
                              ),
                            ],
                          ),
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

  _onTapSignInButton() {
    _logIn();
  }

  Future<void> _logIn() async {
    final bool isSuccess = await loginController.logIn(
      email: _emailTEController.text.trim(),
      password: _passwordTEController.text,
    );
    if (isSuccess && AuthController.userInfoModel != null) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/MainBottomNavScreen',
        (routes) => false,
      );
    } else {}
  }

  _onTapSignUpButton() {
    Navigator.pushNamed(context, '/register');
  }

  _onTapForgotPasswordButton() {
    Navigator.pushNamed(context, '/forgetPasswordEmail');
  }

  _onTapPasswordVisibilityChange() {
    setState(() {
      visiblePassword = !visiblePassword;
    });
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
