
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/route/route.dart';
import 'package:votingapp/ui/views/auth/authentication_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  

  //final box = GetStorage();

  // Future chooseScreen() async {
  //   var userId = box.read('uid');
  //   var _phonenum = box.read('phnum');
  //   print(userId);
  //   if(userId == null){
  //     Get.toNamed(onbording);
  //    // Get.toNamed(loginSignUpScreen);
  //   }else if(_phonenum==null){
  //     Get.toNamed(userFormScreen);
  //   }
  //   else {
  //     Get.toNamed(pinLockScreen);
  //
  //
  //   }
  // }




  @override
  void initState() {
    //Future.delayed(Duration(seconds: 3),() => chooseScreen());
    Future.delayed(Duration(seconds: 2),() => Get.toNamed(loginSignUpScreen));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: AppColors.deepseaColor,
        body: Center(
          child: Container(
            //height: 170.717.h,
            //width: 172.w,
            decoration: BoxDecoration(
               //borderRadius: BorderRadius.circular(40.r),
              image: DecorationImage(
                image: AssetImage('assets/img/spalsh_screen_logo.jpeg'),
                fit: BoxFit.cover
              ),
            ),
          ),
        ),
      ),
    );
  }
}
