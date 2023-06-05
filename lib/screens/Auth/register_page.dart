import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:tasty_app_v2/screens/Auth/login_page.dart';

import '../../helpers/shared.dart';
import '../../services/ApiServices.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usController = TextEditingController();
  final pwController = TextEditingController();
  final fnController = TextEditingController();
  final phoneController = TextEditingController();
  bool _obscureText = true;
  final FocusNode _focus = FocusNode();
  void handleRegister() {
    _focus.unfocus();
    String fn = fnController.text;
    String us = usController.text;
    String pw = pwController.text;
    String phone = phoneController.text;

    if (us.isEmpty || pw.isEmpty||phone.isEmpty||fn.isEmpty) {
      Get.defaultDialog(
        title: "Thông báo",
        middleText: "Vui lòng nhập đầy đủ thông tin",
        backgroundColor: Colors.grey.withOpacity(0.8),
        titleStyle: const TextStyle(color: Colors.white),
        middleTextStyle: const TextStyle(color: Colors.white),
      );
    } else {
      ApiServices().register(fn,us,pw,phone);
      fnController.text='';
      usController.text='';
      pwController.text='';
      phoneController.text='';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const SizedBox(
            height: 90,
          ),
          SizedBox(
            child: Image.asset('assets/img/logo2.png'),
          ),
          //họ tên
          TextField(
            controller: fnController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              // màu nền
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              hintText: 'Họ và tên',
              hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
                color: Colors.grey[400], // màu chữ của hint text
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          //tên đăng nhập
          TextField(
            controller: usController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              // màu nền
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),

                borderSide: BorderSide.none,
              ),
              hintText: 'Tên đăng nhập',
              // hiển thị hint text
              hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
                color: Colors.grey[400], // màu chữ của hint text
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          //mật khẩu
          TextField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureText,
            controller: pwController,
            inputFormatters: [LengthLimitingTextInputFormatter(8)],
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
          const SizedBox(height: 10.0),
          //sdt
          TextField(
            keyboardType: TextInputType.number,
            focusNode: _focus,
            controller: phoneController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              // màu nền
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                // bo tròn đường viền
                borderSide: BorderSide.none, // không có đường viền
              ),
              hintText: 'Số điện thoại',
              // hiển thị hint text
              hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
                color: Colors.grey[400], // màu chữ của hint text
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          //đăng ký
          SizedBox(
            width: 400,
            height: 60,
            child: ElevatedButton(
              onPressed: () => {handleRegister()},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Shared.primaryColor), // màu nền của button
              ),
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17 // sử dụng màu
                    ),
              ),
            ),
          ),

          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Đã có tài khoản ?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  )),
              GestureDetector(
                onTap: () {
                  Get.to(const LoginPage());
                },
                child: const Text("Đăng nhập",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Shared.primaryColor,
                    )),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
