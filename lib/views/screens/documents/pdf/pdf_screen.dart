import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: getUploadedPdfs(),
          builder: (_, snap) {
            var pdfs = snap.data?.docs;
            if (pdfs?.isNotEmpty == true) {
              return ListView.builder(itemCount: pdfs?.length,
                  itemBuilder: (_, index) {
                return showPdfView(pdfs![index].data()['url']);
              });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      appBar: AppBar(
        title: const Text("My Pdfs"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectPdfFile();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  selectPdfFile() async {
    var result = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.custom, allowedExtensions: ['PDF','video','png','jpg']);
    if (result != null) {
      var files = result.files.map((path) => File(path.path!)).toList();
      for (var singleFile in files) {
        uploadPdf(singleFile);
        print(singleFile.path);
      }
      print(files.first.path);
    }
  }

  uploadPdf(File file) {
    var storage = FirebaseStorage.instance;
    storage
        .ref("profileImages")
        .child(file.path.split("/").last)
        .putFile(file)
        .then((value) async {
      var pdfUrl = await value.ref.getDownloadURL();
      print(pdfUrl);
      FirebaseFirestore.instance.collection("pdfs").add({"url": pdfUrl});
      Fluttertoast.showToast(msg: "Pdf uploaded");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUploadedPdfs() {
    var instance = FirebaseFirestore.instance.collection("pdfs");
    return instance.snapshots();
  }

  showPdfView(String pdfPath){
    return SizedBox(
      height: 400,
      child: SfPdfViewer.network(pdfPath),
    );
  }
}
