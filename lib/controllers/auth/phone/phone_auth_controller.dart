import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhoneAuthController {
  var firebaseAuth = FirebaseAuth.instance;

  Future<String> verifyPhoneNumber(String number) async {
    String verificationId = "";
    try{
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91 $number",
          verificationCompleted: (phoneCredential) {},
          verificationFailed: (error) {
            Fluttertoast.showToast(msg: "${error.message}");
            throw Exception(error.message);
          },
          codeSent: (verifyId, resendCode) {
            verificationId = verifyId;
            Fluttertoast.showToast(msg: "Otp Sent success");

          },
          codeAutoRetrievalTimeout: (timeOut) {}).catchError((error){
        Fluttertoast.showToast(msg: "Error ${error}");
      });
    } on FirebaseAuthException catch(error){
      Fluttertoast.showToast(msg: "Error ${error.message}",toastLength: Toast.LENGTH_LONG);
    }

    return verificationId;
  }

  verifyOTP(String verificationId, String OTPCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: OTPCode);

    try {
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
          credential).catchError((error){
        Fluttertoast.showToast(msg: "Error ${error}");
      });
      if (userCredential.user != null) {
        Fluttertoast.showToast(msg: "Login Successful");
      } else {
        Fluttertoast.showToast(msg: "Login not Successful");

        print("login not successful");
        // login not success
      }
    }

    catch (error) {
      Fluttertoast.showToast(msg: "$error");
      // throw Exception(error);
    }
  }

}
