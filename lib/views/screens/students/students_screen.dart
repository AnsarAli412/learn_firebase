import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            TextField(
              controller: nameController,
            ),
            ElevatedButton(
                onPressed: () {
                  addStudentData(nameController.text);
                },
                child: Text("Add Students"))
          ],
        ),
      ),
    );
  }

  addStudentData(String name) async {
    // create instance of firestore
    var firestore = FirebaseFirestore.instance;
    // create a collection
   var students =  firestore.collection("students");
   // call add method to add data
        await students.add({
      "name": name,
      "email": "jyoti@gmail.com",
      "phone": 54133453654326,
      "gender": "Female",
      "age": 34.6
    }).then((ref) {
      Fluttertoast.showToast(msg: ref.id);
      print("DocId; ${ref.id}");
    }).catchError((FirebaseException error) {
      Fluttertoast.showToast(msg: "${error.message}");
    });
  }
}
