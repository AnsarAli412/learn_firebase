import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_firebase/views/screens/auth/email/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {
          logout();
        }, child: Text("Logout")),
      ),
    );
  }

  logout() async {
    var auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      auth.signOut().then((v){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginScreen()), (_) => false);
      });
    } else {
      Fluttertoast.showToast(
          msg: "You can't logout, Because you are not login");
    }
  }
}
