import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthController {
  var firebaseAuth = FirebaseAuth.instance;

  Future<String> verifyPhoneNumber(String number) async {
    String verificationId = "";
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91 $number",
        verificationCompleted: (phoneCredential) {},
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verifyId, resendCode) {
          verificationId = verifyId;
        },
        codeAutoRetrievalTimeout: (timeOut) {});

    return verificationId;
  }

  verifyOTP(String verificationId, String OTPCode)async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: OTPCode);

   UserCredential userCredential =  await firebaseAuth.signInWithCredential(credential);
   if(userCredential.user != null){
     // login success full
     print("login successful");
   }else{
     print("login not successful");
     // login not success
   }

  }
}
