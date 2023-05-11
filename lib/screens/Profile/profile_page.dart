import 'package:flutter/material.dart';

import '../../ui/profile_view.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }

}


// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  List<String> posts = [
    'assets/img/1.png',
    'assets/img/2.png',
    'assets/img/3.png',
    'assets/img/4.png',
    'assets/img/5.png',
    'assets/img/6.png',
    'assets/img/7.png',
    'assets/img/8.png',
    'assets/img/9.png',
    'assets/img/10.png',
    'assets/img/11.png',
    'assets/img/12.png',
    'assets/img/13.png',
    'assets/img/14.png',
    'assets/img/1.png',
    'assets/img/2.png',
    'assets/img/3.png',
    'assets/img/4.png',
    'assets/img/5.png',
    'assets/img/6.png',
    'assets/img/7.png',
    'assets/img/8.png',
    'assets/img/9.png',
    'assets/img/10.png',
    'assets/img/11.png',
    'assets/img/12.png',
    'assets/img/13.png',
    'assets/img/14.png',
  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context,isScolled){
            return [
              const SliverAppBar(
                backgroundColor: Colors.white,
                collapsedHeight: 250,
                expandedHeight: 250,
                flexibleSpace: ProfileView(),
              ),
              SliverPersistentHeader(
                delegate: MyDelegate(
                    const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.grid_on)),
                        Tab(icon: Icon(Icons.favorite_border_outlined)),
                        Tab(icon: Icon(Icons.bookmark_border)),
                      ],
                      indicatorColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                    )
                ),
                floating: true,
                pinned: true,
              )
            ];
          },
          body: TabBarView(
            children: [1,2,3].map((tab) =>
                GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  children: posts.map((e) =>
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    e
                                ),
                                fit: BoxFit.fill
                            )
                        ),
                      )
                  ).toList(),
                )
            ).toList(),
          ),
        ),
      ),
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
