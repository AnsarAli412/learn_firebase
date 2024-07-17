

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService{
  getFCMToken()async{
    var token = await FirebaseMessaging.instance.getToken();
    print("FCM token : $token");
  }

  getForegroundMessage(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message)async{
      print(message.data['name']);

      print("${message.notification?.title}");
      print("${message.notification?.body}");
      if(await checkNotificationPermission() == true){
        showNotification(message);
      }
    });
  }

  showNotification(RemoteMessage message){
    var notificationPlugin = FlutterLocalNotificationsPlugin();
    notificationPlugin.initialize(const InitializationSettings(android:AndroidInitializationSettings("@mipmap/ic_launcher") ));
    notificationPlugin.show(0, "${message.notification?.title}", "${message.notification?.body}", const NotificationDetails(
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