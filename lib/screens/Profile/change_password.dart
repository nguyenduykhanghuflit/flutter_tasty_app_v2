import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:tasty_app_v2/screens/Profile/profile_page.dart';
import '../../helpers/functions.dart';
import '../../helpers/shared.dart';
import '../../models/response.dart';
import '../../services/ApiServices.dart';
import '../Auth/login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  //global state
  final _rePassword= TextEditingController();
  final _newPassword = TextEditingController();
  bool _obscureText = true;
  Future<void> handleNavigate() async {
    String? token = await ApiServices().getToken();
    if (token == null || token == "") Get.to(const LoginPage());
  }



  void _handleUpdateInfo(BuildContext context) async {

    if (_rePassword.text.isNotEmpty &&
        _newPassword.text.isNotEmpty ){
      final progressDialog = ProgressDialog(context);
      progressDialog.style(
          message: 'Đang đổi mật khẩu', backgroundColor: Colors.white);
      progressDialog.show();
      APIResponse response = await ApiServices().updatePassword(_rePassword.text,_newPassword.text);
      if (response.code! < 0) {
        // ignore: use_build_context_synchronously
        progressDialog.hide();
        _rePassword.text='';
        _newPassword.text='';
        setState(() {
          _obscureText=true;
        });
        // ignore: use_build_context_synchronously
        showNotify(context, "Đổi mật khẩu thành công", false);
      } else if (response.code == 401) {
        progressDialog.hide();
        Functions.reLogin();
      } else {
        progressDialog.hide();
        // ignore: use_build_context_synchronously
        showNotify(context, response.message!, true);
      }
    } else {
      // ignore: use_build_context_synchronously
      showNotify(context, "Bạn cần nhập đủ thông tin", true);
    }
  }


  @override
  void initState() {
    super.initState();
    handleNavigate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showNotify(BuildContext context, String message, bool isErr) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isErr ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // void _submitForm(BuildContext context) async {
  //   // handle form submit
  //   final placeName = _placeNameController.text;
  //   final description = _descriptionController.text;
  //   final fullAddress = _addressController.text;
  //   final phone = _phoneController.text;
  //   double lat =latLngInit.latitude;
  //   double lng = latLngInit.longitude;
  //   final priceFrom = _minPriceFormatter.getUnformattedValue();
  //   final priceTo = _maxPriceFormatter.getUnformattedValue();
  //
  //
  //   PlaceDTO placeDTO = PlaceDTO(
  //       imageFiles,
  //       placeName,
  //       description,
  //       fullAddress,
  //       lat.toString(),
  //       lng.toString(),
  //       priceFrom,
  //       priceTo,
  //       phone,
  //       rangeTime?.start.format(context),
  //       rangeTime?.end.format(context),
  //       _selectedCategory);
  //   final progressDialog = ProgressDialog(context);
  //   progressDialog.style(
  //       message: 'Đang tạo địa điểm ...', backgroundColor: Colors.white);
  //   progressDialog.show();
  //   APIResponse response = await ApiServices().createPlace(placeDTO);
  //   if (response.code! < 0) {
  //     progressDialog.hide();
  //     // ignore: use_build_context_synchronously
  //     showNotify(context, "Đã tạo thành công", false);
  //     Get.back(result: {"address": 'aa', "latLng": 'aa'});
  //   } else if (response.code == 401) {
  //     progressDialog.hide();
  //     Functions.reLogin();
  //   } else {
  //     progressDialog.hide();
  //     // ignore: use_build_context_synchronously
  //     showNotify(context, response.message!, true);
  //
  //   }
  // }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            const Text(
              'Đổi mật khẩu',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          //Select image
          //form data
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText,
                  inputFormatters: [LengthLimitingTextInputFormatter(8)],
                  controller: _rePassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
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

                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Mật khẩu cũ',
                    // hiển thị hint text
                    hintStyle: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: Colors.grey[400], // màu chữ của hint text
                    ),
                  ),
                ),
              const SizedBox(height: 16,),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText,
                  inputFormatters: [LengthLimitingTextInputFormatter(8)],
                  controller: _newPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
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

                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Mật khẩu mới',
                    // hiển thị hint text
                    hintStyle: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: Colors.grey[400], // màu chữ của hint text
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                //button submit
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => {
                          _handleUpdateInfo(context)
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Shared.primaryColor), // màu nền của button
                        ),
                        child: const Text(
                          'Đổi mật khẩu',
                          style: TextStyle(
                            color: Colors.white, // sử dụng màu
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
