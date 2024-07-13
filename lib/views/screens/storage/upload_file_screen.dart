import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  List<File> multiFiles  = <File>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload File"),
      ),
      body: Column(
        children: [
          // Expanded(
          //     child: ListView.builder(
          //         itemCount: multiFiles.length,
          //         itemBuilder: (_, index) {
          //           return Image.file(multiFiles[index]);
          //         })),
          ElevatedButton(
              onPressed: () {
                takeFile();
              },
              child: Text("take file")),
          // ElevatedButton(onPressed: (){}, child: Text("upload file")),
        ],
      ),
    );
  }

  takeFile() async {
    var fileResult = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (fileResult != null) {
      var files = fileResult.files.map((path) => File(path.path!)).toList();
      for (var singleFile in files) {
       var a =  singleFile.path.split(".").last;
       if(a == "jpg"|| a== "png"){
         // add in image list
       } if(a == "mp4" || a == "mkv"){

       }
       print("Extensions:$a");
        multiFiles.add(singleFile);
        // uploadImage(singleFile);
      }
      setState(() {});
    }
  }

  uploadImage(File file) {
    var storage = FirebaseStorage.instance;
    storage
        .ref("profileImages")
        .child(file.path.split("/").last)
        .putFile(file)
        .then((value) async {
      var imageUrl = await value.ref.getDownloadURL();
      print(imageUrl);
      // var docId = FirebaseFirestore.instance.collection("profiles").doc().id;
      // FirebaseFirestore.instance.collection("profiles").add({"imageUrl":imageUrl});
      // Fluttertoast.showToast(msg: "Image uploaded");
    });
  }
}
