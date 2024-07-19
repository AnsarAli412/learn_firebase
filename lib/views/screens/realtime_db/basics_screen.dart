
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Future<void> addMultipleDataToDatabase()async{
  // async = create make this function asynchronous
  var dbReference = FirebaseDatabase.instance.ref("users");
  // dbReference is a variable to store the database reference
  // FirebaseDatabase = to access the database
  // .instance = to get the instance of default FirebaseAPP
  // .ref("users") = ref method will create a base (root) object on the database and "users" is the name of object.
  // var id = dbReference.push();
  // push method will generate the random object on the database.
  await dbReference.push().set({
    "name":"Ali",
    "email":"ali@gmail.com",
    "age":110.0,
    "gender":"Male"
  });

  // await (keyword) for waiting the response of set method.
  // set method = this method will take data in the form of map (key,value)
  // this method will the data on the database
}
Future<void> getSingleDataToDatabase()async{
  // async = create make this function asynchronous
  var dbReference = FirebaseDatabase.instance.ref("users");
  // dbReference is a variable to store the database reference
  // FirebaseDatabase = to access the database
  // .instance = to get the instance of default FirebaseAPP
  // .ref("users") = ref method will reach a base (root) object on the database and how is "users" object.

 var data =  await dbReference.get();
  // get method will return a class called 'DataSnapshot'
  // DataSnapshot  = return the data in the form of value and children, key
  // data.value = this will return data which is stored the the "users" object because we are calling the data from ref() only
  // data.children = this will return list of data (DataSnapshot) if "users" object has data in the form of multiple object
  var fullData = data.value as Map;
  // "value" will return data in the object so we need to convert it in the Map.
  print(fullData);
  var allObjects = data.children.toList();
  // to get data from "DataSnapshot". we need to call value and value will give data in the object ()
  print(allObjects);
}
Future<void> updateSingleDataToDatabase()async{
  // async = create make this function asynchronous
  var dbReference = FirebaseDatabase.instance.ref("users");
  // dbReference is a variable to store the database reference
  // FirebaseDatabase = to access the database
  // .instance = to get the instance of default FirebaseAPP
  // .ref("users") = ref method will reach a base (root) object on the database and how is "users" object.

await dbReference.update({
   "name":"Ranjan"
 });
 // update method will update the give data.
  // this method takes data in the form of key,value;
  //if you want to update anything else the try to reach there first.
  // new value of name id "Ranjan"
}
Future<void> deleteSingleDataToDatabase()async{
  // async = create make this function asynchronous
  var dbReference = FirebaseDatabase.instance.ref("users");
  // dbReference is a variable to store the database reference
  // FirebaseDatabase = to access the database
  // .instance = to get the instance of default FirebaseAPP
  // .ref("users") = ref method will reach a base (root) object on the database and how is "users" object.

await dbReference.remove();
// remove method will remove the data from where we have reached
 // here we have reached to the "users" object so this object will be remove from data base
  // if you want to remove anything else the try to reach there first.
}

class BasicsScreen extends StatefulWidget {
  const BasicsScreen({super.key});

  @override
  State<BasicsScreen> createState() => _BasicsScreenState();
}

class _BasicsScreenState extends State<BasicsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            deleteSingleDataToDatabase();
          }, child: Text("Add data"))
        ],
      ),
    );
  }
}
