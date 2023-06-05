import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/helpers/shared.dart';
import 'package:tasty_app_v2/services/ApiServices.dart';
import '../../state/global_state.dart';
import '../../ui/list_post.dart';
import '../../ui/skeleton.dart';

class SearchPost extends StatefulWidget {
  const SearchPost({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchPostState();
  }
}

class SearchPostState extends State<SearchPost> {
  final GlobalController globalController = Get.find();
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> posts = [];
  String textResult = "Tìm kiếm gần đây";
  // Hàm gọi API để lấy data
  Future<void> fetchData(String keyword) async {
    try {
      Map<String, dynamic> data = await ApiServices().searchPost(keyword);
      setState(() {
        List<dynamic> response = data["response"];
        List<Map<String, dynamic>> res = [];
        for (var item in response) {
          List<dynamic> media = item["PostMedia"];
          Map<String, dynamic> userPost = item["UserPost"];
          res.add({
            "postId": item["postId"],
            "content": item["content"],
            "title": item["title"],
            "fullName": userPost["fullname"],
            "avatar": userPost["avatar"],
            "media": media[0]["url"]
          });
        }
        posts = res;
        if (keyword != "") {
          textResult = 'Kết quả tìm kiếm cho "$keyword"';
        } else {
          textResult = 'Tìm kiếm gần đây';
        }
      });
    } catch (e) {
      print('ở đây $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData('');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: searchPostAppbar(context),
            body: Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(textResult,
                        style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold,
                          color: Colors.black, // màu chữ của hint text
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: ListPost(
                      posts: posts,
                    ))
                  ],
                ))));
  }

  AppBar searchPostAppbar(context) {
    Timer? debounce;
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      title: Row(
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
          Container(
            width: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                const SizedBox(width: 8.0),
                Expanded(
                    child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Tìm kiếm bài viết",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: 200), () {
                      fetchData(value);
                    });
                  },
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
      ),
    );
  }
}
