import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_task/data/service/network_client.dart';
import 'package:task_manager_task/ui/widgets/pop_up_message.dart';
import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _cfmPasswordTEController =
      TextEditingController();

  bool _passwordVisibility = true;
  bool _cfmPasswordVisibility = true;

  pswVisibilityControl({required bool isCfmPsw}) {
    if (isCfmPsw == false) {
      setState(() {
        _passwordVisibility = !_passwordVisibility;
      });
    } else if (isCfmPsw == true) {
      setState(() {
        _cfmPasswordVisibility = !_cfmPasswordVisibility;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    receivedEmailAndOtp = arguments as Map<String, dynamic>;
  }

  Map<String, dynamic>? receivedEmailAndOtp;
  bool isLoading = false;

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
                  const SizedBox(height: 150),
                  Text(
                    'Set Password',
                    style: TextTheme.of(context).headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Minimum length password 8 character with letter and number combination!',
                    style: TextTheme.of(context).labelLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: !_passwordVisibility,
                    textInputAction: TextInputAction.next,
                    controller: _passwordTEController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be minimum 6 characters!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () => pswVisibilityControl(isCfmPsw: false),
                        icon:
                            _passwordVisibility
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                      ),
                      hintText: 'Password',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: !_cfmPasswordVisibility,
                    textInputAction: TextInputAction.next,
                    controller: _cfmPasswordTEController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != _passwordTEController.text) {
                        return 'Password not matched!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () => pswVisibilityControl(isCfmPsw: true),
                        icon:
                            _cfmPasswordVisibility
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                      ),
                      hintText: 'Confirm Password',
                    ),
                  ),

                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _onTapSubmit,
                    child: Visibility(
                      visible: isLoading == false,
                      replacement: Padding(
                        padding: EdgeInsets.all(3),
                        child: CircularProgressIndicator(),
                      ),
                      child: Icon(Icons.arrow_circle_right_outlined),
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

  _onTapSignInButton() {
    Navigator.pushNamed(context, '/login');
  }

  _onTapSubmit() {
    if (_formKey.currentState!.validate() == true) {
      resetPassword();
    }
    return;
  }

  Future<void> resetPassword() async {
    isLoading = true;
    setState(() {});

    String newPassword = _passwordTEController.text;
    Map<String, dynamic> requestBody = {
      "email": receivedEmailAndOtp!['email'],
      "OTP": receivedEmailAndOtp!['OTP'],
      "password": newPassword,
    };
    String url = Urls.resetPasswordRrl;
    NetworkResponse response = await NetworkClient.postRequest(
      url: url,
      body: requestBody,
    );
    if (response.statusCode == 200) {
      if (!mounted) return;
      showPopUp(context, 'Password reset successfully!');
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (predicate) => false,
      );
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _cfmPasswordTEController.dispose();
    super.dispose();
  }
}
