import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   XFile? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),),
      body: Column(
        children: [
          imageFile == null?Container(
            height: 200,
            width: 200,
            color: Colors.black,
          ):Image.file(File(imageFile?.path??"")),
          ElevatedButton(onPressed: (){
            takeImage();
          }, child: Text("Take Image")),
          ElevatedButton(onPressed: (){
            uploadImage();
          }, child: Text("Upload Image")),
          Image.network("https://firebasestorage.googleapis.com/v0/b/learn-firebase-girls.appspot.com/o/profileImages%2F58430bba-12d7-4698-ad57-99d8d68fe0ed1254599772401800016.jpg?alt=media&token=920782c0-a710-440e-b3ff-b1dc0beec0eb")
        ],
      ),
    );
  }

  takeImage()async{
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = image!;
    });
  }

  uploadImage(){
    var storage = FirebaseStorage.instance;
    storage.ref("profileImages").child(imageFile?.name??"").putFile(File(imageFile?.path??"")).then((value)async{
     var imageUrl =  await value.ref.getDownloadURL();
     print(imageUrl);
     var docId = FirebaseFirestore.instance.collection("profiles").doc().id;
     FirebaseFirestore.instance.collection("profiles").add({"imageUrl":imageUrl});
      Fluttertoast.showToast(msg: "Image uploaded");
    });
  }
}
