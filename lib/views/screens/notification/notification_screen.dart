import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: ()async{
                // NotificationService().getFCMToken();
                // if(await checkNotificationPermission() == true){
                //   showNotification();
                // }
              }, child: const Text("Show notification"))
            ],
          ),
        ),
      ),
    );
  }



}
