import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_task/data/service/network_client.dart';
import 'package:task_manager_task/data/utils/urls.dart';
import 'package:task_manager_task/ui/widgets/pop_up_message.dart';
import '../widgets/screen_background.dart';

class ForgetPasswordOtpVerificationScreen extends StatefulWidget {
  const ForgetPasswordOtpVerificationScreen({super.key});

  @override
  State<ForgetPasswordOtpVerificationScreen> createState() =>
      _ForgetPasswordOtpVerificationScreenState();
}

class _ForgetPasswordOtpVerificationScreenState
    extends State<ForgetPasswordOtpVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _otpTEController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument = ModalRoute.of(context)!.settings.arguments;
    receivedEmail = argument as String;
  }

  String? receivedEmail;

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
                    'PIN Verification',
                    style: TextTheme.of(context).headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'A 6 digit pin verification will be sent to your email address',
                    style: TextTheme.of(context).labelLarge,
                  ),
                  const SizedBox(height: 20),
                  PinCodeTextField(
                    length: 6,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 40,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      activeColor: Colors.green,
                      inactiveColor: Colors.green,
                      selectedColor: Colors.red,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _otpTEController,
                    appContext: context,
                    validator: (String? value) {
                      if (value!.trim().isEmpty == true) {
                        return 'Please Provide your OTP';
                      } else if (value.trim().length < 6) {
                        return 'Provide valid OTP';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _onTapSubmit,
                    child: Visibility(
                      visible: isLoading == false,
                      replacement: Padding(
                        padding: const EdgeInsets.all(3.0),
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
                          TextSpan(text: 'Already Have an Account?'),
                          TextSpan(
                            text: ' Sign in',
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
      forgetPasswordOTPVerify();
    }
  }

  Future<void> forgetPasswordOTPVerify() async {
    final String otp = _otpTEController.text;

    isLoading = true;
    setState(() {});

    String url = Urls.forgetPasswordEmailAndOPTVerify(
      email: receivedEmail,
      otp: otp,
    );
    NetworkResponse response = await NetworkClient.getRequest(url: url);

    if (!mounted) return;

    if (response.statusCode == 200) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/resetPassword',
        (route) => false,
        arguments: {'email': receivedEmail, 'OTP': _otpTEController.text},
      );
      return;
    } else {
      showPopUp(context, 'Invalid OTP !!!', true);
    }
    isLoading = false;
  }

  _onTapSignInButton() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
