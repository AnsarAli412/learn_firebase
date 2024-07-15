import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String deviceId;

  const ChatScreen({super.key, required this.userName, required this.deviceId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  var chatRef = FirebaseDatabase.instance.ref("chats");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: getMessage(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        var data = snap.data?.snapshot.children.toList();
                        return data?.isNotEmpty != null
                            ? ListView.builder(
                                itemCount: data!.length,
                                itemBuilder: (_, index) {
                                  var message = data[index].value as Map;
                                  var senderId = message['senderId'];
                                  return senderId == widget.deviceId
                                      ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: messageView(message),
                                        )
                                      : Align(
                                          alignment: Alignment.bottomLeft,
                                          child: messageView(message),
                                        );
                                },

                              )
                            : const Center(
                                child: Text("No message found!"),
                              );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Type message....",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.black))),
                    controller: messageController,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 30,
                  child: IconButton(
                    onPressed: () {
                      addMessage(messageController.text.trim());
                    },
                    icon: Icon(
                      Icons.send,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget messageView(Map<dynamic, dynamic> message) {
    return Dismissible(
      behavior: HitTestBehavior.deferToChild,
      onDismissed: (direction){
        if(direction == DismissDirection.endToStart){
          // deleteMessage(message['id']);
          Fluttertoast.showToast(msg: "Start to end");
        }else{
          Fluttertoast.showToast(msg: "End to start");
        }
      },
        key: Key(""), child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(message['message']),
            Text(
              message['date'].toString(),
              style: TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    ));
  }

  deleteMessage(String id)async{
   await chatRef.child(id).remove();
  }

  addMessage(String message) async {
    var id = chatRef.push().key;
    await chatRef.child(id.toString()).set({
      "id": id.toString(),
      "name": widget.userName,
      "message": message,
      'senderId': widget.deviceId,
      "date": DateTime.now().toString()
    }).then((value) {
      messageController.clear();
    });
  }

  Stream<DatabaseEvent> getMessage() {
    return chatRef.onValue;
  }
}
