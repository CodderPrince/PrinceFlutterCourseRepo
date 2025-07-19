import 'dart:async';
import 'package:craft_bay/app/asset_paths.dart';
import 'package:craft_bay/features/auth/data/model/verification_request_model.dart';
import 'package:craft_bay/features/auth/ui/controller/verificatin_timer_controller.dart';
import 'package:craft_bay/features/auth/ui/controller/verification_controller.dart';
import 'package:craft_bay/features/auth/ui/widgets/show_snackbar.dart';
import 'package:craft_bay/features/common/screen/main_bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.email});

  static final String name = '/verification-screen';
  final String email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _pinVerificationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _verificationTimeController = Get.find<VerificationTimerController>();
  final _verificationController = Get.find<VerificationController>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _verificationTimeController.wait();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 10,
              children: [
                const SizedBox(height: 30),
                SvgPicture.asset(AssetPath.appLogoSvg, height: 120, width: 120),
                Text(
                  'Enter OTP Code',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('A 4 digit OTP code has been sent'),
                buildPinCodeTextField(),
                GetBuilder<VerificationController>(
                  builder: (context) {
                    return Visibility(
                      visible: !_verificationController.inProgress,
                      replacement: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: _onTapNext,
                        child: Text('Next'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                GetBuilder<VerificationTimerController>(
                  builder: (context) {
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Code will expire in',
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextSpan(
                            text: ' ${_verificationTimeController.getTime} s',
                          ),
                        ],
                      ),
                    );
                  },
                ),
                GetBuilder<VerificationTimerController>(
                  builder: (context) {
                    return Visibility(
                      visible: _verificationTimeController.isTimeEnd,
                      child: TextButton(
                        onPressed: () {
                          _resendOTP();
                          _verificationTimeController.wait();
                        },
                        child: Text('Resend Code'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resendOTP() async {
    final bool isSuccess = await _verificationController.resendOTP(
      email: widget.email,
    );
    if (isSuccess) {
      showSnackBar(context: context, message: _verificationController.message);
    } else {
      showSnackBar(context: context, message: _verificationController.message);
    }
  }

  Future<void> _onTapNext() async {
    if (_formKey.currentState!.validate()) {
      final String pin = _pinVerificationController.text;
      VerificationRequestModel model = VerificationRequestModel(
        email: widget.email,
        OTP: pin,
      );
      final bool isSuccess = await _verificationController.verifyOTP(model);
      if (isSuccess) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainBottomNavScreen.name,
          (predicate) => false,
        );
        showSnackBar(
          context: context,
          message: _verificationController.message,
        );
      } else {
        showSnackBar(
          context: context,
          message: _verificationController.message,
          isError: true,
        );
      }
    }
  }

  Widget buildPinCodeTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: PinCodeTextField(
        length: 4,
        validator: (String? value) {
          if (value == null || value.isEmpty || value.length < 4) {
            return '';
          }
          return null;
        },
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          inactiveColor: Colors.teal,
        ),
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        controller: _pinVerificationController,
        appContext: context,
      ),
    );
  }
}
