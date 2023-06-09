import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:tasty_app_v2/models/PlaceDTO.dart';
import 'package:time_range/time_range.dart';
import '../../helpers/functions.dart';
import '../../helpers/shared.dart';
import '../../models/PostDTO.dart';
import '../../models/response.dart';
import '../../services/ApiServices.dart';
import '../../state/global_state.dart';
import '../Auth/login_page.dart';

class CreatePlace extends StatefulWidget {
  const CreatePlace({super.key});

  @override
  State<CreatePlace> createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlace> {
  //global state
  final GlobalController globalController = Get.put(GlobalController());
  final _placeNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phoneLength = 10;
  final ImagePicker imgPicker = ImagePicker();
  List<XFile> imageFiles = [];
  final CurrencyTextInputFormatter _minPirceFormatter =
      CurrencyTextInputFormatter(
    locale: 'vi_VN',
    decimalDigits: 0,
    symbol: 'VND ',
  );
  final CurrencyTextInputFormatter _maxPirceFormatter =
      CurrencyTextInputFormatter(
    locale: 'vi_VN',
    decimalDigits: 0,
    symbol: 'VND ',
  );

  final _items = [
    {'all': 'Tất cả'},
    {'morning': 'Ăn sáng'},
    {'afternoon': 'Ăn trưa'},
    {"cafe": 'Cà phê'},
    {'snack': 'Ăn vặt'},
    {'evening': 'Ăn tối'},
  ].map((data) => MultiSelectItem<dynamic>(data, data.values.first)).toList();
  final _multiSelectKey = GlobalKey<FormFieldState>();
  List<dynamic> _selectedCategory = [];
  dynamic rangeTime = [];
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
    final placeName = _placeNameController.text;
    final description = _descriptionController.text;
    final fullAddress = _addressController.text;
    final phone = _phoneController.text;
    final lat = 'hardcode';
    final lng = 'hardcode';
    final priceFrom = _minPirceFormatter.getUnformattedValue();
    final priceTo = _maxPirceFormatter.getUnformattedValue();
    // final timeFrom = _maxPirceFormatter.getUnformattedValue();
    // final timeTo = _maxPirceFormatter.getUnformattedValue();

    PlaceDTO placeDTO = PlaceDTO(
        imageFiles,
        placeName,
        description,
        fullAddress,
        lat,
        lng,
        priceFrom,
        priceTo,
        phone,
        rangeTime,
        rangeTime,
        _selectedCategory);

    print(placeDTO.toString());

    //imageFiles
    // ignore: invalid_use_of_protected_member
    // var placeId = ctrl.placeSelected.value["placeId"];
    // if (title.isNotEmpty &&
    //     content.isNotEmpty &&
    //     rating > 0 &&
    //     imageFiles.isNotEmpty &&
    //     placeId != null) {
    //   final progressDialog = ProgressDialog(context);
    //   progressDialog.style(
    //       message: 'Đang đăng bài ...', backgroundColor: Colors.white);
    //   progressDialog.show();
    //   PostDTO postDTO = PostDTO(imageFiles, title, content, rating, placeId);
    //   APIResponse response = await ApiServices().createPost(postDTO);
    //   if (response.code! < 0) {
    //     // ignore: use_build_context_synchronously
    //     progressDialog.hide();
    //     setState(() {
    //       _titleController.text = '';
    //       _contentController.text = '';
    //       _rating = 0;
    //       ctrl.clearPlace();
    //       imageFiles = [];
    //     });
    //     // ignore: use_build_context_synchronously
    //     showNotify(context, "Đã tạo thành công bài viết", false);
    //   } else if (response.code == 401) {
    //     progressDialog.hide();
    //     Functions.reLogin();
    //   } else {
    //     progressDialog.hide();
    //     // ignore: use_build_context_synchronously
    //     showNotify(context, response.message!, true);
    //   }
    // } else {
    //   // ignore: use_build_context_synchronously

    //   showNotify(context, "Bạn cần nhập đủ thông tin", true);
    // }
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
              'Tạo mới địa điểm',
              style: TextStyle(color: Colors.black),
            ),
          ],
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
                    controller: _placeNameController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      // màu nền
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Tên địa điểm bạn muốn tạo',
                      // hiển thị hint text
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),

                  //_descriptionController
                  TextField(
                    controller: _descriptionController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      // màu nền
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Mô tả về địa điểm ví dụ: Ẩm thực, ăn uống...',
                      // hiển thị hint text
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  //địa chỉ
                  TextField(
                    controller: _addressController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      // màu nền
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Địa chỉ của địa điểm',
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

                  //giá thấp nhất
                  TextField(
                    inputFormatters: <TextInputFormatter>[_minPirceFormatter],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      // màu nền
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Giá thấp nhất',
                      // hiển thị hint text
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),
                  //giá cao nhất
                  TextField(
                    inputFormatters: [_maxPirceFormatter],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      // màu nền
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Giá cao nhất',
                      // hiển thị hint text
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TimeRange(
                    alwaysUse24HourFormat: true,
                    fromTitle: const Text(
                      'Thời gian bán từ',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    toTitle: const Text(
                      'Đến',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    titlePadding: 20,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black87),
                    activeTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    borderColor: Colors.red,
                    backgroundColor: Colors.transparent,
                    activeBackgroundColor: Colors.orange,
                    firstTime: const TimeOfDay(hour: 00, minute: 00),
                    lastTime: const TimeOfDay(hour: 23, minute: 59),
                    timeStep: 10,
                    timeBlock: 30,
                    onRangeCompleted: (range) =>
                        setState(() => rangeTime = range),
                  ),
                  const SizedBox(height: 16.0),

                  //chọn danh mục
                  MultiSelectBottomSheetField<dynamic>(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    key: _multiSelectKey,
                    initialChildSize: 0.7,
                    maxChildSize: 0.95,
                    title: const Text("Danh mục"),
                    buttonText: Text("Chọn danh mục cho địa điểm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        )),
                    items: _items,
                    searchable: true,
                    validator: (values) {
                      if (values == null || values.isEmpty) {
                        return "Vui lòng chọn 1 danh mục";
                      }

                      return null;
                    },
                    onConfirm: (values) {
                      setState(() {
                        _selectedCategory = values;
                      });
                      _multiSelectKey.currentState?.validate();
                    },
                    chipDisplay: MultiSelectChipDisplay(
                      icon: const Icon(
                        Icons.close_outlined,
                        color: Colors.red,
                        size: 10.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      ),
                      onTap: (item) {
                        setState(() {
                          _selectedCategory.remove(item);
                        });
                        _multiSelectKey.currentState?.validate();
                      },
                    ),
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
                        'Tạo địa điểm',
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
