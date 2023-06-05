import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ListPost extends StatelessWidget {
  final List<Map<String,dynamic>> posts;

  const ListPost({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            staggeredTileBuilder:( index)=>const StaggeredTile.fit(1),
            mainAxisSpacing: 8,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  color: Colors.white,
                  elevation:8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      String postId= posts[index]["postId"].toString();
                      Get.toNamed("/post/:id".replaceAll(':id', postId));
                      // Thực hiện hành động khi người dùng bấm vào widget
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        FadeInImage(
                          placeholder: AssetImage('assets/img/noimg.png'),
                          image: NetworkImage( posts[index]['media']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(
                            posts[index]['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                NetworkImage(posts[index]["avatar"]),
                                backgroundColor: Colors.white, // Thêm màu nền trắng để đường viền hiển thị rõ
                                radius: 20, // Thay đổi độ lớn của CircleAvatar
                              ),
                              const SizedBox(width: 8.0),
                              SizedBox(
                                width:100,
                                child: Text(
                                  posts[index]["fullName"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                      ],
                    ),
                  ));
            },


          ),
        ),
      ],
    );
  }
}

