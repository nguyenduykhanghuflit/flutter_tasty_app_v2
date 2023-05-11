
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/screens/Auth/register_page.dart';
import 'package:tasty_app_v2/services/ApiServices.dart';

import '../../helpers/shared.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final usController=TextEditingController();
  final pwController=TextEditingController();

  bool _obscureText = true;
  void handleLogin(){
  String us=usController.text;
  String pw=pwController.text;

  if(us.isEmpty || pw.isEmpty){
    Get.defaultDialog(
      title: "Thông báo",
      middleText: "Vui lòng nhập tên đăng nhập và mật khẩu",
      backgroundColor: Colors.grey.withOpacity(0.8),
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
    );
  }
  else{
    ApiServices().login(us, pw);
  }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
                child:Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/img/logo2.png'),
                      TextField(
                        controller: usController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          // màu nền
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            // bo tròn đường viền
                            borderSide: BorderSide.none, // không có đường viền
                          ),
                          hintText: 'Tên đăng nhập',
                          // hiển thị hint text
                          hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: Colors.grey[400], // màu chữ của hint text
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        keyboardType: TextInputType.visiblePassword,
                          obscureText:_obscureText,

                        inputFormatters: [
                          LengthLimitingTextInputFormatter(8)
                        ],
                        controller: pwController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          // màu nền
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            // bo tròn đường viền
                            borderSide: BorderSide.none, // không có đường viền
                          ),
                          hintText: 'Mật khẩu',
                          // hiển thị hint text
                          hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: Colors.grey[400], // màu chữ của hint text
                          ),
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      SizedBox(
                        width: 400,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => {
                            handleLogin()
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Shared.primaryColor), // màu nền của button
                          ),
                          child: const Text(
                            'Đăng nhập',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17// sử dụng màu
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Chưa có tài khoản ?",style:TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          )),
                          GestureDetector(
                            onTap: () {
                              Get.to(RegisterPage());
                            },
                            child: Text("Đăng ký",style:TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: Shared.primaryColor,
                            )),
                          )

                        ],
                      ),
                    ],
                  ),
                )
            )
          ],

        ),
      )
    );
  }
}
