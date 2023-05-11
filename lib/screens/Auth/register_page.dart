
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/screens/Auth/login_page.dart';

import '../../helpers/shared.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _obscureText=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: Expanded(
            child: ListView(
              children: [
                SizedBox(
                  child: Image.asset('assets/img/logo2.png'),
                ),
                //họ tên
                TextField(
                  /*controller: _titleController,*/
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    // màu nền
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      // bo tròn đường viền
                      borderSide: BorderSide.none, // không có đường viền
                    ),
                    hintText: 'Họ và tên',
                    // hiển thị hint text
                    hintStyle: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: Colors.grey[400], // màu chữ của hint text
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                //tên đăng nhập
                TextField(
                  /*controller: _titleController,*/
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
                const SizedBox(height: 10.0),
                //mật khẩu
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText:_obscureText,

                  inputFormatters: [
                    LengthLimitingTextInputFormatter(8)
                  ],

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
                  /*controller: _titleController,*/
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
                    onPressed: () => {
                      /*  _formIsValid
                        ? _submitForm(context)
                        : showNotify(
                        context, "Bạn cần nhập đủ thông tin", true),*/
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Shared.primaryColor), // màu nền của button
                    ),
                    child: const Text(
                      'Đăng ký',
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
                    Text("Đã có tài khoản ?",style:TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    )),
                    GestureDetector(
                      onTap: () {
                       Get.to(LoginPage());
                      },
                      child: Text("Đăng nhập",style:TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,
                        color: Shared.primaryColor,
                      )),
                    )

                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
