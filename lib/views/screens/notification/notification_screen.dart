import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

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
                if(await checkNotificationPermission() == true){
                  showNotification();
                }
              }, child: const Text("Show notification"))
            ],
          ),
        ),
      ),
    );
  }

  showNotification(){
    var notificationPlugin = FlutterLocalNotificationsPlugin();
    notificationPlugin.initialize(const InitializationSettings(android:AndroidInitializationSettings("@mipmap/ic_launcher") ));
    notificationPlugin.show(0, "Rani", "Hi, kalua", const NotificationDetails(
      android: AndroidNotificationDetails("channelId","channelName")
    ));
  }

  Future<bool> checkNotificationPermission()async{
    var isGranted = false;
    var permission = await Permission.notification.isGranted;
    if(!permission){
      await Permission.notification.request();
      isGranted = false;
    }else{
      isGranted = true;
    }
    return isGranted;
  }

}
