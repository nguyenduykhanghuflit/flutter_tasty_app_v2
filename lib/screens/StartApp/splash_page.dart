import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/shared.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Add your SplashPage UI here
          Center(
            child: Image.asset('assets/img/logo.png'),
          ),
          Positioned(
            bottom: 32.0,
            right: 32.0,
            child: GestureDetector(
                onTap: ()=> Get.to(() => const MyHomePage()),
                child: Text('Tiếp tục')),
          ),
        ],
      ),
    );
  }
}
