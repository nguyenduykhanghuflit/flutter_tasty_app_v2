import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/services/ApiServices.dart';

import '../screens/Auth/login_page.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Future<void> handleLogOut() async{
    await ApiServices().logout();
  }
  Future<void> handleNavigate() async{
    String? token=await ApiServices().getToken();
    if(token==null||token=="") Get.to(const LoginPage());
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    Container(
    margin: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    Column(
    children: const [
    Text(
    '30',
    style: TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(
    height: 4,
    ),
    Text('Posts'),
    ],
    ),
    Column(
    children: const [
    Text(
    '130k',
    style: TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(
    height: 4,
    ),
    Text('Followers'),
    ],
    ),
    Column(
    children: const [
    Text(
    '130k',
    style: TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(
    height: 4,
    ),
    Text('Following'),
    ],
    ),
    ElevatedButton(
    onPressed: () {
        handleLogOut();
    },
    child: const Text('Logout'),
    ),
    ],
    ),
    )
      /*  Container(
          margin: const EdgeInsets.only(left: 16),
          child: RichText(
            text: const TextSpan(
                children: [
                  TextSpan(
                      text: 'Dev Clips',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      )
                  ),
                  TextSpan(
                      text: '\nFlutter Demo\nFlutter Web\nFlutter Linux',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14
                      )
                  )
                ]
            ),
          ),
        )*/
      ],
    );
  }
}