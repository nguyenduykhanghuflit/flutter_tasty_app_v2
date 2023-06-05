import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/screens/Profile/info_page.dart';

import '../screens/Auth/login_page.dart';
import '../services/ApiServices.dart';

class ProfileView extends StatelessWidget {
  final int postNumber;
  final int placeNumber;
  final String avt;
  final String fullName;
  final String username;

  const ProfileView({super.key,required this.postNumber,required this.placeNumber, required this.avt, required this.fullName, required this.username});
  Future<void> handleLogOut() async{
    await ApiServices().logout();
    String? token=await ApiServices().getToken();
    if(token==null||token=="") Get.to(const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
           avt!=''? CircleAvatar(
               radius: 50,
               backgroundImage:
               NetworkImage(avt)
           ):const CircleAvatar(
               radius: 50,
               backgroundImage: AssetImage('assets/img/noimg.png'),
           ) ,
              Column(
                children:  [
                  Text(
                    '$postNumber',
                    style:const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                 const SizedBox(
                    height: 4,
                  ),
               const   Text(
                      'Bài viết'
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    '$placeNumber',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const     SizedBox(
                    height: 4,
                  ),
                  const   Text(
                      'Địa điểm'
                  )
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  // handle selected value
                  if (value == "logout") {
                    handleLogOut();
                  } else if (value == "editProfile") {
                    Get.to(const InfoPage());
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "logout",
                    child: Text("Đăng xuất"),
                  ),
                  const PopupMenuItem<String>(
                    value: "editProfile",
                    child: Text("Chỉnh sửa thông tin"),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin:const EdgeInsets.only(left: 16),
          child: RichText(
            text:  TextSpan(
                children: [
                  TextSpan(
                      text: fullName,
                      style:const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      )
                  ),
                  TextSpan(
                      text: '\n@$username',
                      style:const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      )
                  ),

                ]
            ),
          ),
        ),
       const  SizedBox(height: 20,),
        Expanded(
          child: Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: const Size(0, 30),
                  side: const BorderSide(
                    color: Colors.grey,
                  )),
              onPressed: () {
              Get.to(()=>const InfoPage());
              },
              child: const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 50),
                child: Text("Chỉnh sửa thông tin", style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ),
        const  SizedBox(height: 20,),
      ],


    );
  }
}