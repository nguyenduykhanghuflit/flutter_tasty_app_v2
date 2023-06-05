import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasty_app_v2/screens/GoogleMap/google_map.dart';
import 'package:tasty_app_v2/screens/Profile/profile_page.dart';
import 'package:tasty_app_v2/state/global_state.dart';

import '../../helpers/shared.dart';
import '../CreatePost/create_post_page.dart';
import '../Home/home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  //for tab bar
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    CreatePostPage(),
    const ProfilePage(),
    //GoogleMapScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalController globalController = Get.put(GlobalController());
    return Scaffold(

      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          //  color: Color(0xff343442),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          // selectedItemColor: const Color(0xff343442),
          // unselectedItemColor: Colors.grey,
          unselectedItemColor: Shared.secondaryColor,
          selectedItemColor: Shared.primaryColor,
          selectedIconTheme: const IconThemeData(size: 30),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 30),
              label: '',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person, size: 30),
            //   label: '',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}


// bottomNavigationBar: Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(25.0),
//             topRight: Radius.circular(25.0),
//           ),
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//                 icon: Icon(FontAwesomeIcons.fileLines), label: 'Deals'),
//             BottomNavigationBarItem(
//                 icon: Icon(FontAwesomeIcons.fileCircleCheck), label: 'Quotes'),
//             BottomNavigationBarItem(
//                 icon: Icon(FontAwesomeIcons.listUl), label: 'Tasks'),
//             BottomNavigationBarItem(
//                 icon: Icon(FontAwesomeIcons.user), label: 'Info'),
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: const Color(0xff343442),
//           unselectedItemColor: Colors.grey,
//           onTap: _onItemTapped,
//         ),
//       ),