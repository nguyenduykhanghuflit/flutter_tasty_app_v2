import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/Auth/login_page.dart';

class Functions{
 static dynamic showDialog(String title, String message)=> Get.defaultDialog(
    title: title,
    middleText: message,
    backgroundColor: Colors.grey.withOpacity(0.8),
    titleStyle: const TextStyle(color: Colors.white),
    middleTextStyle: const TextStyle(color: Colors.white),

  );

 static dynamic reLogin(){
 return  Get.defaultDialog(
     title: "Thông báo",
     middleText: "Phiên đăng nhập hết hạn, vui lòng đăng nhập lại",
     backgroundColor: Colors.grey.withOpacity(0.8),
     titleStyle: const TextStyle(color: Colors.white),
     middleTextStyle: const TextStyle(color: Colors.white),
     actions: [
       TextButton(
           child: const Text("Ok",style:  TextStyle(color: Colors.white),),
           onPressed: (){
             Get.to(const LoginPage());
           }
       ),
     ],
   );
 }

}