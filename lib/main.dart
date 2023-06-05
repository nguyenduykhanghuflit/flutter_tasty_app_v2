import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/screens/Auth/login_page.dart';
import 'package:tasty_app_v2/screens/CreatePlace/create_place_page.dart';
import 'package:tasty_app_v2/screens/DetailPost/detail_post_page.dart';
import 'package:tasty_app_v2/screens/GoogleMap/google_map.dart';
import 'package:tasty_app_v2/screens/StartApp/main_page.dart';
import 'package:tasty_app_v2/screens/Auth/register_page.dart';
import 'package:tasty_app_v2/services/FirebaseService.dart';
import 'screens/StartApp/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tasty_app_v2/firebase_options.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FirebaseMessaging.onMessage.listen((event){
  //       (RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //     }
  //   };
  // });

  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);
  runApp(const MyApp());
}

// ...

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/startUp",
      getPages: [
        GetPage(name: "/startUp", page: () => const SplashPage()),
        GetPage(name: "/login", page: () => const LoginPage()),
        GetPage(name: "/register", page: () => const RegisterPage()),
        GetPage(name: "/main", page: () => const MyHomePage()),
        GetPage(name: "/post/:id", page: () => const DetailPost()),
        GetPage(name: "/create-place", page: () => const CreatePlace()),
        GetPage(name: "/googleMap", page: () => const GoogleMapScreen()),
      ],
    );
  }
}
