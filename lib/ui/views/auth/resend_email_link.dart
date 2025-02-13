import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/route/route.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';

class ResendEmailLink extends StatelessWidget {
  const ResendEmailLink({super.key});

  Future<void> resendVerificationEmail() async {
          User? user = FirebaseAuth.instance.currentUser;
        
          if (user != null && !user.emailVerified) {
            await user.sendEmailVerification();
            print("Verification email resent.");
            Fluttertoast.showToast(msg: 'Verification email resent.');
          } else {
            print("Email already verified.");
            Fluttertoast.showToast(msg: 'Email already verified.');
          }
        }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DeepseaButton(text: "Resend link", onAction: (){
              resendVerificationEmail();
        
            }),
            SizedBox(height: 15.h,),
            RichText(
                text: TextSpan(
                    text: "Already Verify your Account?  ",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                    children: [
                  TextSpan(
                    text: 'Login.',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.deepseaColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.toNamed(loginScreen),
                  )
                ]))
          ],
        ),
      ),
    );
  }
}