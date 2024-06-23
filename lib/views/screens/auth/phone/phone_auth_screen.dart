import 'package:flutter/material.dart';
import 'package:learn_firebase/controllers/auth/phone/phone_auth_controller.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  var phoneAuth = PhoneAuthController();
  TextEditingController otpController = TextEditingController();
  String verificationId = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextFormField(
              controller: otpController,
            ),
            ElevatedButton(
                onPressed: () async {
                  await phoneAuth
                      .verifyPhoneNumber("1234567890")
                      .then((id) {
                 setState(() {
                   verificationId = id;
                 });
                  });
                },
                child: const Text("Phone Verify")),

            ElevatedButton(onPressed: (){
              phoneAuth.verifyOTP(verificationId, otpController.text);
            }, child: const Text("Phone OTP")),
          ],
        ),
      ),
    );
  }
}
