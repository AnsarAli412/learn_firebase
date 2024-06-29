import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../home/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              registration(emailController.text, passwordController.text);
            }, child: Text("Register"))
          ],
        ),
      ),
    );
  }

  Widget textField(TextEditingController con){
    return TextFormField(
      controller:  con,
    );
  }


  var firebaseAuth = FirebaseAuth.instance;

  registration(String email, String password)async {
    try{
      var userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => HomeScreen()), (_) => false);
        Fluttertoast.showToast(msg: "Registration successful");
      }else{
        Fluttertoast.showToast(msg: "Something went wrong!");
      }
    } on FirebaseAuthException
    catch(e){
      if(e.code =='email-already-in-use'){
        Fluttertoast.showToast(msg: "This email is already registered");
      }else if (e.code =='invalid-email'){
        Fluttertoast.showToast(msg: "Please enter a valid email");
      }else if(e.code == 'weak-password'){
        Fluttertoast.showToast(msg: "Password most be 8 charter");
      }else{
        Fluttertoast.showToast(msg: "Error ${e.message}");
      }
    }
  }
}
