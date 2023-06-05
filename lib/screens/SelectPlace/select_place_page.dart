import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/helpers/shared.dart';
import 'package:tasty_app_v2/screens/CreatePlace/create_place_page.dart';
import 'package:tasty_app_v2/services/ApiServices.dart';

import '../../state/global_state.dart';
import '../../ui/skeleton.dart';

class SelectPlace extends StatefulWidget {
  const SelectPlace({super.key});

  @override
  State<StatefulWidget> createState() {
    return MySelectPage();
  }
}

class MySelectPage extends State<SelectPlace> {
  final GlobalController globalController = Get.find();
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _data = [];

  AppBar selectPlaceAppBar(context) {
    Timer? debounce;
    return AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                InkWell(
                  onTap: () {
                    _handleCreatePlace();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10, right: 10),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.add,
                          color: Shared.primaryColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Tạo địa điểm',
                          style: TextStyle(
                              fontSize: 12, color: Shared.primaryColor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              width: 500,
              margin:
                  const EdgeInsets.only(left: 0, right: 5, top: 15, bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const SizedBox(width: 8.0),
                  Expanded(
                      child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Tìm kiếm tên địa điểm, địa chỉ...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      debounce?.cancel();
                      debounce = Timer(const Duration(seconds: 1), () {
                        fetchData(value);
                      });
                    },
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black),
                  )),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () {
                      String searchText = _searchController.text;
                      fetchData(searchText);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget cardPlace(Map<String, dynamic> data) {
    final GlobalController ctrl = Get.find();
    return Stack(
      children: [
        InkWell(
          onTap: () {
            ctrl.setPlace(data);
            Get.back();
          },
          hoverColor: Colors.grey[400],
          child: Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      data["media"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        "${data["placeName"]}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // màu chữ của hint text
                        ),
                      ),
                    ),
                    const   SizedBox(height: 15),
                    SizedBox(
                        width: 200,
                        child: Text("${data["fullAddress"]}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // màu chữ của hint text
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget cardPlaceSkeleton() {
    return  Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const Skeleton(
                  width: 90,
                  height: 90,
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Skeleton(
                width: 220,
                height: 20,
              ),
              SizedBox(height: 15),
              Skeleton(
                width: 220,
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm gọi API để lấy data
  Future<void> fetchData(String keyword) async {
    try {
      Map<String, dynamic> data = await ApiServices().getAllPlace(keyword);

      setState(() {
        List<dynamic> response = data["response"];
        List<Map<String, dynamic>> res = [];
        for (var item in response) {
          List<dynamic> media = item["PlaceMedia"];
          res.add({
            "placeId": item["placeId"],
            "placeName": item["placeName"],
            "fullAddress": item["fullAddress"],
            "media": media[0]["url"]
          });
        }
        _data = res;
        _searchController.text = keyword;
        _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length));
      });
    } catch (e) {
      //todo add dialog
    }
  }

  void _handleCreatePlace () async{

    Map<String, dynamic>? result = await Get.to(const CreatePlace());
    if (result != null) {
      fetchData('');
    }
  }
  @override
  void initState() {
    super.initState();
    fetchData("");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.nestedKey(1),
        home: Scaffold(
            appBar: selectPlaceAppBar(context),
            body: Container(
                margin: const EdgeInsets.only(left: 15, top: 15, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text("Địa điểm",
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: Colors.black, // màu chữ của hint text
                          )),
                    ),
                    Expanded(
                      child: _data.isEmpty
                          ? ListView.builder(
                              itemCount: 6,
                              itemBuilder: (BuildContext context, int index) {
                                return cardPlaceSkeleton();
                              },
                            )
                          : ListView.builder(
                              itemCount: _data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return cardPlace(_data[index]);
                              },
                            ),
                    )
                  ],
                ))));
  }
}
