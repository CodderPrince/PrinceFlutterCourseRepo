class VerificationRequestModel {
  final String email;
  final String OTP;

  VerificationRequestModel({required this.email, required this.OTP});

  Map<String, dynamic> toJson() {
    return {"email": email, "otp": OTP};
  }
}
