import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_firebase/views/screens/documents/pdf/pdf_screen.dart';
import 'package:learn_firebase/views/screens/documents/videos/video_screen.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  var folders = <Map>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Folders"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewFolderDialog();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: getFolders(),
          builder: (_, snap) {
            var folders = snap.data?.docs;
            if (snap.hasData) {
              return folders!.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (_, index) {
                        return ListTile(
                          onTap: () {
                            gotoNextScreenBasedOnType(folders[index]['type']);
                          },
                          leading: Icon(Icons.folder),
                          title: Text(folders[index]['name']),
                          subtitle: Text(folders[index]['type']),
                        );
                      },
                      separatorBuilder: (_, index) {
                        return Divider();
                      },
                      itemCount: folders.length)
                  : Center(
                      child: Text("No folder found"),
                    );
            } else {
              return Center(
                child: Text("No folder found"),
              );
            }
          }),
    );
  }

  var folderTypes = ['Image', 'Video', 'Pdf'];
  var selectedType = '';
  TextEditingController folderNameController = TextEditingController();

  createNewFolderDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Create new folder"),
            content: Column(
              children: [
                DropdownButtonFormField(
                    items: folderTypes
                        .map((type) => DropdownMenuItem(
                              child: Text(type),
                              value: type,
                            ))
                        .toList(),
                    onChanged: (type) {
                      selectedType = type ?? "";
                      setState(() {});
                    }),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: folderNameController,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {

                    addFolder();
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text("Add")),
              ElevatedButton(onPressed: () {}, child: Text("Cancel")),
            ],
          );
        });
  }

  gotoNextScreenBasedOnType(String type) {
    if (type == folderTypes[0]) {
      // go to image screen
    } else if (type == folderTypes[1]) {
      gotoNext(VideoScreen());
    } else {
      gotoNext(PdfScreen());
    }
  }

  gotoNext(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  addFolder() async {
    await FirebaseFirestore.instance.collection("folders").add(
        {"name": folderNameController.text, "type": selectedType}).then((v) {
      Fluttertoast.showToast(msg: "Folder created");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFolders() {
    return FirebaseFirestore.instance.collection("folders").snapshots();
  }
}
