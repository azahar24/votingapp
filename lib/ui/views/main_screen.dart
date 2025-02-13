import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:votingapp/business_logics/home_page_controller.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/views/home_page_nav_list/home_page.dart';
import 'package:votingapp/ui/views/home_page_nav_list/profile.dart';
import 'package:votingapp/ui/views/home_page_nav_list/result_screen.dart';
import 'package:votingapp/ui/views/home_page_nav_list/vote_screen.dart';


class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var min = Get.put(HomePageController());

  @override
  void initState() {

    min.resetTimer();
    

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    min.timer?.cancel();
    super.dispose();
  }

  final _pages = [
    HomeScreen(),
    Vote(),
    Result(),
    ProfileScreen(),
  ];

  int _currntinx = 0;

  Future _exitDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure to close this app?"),
            content: Row(
              children: [
                ElevatedButton(
                  onPressed: ()=>Get.back(),
                  child: Text("No"),
                ),
                SizedBox(
                  width: 20.w,
                ),
                ElevatedButton(
                  onPressed: ()=>SystemNavigator.pop(),
                  child: Text("Yes"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didPop) {

        _exitDialog(context);
      }),

      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFF3F3D9B),
         unselectedItemColor: Color(0xFFA898F6),
          backgroundColor: AppColors.deepseaColor,
          selectedIconTheme: IconThemeData(size: 40.r),
          unselectedIconTheme: IconThemeData(size: 20.r),
          currentIndex: _currntinx,
          onTap: (int index) {
            setState(() {
              _currntinx = index;
              min.resetTimer();
      
              
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: AppColors.deepseaColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.where_to_vote_outlined),
              label: "Vote",
              backgroundColor: AppColors.deepseaColor,
            ),
            BottomNavigationBarItem(
              icon:  Icon(Icons.done_all_outlined),
              label: "Result",
              backgroundColor: AppColors.deepseaColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded),
              label: "Profile",
              backgroundColor: AppColors.deepseaColor,
            ),
          ],
        ),
        body: _pages[_currntinx],
      ),
    );
  }
}
