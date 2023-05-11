import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'package:tasty_app_v2/models/PostDTO.dart';
import 'package:tasty_app_v2/models/response.dart';
import 'package:tasty_app_v2/state/global_state.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get_connect/http/src/multipart/form_data.dart'
    as getConnect;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import '../../helpers/functions.dart';
import './components.dart';
import '../../helpers/shared.dart';
import '../../services/ApiServices.dart';
import '../../ui/loading.dart';
import '../Auth/login_page.dart';
import '../SelectPlace/select_place_page.dart';
import 'dart:async';

// ignore: use_key_in_widget_constructors
class CreatePostPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  State<StatefulWidget> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  //global state
  final GlobalController globalController = Get.find();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  double _rating = 0;
  final ImagePicker imgPicker = ImagePicker();
  List<XFile> imageFiles = [];
  bool isLoading = false;

  Future<void> handleNavigate() async {
    String? token = await ApiServices().getToken();
    if (token == null || token == "") Get.to(const LoginPage());
  }

  @override
  void initState() {
    super.initState();
    handleNavigate();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

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

  void _submitForm(BuildContext context) async {
    final GlobalController ctrl = Get.find();
    // handle form submit
    final title = _titleController.text;
    final content = _contentController.text;
    final rating = _rating;
    // ignore: invalid_use_of_protected_member
    var placeId = ctrl.placeSelected.value["placeId"];
    if (title.isNotEmpty &&
        content.isNotEmpty &&
        rating > 0 &&
        imageFiles.isNotEmpty &&
        placeId != null) {
      final progressDialog = ProgressDialog(context);
      progressDialog.style(
          message: 'Đang đăng bài ...', backgroundColor: Colors.white);
      progressDialog.show();
      PostDTO postDTO = PostDTO(imageFiles, title, content, rating, placeId);
      APIResponse response = await ApiServices().createPost(postDTO);
      if (response.code! < 0) {
        // ignore: use_build_context_synchronously
        progressDialog.hide();
        setState(() {
          _titleController.text = '';
          _contentController.text = '';
          _rating = 0;
          ctrl.clearPlace();
          imageFiles = [];
        });
        // ignore: use_build_context_synchronously
        showNotify(context, "Đã tạo thành công bài viết", false);
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

  openImages() async {
    try {
      var pickedFiles = await imgPicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedFiles != null) {
        imageFiles = pickedFiles;
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tạo một bài đánh giá',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          //Select image
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //open button ----------------
                Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        openImages();
                      },
                      child: Image.asset(
                        'assets/img/upload.png',
                      ),
                    )),

                const Divider(),
                imageFiles != null
                    ? Wrap(
                        children: imageFiles.map((image) {
                          return Card(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.file(File(image.path)),
                            ),
                          );
                        }).toList(),
                      )
                    : Container()
              ],
            ),
          ),
          const SizedBox(height: 16),
          //form data
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  //title
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      // màu nền
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        // bo tròn đường viền
                        borderSide: BorderSide.none, // không có đường viền
                      ),
                      hintText: 'Cho review của bạn 1 tiêu đề',
                      // hiển thị hint text
                      hintStyle: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,
                        color: Colors.grey[400], // màu chữ của hint text
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  //content
                  TextField(
                    controller: _contentController,
                    maxLines: 10,
                    maxLength: 200000,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        // màu nền
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          // bo tròn đường viền
                          borderSide: BorderSide.none, // không có đường viền
                        ),
                        hintText: 'Nhập nội dung cho bài review',
                        // hiển thị hint text
                        hintStyle: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold,
                          color: Colors.grey[400], // màu chữ của hint text
                        )),
                  ),
                  const SizedBox(height: 16.0),

                  //select place
                  Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Địa điểm",
                            style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: Colors.black, // màu chữ của hint text
                            )),
                        // ignore: invalid_use_of_protected_member
                        (globalController.placeSelected.value == null ||
                                globalController.placeSelected.value.isEmpty)
                            ? Component.buttonSelectPlace
                            : Component.placeSelected()
                      ],
                    ),
                  ),
                  //rate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Đánh giá",
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: Colors.black, // màu chữ của hint text
                          )),
                      RatingBar.builder(
                        initialRating: _rating,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  //button submit
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => {_submitForm(context)},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Shared.primaryColor), // màu nền của button
                      ),
                      child: const Text(
                        'Đăng bài',
                        style: TextStyle(
                          color: Colors.white, // sử dụng màu
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
