import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/screens/SearchPost/search_post_page.dart';
import 'package:tasty_app_v2/ui/list_post.dart';
import '../../helpers/shared.dart';
import '../../services/ApiServices.dart';
import '../../state/global_state.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../ui/list_post_skeleton.dart';
import '../../ui/skeleton.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home page',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //todo later: call api get catalog
  static const List<Map<String, String>> tabs=[
    {'all': 'Tất cả'},
    {'morning': 'Ăn sáng'},
    {'afternoon': 'Ăn trưa'},
    {"cafe": 'Cà phê'},
    {'snack': 'Ăn vặt'},
    {'evening': 'Ăn tối'},
  ];

  //All post by catalog
  Map<String,List<Map<String, dynamic>>> posts={};

  //Fetch post by catalog
  Future<void> fetchData() async {

    try {
      Map<String,List<Map<String, dynamic>>> res={};
      for (var tab in tabs) {
       Map<String, dynamic> data =await ApiServices().fetchPost(tab.keys.first);
        List<dynamic> response=data["response"];
        List<Map<String, dynamic>> postList=[];
        for (var item in response) {
         List<dynamic> media= item["PostMedia"];
         Map<String,dynamic> userPost=item["UserPost"];
         postList.add({
           "postId":item["postId"],
           "content":item["content"],
           "title":item["title"],
           "fullName":userPost["fullname"],
           "avatar":userPost["avatar"],
           "media":media[0]["url"]
         });
       }
        res[tab.keys.first]= postList;
     }

      setState(() {
        posts = res;
      });
    } catch (e) {
      print('ở đây $e' );
    }
  }


@override
  void initState() {
   fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: tabs.length, // This is the number of tabs.
      child: Scaffold(
        appBar: homeAppBar(context),
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                collapsedHeight: 200,
                expandedHeight: 200,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ImageSlideshow(
                    indicatorColor: Colors.blue,
                    autoPlayInterval: 3000,
                    isLoop: true,
                    children: [
                      Image.asset(
                        'assets/img/slide1.jpeg',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/img/slide2.jpeg',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/img/slide3.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                  floating: true,
                  pinned: true,
                  delegate: MyDelegate(
                    TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: tabs
                          .map(
                            (Map<String, String> tab) => Text(
                          tab.values.first,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      )
                          .toList(),
                      labelColor: Shared.primaryColor,
                      unselectedLabelColor: Colors.teal,
                      indicatorColor: Shared.primaryColor,
                    ),
                  )),
            ];
          },
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: tabs.map((tab) =>
            posts.isNotEmpty?
            ListPost(posts: posts[tab.keys.first]??[]):
            const ListPostSkeleton()

            ).toList(),
          ),
        ),
      ),
    );
  }


  AppBar homeAppBar(context) {
    return AppBar(
      toolbarHeight: 70,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        title: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 8.0),
               Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(const SearchPost());
                    },
                    child:const TextField(
                      enabled:false,
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm bài viết...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  )),
               IconButton(
                icon: const Icon(Icons.search, color: Colors.grey),
                onPressed: () {
                  Get.to(const SearchPost());
                },
              ),
            ],
          ),
        ));

  }





}





class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: 200,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}






