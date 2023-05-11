import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/screens/Auth/login_page.dart';
import 'package:tasty_app_v2/screens/CreatePlace/create_place_page.dart';
import 'package:tasty_app_v2/screens/DetailPost/detail_post_page.dart';
import 'package:tasty_app_v2/screens/StartApp/main_page.dart';
import 'package:tasty_app_v2/screens/Auth/register_page.dart';
import 'screens/StartApp/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/startUp",
      getPages: [
        GetPage(name: "/startUp", page: () => const SplashPage()),
        GetPage(name: "/login", page: () => const LoginPage()),
        GetPage(name: "/register", page: () => const RegisterPage()),
        GetPage(name: "/main", page: () => const MyHomePage()),
        GetPage(name: "/post/:id", page: () => const DetailPost()),
        GetPage(name: "/create-place", page: () => const CreatePlace()),
      ],
    );
  }
}
