import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:votingapp/business_logics/auth.dart';
import 'package:votingapp/business_logics/phoneexistscheck.dart';
import 'package:votingapp/ui/route/route.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/widgets/big_text.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';
import 'package:get/get.dart';

import '../../../const/app_colors.dart';

class Login extends StatelessWidget {
  RxInt currentIndex = 1.obs;

  final _formKey = GlobalKey<FormState>();
  RxBool passVisibility = false.obs;
  final box = GetStorage();

  TextEditingController _email = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _pass = TextEditingController();
  final StringCheckController controller = Get.put(StringCheckController());

  Future<void> loginWithPhone(BuildContext context) async {
  final phone = _phoneController.text;

  
  final validPhoneRegex = RegExp(r'^(017|019|016|018|015|013|014)\d{8}$');

  if (phone.length != 11) {
    Fluttertoast.showToast(
      msg: 'Phone number must be exactly 11 digits.',
      backgroundColor: Colors.red,
    );
    return;
  } else if (!validPhoneRegex.hasMatch(phone)) {
    Fluttertoast.showToast(
      msg: 'Invalid phone number. ',
      backgroundColor: Colors.red,
    );
    return;
  }

  // Format the phone number
  final phonenumber = "+88$phone";

  // Call authentication or show appropriate error message
  final userId = box.read('uid');
  if (controller.stringExists.value) {
    await Auth().phoneAuthlogin(phonenumber, context);
  } else {
    Fluttertoast.showToast(
      msg: 'Please sign up first.',
      backgroundColor: Colors.red,
    );
  }
}

  //for phone

  Future<void> loginWithEmail(BuildContext context) async {
  if (_email.text.isEmpty) {
    currentIndex == 0
        ? Fluttertoast.showToast(msg: 'Phone can\'t be empty')
        : Fluttertoast.showToast(msg: 'Email can\'t be empty');
    return;
  } else if (_pass.text.length < 8) {
    Fluttertoast.showToast(msg: 'Minimum 8 characters for password');
    return;
  } else if (_pass.text.length > 12) {
    Fluttertoast.showToast(msg: 'Maximum 12 characters for password');
    return;
  }

  final phonenumber = "+88${_email.text}";

  
    if (currentIndex == 0) {
      // Assuming this method returns a boolean or handles errors internally
      await Auth().phoneAuthlogin(phonenumber, context);
    } else {
      await Auth().login(_email.text, _pass.text, context);
    }
  

  
}

  //for email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 70.h, left: 30.w, right: 30.w),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45.h,
              width: 45.w,
              child: IconButton(
                onPressed: () => Get.toNamed(loginSignUpScreen),
                icon: Icon(Icons.arrow_back_outlined),
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            //logo
            SizedBox(
              height: 20.h,
            ),
            BigText(text: 'Login to Proceed.'),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 39.h,
                child: ToggleSwitch(
                  minWidth: 140.w,
                  cornerRadius: 10.r,
                  activeBgColors: [
                    [AppColors.deepseaColor],
                    [AppColors.deepseaColor],
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: 1,
                  totalSwitches: 2,
                  labels: ['Phone', 'E-mail'],
                  radiusStyle: true,
                  onToggle: (index) {
                    print('switched to: $index');

                    currentIndex.value = index!;
                    print('cu to: $currentIndex');
                  },
                ),
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
            Obx(
              () => currentIndex == 0
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                          height: 60.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Color(0xFFA7A7A7),
                              )),
                          child: TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "this field can't be empty";
                              } else {
                                return null;
                              }
                            },
                            controller: _phoneController,
                            onChanged: (value) {
                              var couCode = "+88";
                              var fullNum = couCode + value;
                              // Trigger the search whenever the text changes
                              controller.checkIfStringExists(fullNum);
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: AppStyle().myTextForm,
                            decoration: AppStyle().textFieldDecoration(
                                'Enter Phone', Icons.call_outlined),
                          )),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Container(
                          height: 60.h,
                          width: 300.w,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              
                              border: Border.all(
                                color: Color(0xFFA7A7A7),
                              )),
                          child: TextFormField(
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "this field can't be empty";
                              } else {
                                return null;
                              }
                            },
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            style: AppStyle().myTextForm,
                            decoration: AppStyle().textFieldDecoration(
                                'Enter Email', Icons.email_outlined),
                          )),
                    ),
            ),
            //Email Input,

            SizedBox(
              height: 10.h,
            ),
            Obx(
              () => currentIndex == 1
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 60.h,
                        width: 300.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: Color(0xFFA7A7A7),
                            )),
                        child: TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "this field can't be empty";
                            } else if (val.length < 8) {
                              return "Minimum 8 Digit Password";
                            } else if (val.length > 12) {
                              return "Max 12 Digit Password";
                            } else {
                              return null;
                            }
                          },
                          obscureText: !passVisibility.value,
                          controller: _pass,
                          keyboardType: TextInputType.emailAddress,
                          style: AppStyle().myTextForm,
                          decoration: AppStyle().textFieldDecoration(
                              'Password',
                              Icons.password_outlined,
                              IconButton(
                                  onPressed: () {
                                    passVisibility.value =
                                        !passVisibility.value;
                                  },
                                  icon: Icon(
                                    Icons.visibility,
                                    color: Color(0xFFA7A7A7),
                                    size: 20.sp,
                                  ))),
                        ),
                      ),
                    )
                  : Container(),
            ),

            //Pass Input

            SizedBox(
              height: 25.h,
            ),

            DeepseaButton(
              text: 'Login',
              onAction: () async {
                currentIndex == 0
                    ? loginWithPhone(context)
                    : loginWithEmail(context);
              },
            ),
            //Button
            SizedBox(
              height: 15.h,
            ),

            RichText(
              text: TextSpan(
                  text: "Don’t Have an Account? ",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Register.',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.deepseaColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.toNamed(signUpScreen),
                    )
                  ]),
            ),
            // Register text
          ],
        ),
      ),
    ));
  }
}
