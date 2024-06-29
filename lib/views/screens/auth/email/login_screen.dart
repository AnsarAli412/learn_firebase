import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_firebase/views/screens/auth/email/registration_screen.dart';

import '../../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {

    super.initState();

   
  }
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            textField(emailController),
            SizedBox(
              height: 10,
            ),
            textField(passwordController),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: () {
              login(emailController.text, passwordController.text);
            }, child: Text("Login")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RegistrationScreen()));
                },
                child: Text("Register")),
          ],
        ),
      ),
    );
  }

  Widget textField(TextEditingController con) {
    return TextFormField(
      controller: con,
    );
  }

  var firebaseAuth = FirebaseAuth.instance;

  login(String email, String password)async {
    try{
      var userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => HomeScreen()), (_) => false);
        Fluttertoast.showToast(msg: "Login successful");
      }else{
        Fluttertoast.showToast(msg: "You are not registered, Please register first");
      }
    } on FirebaseAuthException
    catch(e){
      Fluttertoast.showToast(msg: "Error ${e.message}");
    }
  }
}
