import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Auth"),),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            registerUser();
          }, child: Text("Register")),
          ElevatedButton(onPressed: (){
            loginUser();
          }, child: Text("Login")),
        ],
      ),
    );
  }

  registerUser()async{
    var fireStore = FirebaseFirestore.instance;
    var existUser = await fireStore.collection("users").where('email',isEqualTo: 'a@gmail.com').get();
    if(existUser.docs.isNotEmpty){
      Fluttertoast.showToast(msg: "Email already exist");
    }else{
       await fireStore.collection("users").add({
        'email':"a@gmail.com",
        "password":"123456"
      });
    }
  }

  loginUser()async{
    var fireStore = FirebaseFirestore.instance;
    var existUser = await fireStore.collection("users").where('email',isEqualTo: 'a@gmail.com').get();
    if(existUser.docs.isNotEmpty){
      var isValidUser = existUser.docs.firstWhere((user)=>user.data()['password'] == '123456').exists;
      if(isValidUser){
        Fluttertoast.showToast(msg: "Login successful");
      }
    }else{
      Fluttertoast.showToast(msg: "Please register first!");
    }
  }
}
