import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortissimo/Screens/Home.dart';
import 'package:fortissimo/Screens/Intro.dart';
import 'package:fortissimo/Utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SplashSC extends StatefulWidget {
  const SplashSC({Key? key}) : super(key: key);

  @override
  _SplashSCState createState() => _SplashSCState();
}

class _SplashSCState extends State<SplashSC> {

  late final FirebaseMessaging _messaging;

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  _checkInternet() async {
    new Future.delayed(const Duration(seconds: 2), () async {
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          _checkIsLogin();
        }
      } on SocketException catch (_) {
        print('not connected');
        Fluttertoast.showToast(
            msg: "Please check your Internet",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        SystemNavigator.pop();
      }
    });
  }

  _checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogin = prefs.getBool('isLoggedIn');
    print('isLoggedIn = $isLogin');

    new Future.delayed(const Duration(seconds: 3), () {
      if (isLogin == true) {
        registerNotification();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeSC()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => IntroSC()));
      }
    });
  }

  void registerNotification() async {
    //Handle the notification if the app is in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blueGrey,
                playSound: true,
                icon: '@mipmap/ic_final_launcher',
              ),
            )
        );
      }
    });

    //Handle the background notifications (the app is closed but not termianted)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('A new onMessageOpenedApp event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification != null && android != null) {
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text(notification.title.toString()),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body.toString())
                ],
              ),
            ),
          );
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appRed,
      body: SafeArea(
          child: Center(
            child: Image(image: AssetImage('assets/logoWhite.png'),height: 250,width: 250,),
          )
      ),
    );
  }
}
