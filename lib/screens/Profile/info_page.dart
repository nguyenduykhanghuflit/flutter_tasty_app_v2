import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:tasty_app_v2/screens/Profile/profile_page.dart';
import '../../helpers/functions.dart';
import '../../helpers/shared.dart';
import '../../models/response.dart';
import '../../services/ApiServices.dart';
import '../Auth/login_page.dart';
import 'change_password.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  //global state
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
   String? urlImg=null;
  final _phoneLength = 10;
  final ImagePicker imgPicker = ImagePicker();
  File? _image;
  Map<String,dynamic> info={};
  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> handleNavigate() async {
    String? token = await ApiServices().getToken();
    if (token == null || token == "") Get.to(const LoginPage());
  }

  Future<void> fetchInfo() async {
    try {
      Map<String, dynamic> data = await ApiServices().getUserInfo();
      Map<String,dynamic> response = data["response"];
      _fullNameController.text=response['fullname'];
      _emailController.text=response['email'];
      _phoneController.text=response['phone'];
      setState(() {
        info=response;
        urlImg=response['avatar'];
      });


    } catch (e) {
      print(e);
      //todo add dialog
    }

  }

  void _handleUpdateInfo(BuildContext context) async {

    if (_fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty ){
      final progressDialog = ProgressDialog(context);
      progressDialog.style(
          message: 'Đang cập nhật', backgroundColor: Colors.white);
      progressDialog.show();
      APIResponse response = await ApiServices().updateInfoUser(_fullNameController.text,_emailController.text,_phoneController.text,_image);
      if (response.code! < 0) {
        // ignore: use_build_context_synchronously
        progressDialog.hide();
        fetchInfo();
        // ignore: use_build_context_synchronously
        showNotify(context, "Update thành công", false);
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
    fetchInfo();
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
              'Chỉnh sửa thông tin',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          //Select image
        Column(
          children: [
          Stack(
            children: [
            Container(
            width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: _image != null
                    ? DecorationImage(
                  image: FileImage(_image!),
                  fit: BoxFit.cover,
                )
                    :(urlImg!=null? DecorationImage(
                  image:NetworkImage(urlImg!),
                  fit: BoxFit.cover,
                ):const DecorationImage(
                  image:AssetImage('assets/img/noimg.png'),
                  fit: BoxFit.cover,
                )),
              ),
            ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon:const Icon(Icons.edit),
                    onPressed: _getImage,
                    color: Colors.amber,
                    iconSize: 20
                  ),
                ),
              ),
          ]),
          ],
        ),
          const SizedBox(height: 20),
          //form data
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                //fullName
                TextField(
                  controller: _fullNameController,
                  maxLength: 255,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    // màu nền
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Họ và tên',
                    // hiển thị hint text
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                  //email
                TextField(
                  controller: _emailController,
                  maxLength: 255,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    // màu nền
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Email',
                    // hiển thị hint text
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                //phone
                TextField(
                  controller: _phoneController,
                  maxLength: _phoneLength,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    // màu nền
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Nhập số điện thoại',
                    // hiển thị hint text
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
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
                          'Cập nhât thông tin',
                          style: TextStyle(
                            color: Colors.white, // sử dụng màu
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => {
                         Get.to(const ChangePasswordPage())
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Shared.secondaryColor), // màu nền của button
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
