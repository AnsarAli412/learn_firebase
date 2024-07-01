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
                child: Text("Add Students")),
            Expanded(
                child: FutureBuilder(
                    future: getStudentsData(),
                    builder: (c, snap) {
                      var data = snap.data?.docs.toList();
                      if(snap.hasData){
                        return ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (_,index){
                              return ListTile(
                                trailing: IconButton(onPressed: (){
                                  showMyBottomSheet(data[index].id);
                                }, icon: Icon(Icons.edit)),
                                leading: Text(data[index].data()['age'].toString()),
                                subtitle: Text(data[index].data()['email'].toString()),
                                title: Text(data[index].data()['name'].toString()),
                              );
                            });
                      }else{
                        return Center(child: CircularProgressIndicator(),);
                      }
                    }))
          ],
        ),
      ),
    );
  }

  showMyBottomSheet(String docId){
    showModalBottomSheet(context: context, builder: (_){
      return Column(
        children: [
          ElevatedButton(onPressed: ()async{
            await updateStudentData(docId);
            Navigator.pop(context);
            setState(() {
              getStudentsData();
            });
          }, child:Text("Update"))
        ],
      );
    });
  }

  updateStudentData(String docId)async{
    // create instance of firestore
    var firestore = FirebaseFirestore.instance;
    // create a collection
    var students = firestore.collection("students");
    await students.doc(docId).update({
      "name":"Kajal",
      "email":"kajol@gmail.com",
      "address":"Amnour"
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStudentsData()async{
    // create instance of firestore
    var firestore = FirebaseFirestore.instance;
    // create a collection
    var students = firestore.collection("students");
    var data = await students.get();
    return data;
  }

  addStudentData(String name) async {
    // create instance of firestore
    var firestore = FirebaseFirestore.instance;
    // create a collection
    var students = firestore.collection("students");
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
