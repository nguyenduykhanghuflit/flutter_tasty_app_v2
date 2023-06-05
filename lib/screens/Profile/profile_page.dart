import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/ApiServices.dart';
import '../../ui/list_post.dart';
import '../../ui/list_post_skeleton.dart';
import '../../ui/profile_view.dart';
import '../../ui/skeleton.dart';
import '../Auth/login_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();

}


// ignore: must_be_immutable
class ProfilePageState extends State<ProfilePage>  {


  List<Map<String, dynamic>> posts=[];
  List<dynamic> places=[];
  int postNumber=0;
  int placeNumber=0;
  String avt='';
  String fullName='';
  String username='';
  static const List<Map<String, String>> tabs=[
    {'post': 'Bài viết'},
    {'place': 'Địa điểm'},
  ];

  Future<void> fetchData() async {

    try {
      Map<String, dynamic> data =await ApiServices().fetchPostByUser();
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
      setState(() {
        postNumber=postList.length;
        posts = postList;
      });
    } catch (e) {
      print('ở đây $e' );
    }
  }
  Future<void> fetchPlace() async {
    try {
      Map<String, dynamic> data = await ApiServices().fetchPlaceByUser();

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
        places = res;
        placeNumber=res.length;
      });
    } catch (e) {
      //todo add dialog
    }

  }
  Future<void> handleNavigate() async{
    String? token=await ApiServices().getToken();
    if(token==null||token=="") {
      Get.offAll(const LoginPage());
    } else{
      fetchData();
      fetchPlace();
      fetchInfo();
    }
  }
  Future<void> fetchInfo() async {
    try {
      Map<String, dynamic> data = await ApiServices().getUserInfo();
     Map<String,dynamic> response = data["response"];
  setState(() {
    avt=response['avatar'];
    fullName=response['fullname'];
    username=response['username'];
  });


    } catch (e) {
      print(e);
      //todo add dialog
    }

  }
  @override
  void initState() {
    handleNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context,isScolled){
            return [
               SliverAppBar(
                backgroundColor: Colors.white,
                collapsedHeight: 250,
                expandedHeight: 250,
                flexibleSpace: ProfileView(postNumber: postNumber,placeNumber: placeNumber,avt: avt,fullName: fullName, username: username,),
              ),
              SliverPersistentHeader(
                delegate: MyDelegate(
                     const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.post_add_sharp),text: 'Bài viết',),
                        Tab(icon: Icon(Icons.place_sharp),text: 'Địa điểm',),
                          ],
                      indicatorColor: Colors.amber,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.amber,
                    )
                ),
                floating: true,
                pinned: true,
              )
            ];
          },
            body: TabBarView(
              // These are the contents of the tab views, below the tabs.
              children: tabs.map((tab) =>
              tab.keys.first=='post'?
              (
                 posts.isNotEmpty? ListPost(posts: posts??[]): const ListPostSkeleton()
              ):  (
                  places.isEmpty
                      ? ListView.builder(
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return cardPlaceSkeleton();
                    },
                  )
                      : ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cardPlace(places[index]);
                    },
                  )
              )
              ).toList(),
            ),
        ),
      ),
    );
  }




  Widget cardPlace(Map<String, dynamic> data) {

    return Stack(
      children: [
        InkWell(
          onTap: () {
            // ctrl.setPlace(data);
            // Get.back();
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
                  margin:const EdgeInsets.all(15),
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
                        style:const TextStyle(
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
    return  Row(
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
    );
  }
}


class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
