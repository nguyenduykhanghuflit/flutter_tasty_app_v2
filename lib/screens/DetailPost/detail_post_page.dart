import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../helpers/functions.dart';
import '../../models/response.dart';
import '../../services/ApiServices.dart';
import '../../ui/comment_box.dart';
import '../../ui/comment_tree.dart';

class DetailPost extends StatefulWidget {
  const DetailPost({Key? key}) : super(key: key);

  @override
  State<DetailPost> createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  late final String postId;
  Map<String, dynamic> post={};
  List<dynamic> comments=[];
  String textComment="";
  TextEditingController commentController=TextEditingController();
  Future<void> fetchData(String postId) async {
    try {
      Map<String, dynamic> data =await ApiServices().getPostById(postId);
      print(data);
      setState(() {
        post=data["response"];
      });
    } catch (e) {
      print('ở đây $e' );
    }
  }
  // Hàm gọi API để lấy data
  Future<void> fetchComment() async {
    try {
      Map<String, dynamic> data =await ApiServices().fetchComment(postId);
      print(data["response"]);
      setState(() {
        comments=data["response"];
      });
    } catch (e) {
      print('ở đây $e' );
    }
  }

  Future<void> handleComment(String postId,String content) async{
    final progressDialog = ProgressDialog(context);
    progressDialog.style(message: '....',backgroundColor: Colors.white);
    progressDialog.show();
    APIResponse response=await ApiServices().commentPost(postId,content);
    if(response.code!<0)
    {
      // ignore: use_build_context_synchronously
      progressDialog.hide();
      showNotify(context, "Đã bình luận", false);
      setState(() {
        textComment="";
        commentController.text="";
      });
      fetchComment();
    }
    else if(response.code==401){
      progressDialog.hide();
      Functions.reLogin();
    }
    else{
      progressDialog.hide();
      // ignore: use_build_context_synchronously
      showNotify(context, response.message!, true);
    }
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
  @override
  void initState() {
    super.initState();
    postId = Get.parameters['id']!;
    fetchData(postId);
    fetchComment();
  }
  @override
  Widget build(BuildContext context) {
    if (post.isNotEmpty) {
      return Scaffold(
        appBar: postDetailAppBar(context),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child:Column(
            children: [
              //slider
              ImageSlideshow(
                indicatorColor: Colors.blue,
                autoPlayInterval: 3000,
                height: 500,
                isLoop: true,
                children: post["PostMedia"]
                    .map((item) => FadeInImage(
                  placeholder:
                  const AssetImage('assets/img/noimg.png'),
                  image: NetworkImage(item["url"]),
                ))
                    .cast<Widget>()
                    .toList(),
              ),
              const SizedBox(
                height: 8,
              ),
              //đánh giá số sao
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  const  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 35,
                  ),
                  const  SizedBox(width: 5),
                  Text(
                    "${post['star']}/5",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              //title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  post['title'].toString().toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF212529)),
                    textAlign: TextAlign.left,


                ),
              ),
              const  SizedBox(
                height: 6,
              ),
              //content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  post['content'],
                  style:const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Color(0xFF212529)),
                ),
              ),
             const SizedBox(
                height: 10,
              ),
              //place box
              placeBox(post["PlacePost"]),
              const SizedBox(
                height: 10,
              ),
              //comment box
              if(comments.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   const  Padding(
                       padding:  EdgeInsets.only(left:15.0),
                       child:  Text("Tất cả bình luận của bài viết",style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color(0xFF212529)),),
                     ),
                      listComment(comments),

                    ],
                  )

              else
                commentText("Chưa có bình luận nào cho bài viết"),

              const SizedBox(
                height: 20,
              ),

            ],
          )

        ),
        bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 60,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: "Viết Bình luận.",
                          border: InputBorder.none,
                        ),
                        onChanged: (value){
                          setState(() {
                            textComment=value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if(textComment.isNotEmpty){
                          handleComment(postId, textComment);
                          //call api comment và load lại comment
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
            Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
      );
    }
  }


  AppBar postDetailAppBar(context) {
    final parsedDate = DateTime.parse(post["createdAt"]);
    String dateString = "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    String timeString = "vào lúc ${parsedDate.hour}:${parsedDate.minute}";
    String formattedString = "$dateString $timeString";
    return AppBar(
      leadingWidth: 0,
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
              },
              child: Container(
                child: Row(
                  children: [
                    const SizedBox(width: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.yellow,
                          width: 1.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(post["UserPost"]["avatar"]),
                        backgroundColor: Colors.white, // Thêm màu nền trắng để đường viền hiển thị rõ
                        radius: 25.0, // Thay đổi độ lớn của CircleAvatar
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            post["UserPost"]["fullname"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.black,fontSize: 18)
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                            formattedString,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle( color: Color(0xFF646a6c),fontSize: 13))
                      ],
                    )

                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),);
  }

  Column listComment(comments){
    return Column(
      children: comments.map((item){
        String urlImg=item["UserComment"]["avatar"];
        String fullName=item["UserComment"]["fullname"];
        String content=item["content"];
        return Padding(padding: EdgeInsets.all(10),
        child: buildCommentWidget(urlImg,fullName,content),);
      }).cast<Widget>().toList(),
    );
  }

  Widget buildCommentWidget(String avatarUrl, String username, String comment) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        // color: Colors.grey[200],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(avatarUrl),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,

              ),
            ),
            Text(
              comment,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,


              ),
            ),
          ],
        ),
        enabled: false,
        dense: true,
        contentPadding: EdgeInsets.all(0),
        horizontalTitleGap: 8,
        minVerticalPadding: 0,


      ),
    );
  }

  Container commentText(String text){
    return   Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(text,style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: Color(0xFF212529)),),
      ),
    );
}
Widget placeBox(place) {
    return Stack(
      children: [
        InkWell(
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
                  height: 100,
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      // ignore: invalid_use_of_protected_member
                      place["PlaceMedia"][0]["url"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    SizedBox(
                      width: 220,
                      child: Text(
                        // ignore: invalid_use_of_protected_member
                        "${place["placeName"]}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // màu chữ của hint text
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                        width: 220,
                        child: Text(
                          // ignore: invalid_use_of_protected_member
                            "${place["fullAddress"]}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
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



}
