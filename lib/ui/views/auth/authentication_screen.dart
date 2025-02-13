import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:votingapp/admin_panel/admin_home_page.dart';
import 'package:votingapp/admin_panel/login_panel.dart';
import 'package:votingapp/ui/route/route.dart';
import 'package:votingapp/ui/views/need_help.dart';
import 'package:votingapp/ui/widgets/big_text.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';

import '../../../const/app_colors.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

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
        body: Padding(
          padding: EdgeInsets.only(top: 150.h, left: 30.w, right: 30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50.r),
                      image: DecorationImage(
                        image: AssetImage('assets/img/logo.png'),
                        fit: BoxFit.cover
                        //fit: BoxFit.cover
                      ),
                    ),
                  ),
                  //logo
                  SizedBox(
                    height: 20.h,
                  ),
                  BigText(text: 'Let’s Get Started.'),
                  SizedBox(
                    height: 10.h,
                  ),
                  RichText(
                      text: TextSpan(
                          text:
                              "If you continue, you are accepting \nOur Terms & Conditions and\n",
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                          children: [
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.deepseaColor,
                          ),
                          // recognizer: TapGestureRecognizer()..onTap = () =>Get.toNamed(signUp),
                        )
                      ])),
                  SizedBox(
                    height: 60.h,
                  ),
      
                  DeepseaButton(
                    text: 'Register',
                    onAction: ()=>Get.toNamed(signUpScreen),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DeepseaButton(
                    text: 'Login',
                    onAction: ()=>Get.toNamed(loginScreen),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  InkWell(
                    onTap: () {
                     // Get.to(HomeScreenface());
                    },
                    child: InkWell(
                      onTap: () => Get.to(ContactPage()),
                      child: Container(
                        height: 25.h,
                        width: 130.w,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(30.r),
                          image: DecorationImage(
                            image: AssetImage('assets/img/needhelp.png'),
                            //fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ),
                  ),
      
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: ()=> Get.to(LoginPanel()),
                    child: Container(
                      height: 30.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.deepseaColor
                        ),
                        borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Center(
                        child: Text('Admin',style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp
                        ),),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
