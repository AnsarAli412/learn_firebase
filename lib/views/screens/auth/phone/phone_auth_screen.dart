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
  TextEditingController numberController = TextEditingController();
  String verificationId = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Phone Verification"),),
        body: Column(
          children: [
            TextFormField(
              controller: numberController,
            ),
            ElevatedButton(
                onPressed: () async {
                  await phoneAuth
                      .verifyPhoneNumber(numberController.text)
                      .then((id) {
                 setState(() {
                   verificationId = id;
                 });
                  });
                },
                child: const Text("Phone Verify")),

            TextFormField(
              controller: otpController,
            ),
            ElevatedButton(onPressed: (){
              phoneAuth.verifyOTP(verificationId, otpController.text);
            }, child: const Text("Verify OTP")),
          ],
        ),
      ),
    );
  }
}
