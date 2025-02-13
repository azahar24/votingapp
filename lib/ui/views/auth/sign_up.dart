import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:votingapp/business_logics/auth.dart';
import 'package:votingapp/ui/route/route.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/views/auth/verification_screen.dart';
import 'package:votingapp/ui/widgets/big_text.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';
import 'package:get/get.dart';

import '../../../const/app_colors.dart';

class SignUp extends StatelessWidget {
  RxInt currentIndex = 1.obs;
  final box = GetStorage();

  final _formKey = GlobalKey<FormState>();
  RxBool passVisibility = false.obs;

  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  Future signUpWithPhone(context) async {
    if (_email.text.length < 11) {
      Fluttertoast.showToast(msg: 'Minimum 11 Digit phone');
    } else {
      print("ontap");
      print(_email.text);
      var c = "+88";
      var phonenumber = c + _email.text;
      print(phonenumber);

      box.write('passw', _pass.text);

      currentIndex == 0
          ? Auth().phoneAuth(phonenumber, context)
          : Get.to(EmailVerify(_email.text));
    }
  }

  Future signUpWithEmail(context) async {
  // Validate email or phone input
  if (_email.text.isEmpty) {
    Fluttertoast.showToast(
        msg: currentIndex.value == 0 ? 'Phone Can\'t be Empty' : 'Email Can\'t be Empty');
    return;
  }

  // Validate password strength
  String password = _pass.text;

  if (password.length < 8) {
    Fluttertoast.showToast(msg: 'Password must be at least 8 characters long');
    return;
  } else if (password.length > 12) {
    Fluttertoast.showToast(msg: 'Password must not exceed 12 characters');
    return;
  } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
    Fluttertoast.showToast(msg: 'Password must include at least one uppercase letter');
    return;
  } else if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
    Fluttertoast.showToast(msg: 'Password must include at least one lowercase letter');
    return;
  } else if (!RegExp(r'(?=.*[0-9])').hasMatch(password)) {
    Fluttertoast.showToast(msg: 'Password must include at least one number');
    return;
  } else if (!RegExp(r'(?=.*[!@#\$%^&*(),.?":{}|<>])').hasMatch(password)) {
    Fluttertoast.showToast(msg: 'Password must include at least one special character');
    return;
  }

  // Proceed with signup
  print("ontap");
  print(_email.text);

  // Example: Phone number formatting
  var c = "+88";
  var phonenumber = c + _email.text;
  print(phonenumber);

  box.write('passw', password);

  currentIndex.value == 0
      ? Auth().phoneAuth(phonenumber, context)
      : Auth().registration(_email.text, _pass.text, context);
}


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
              decoration: BoxDecoration(
                color: Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: IconButton(
                onPressed: () => Get.toNamed(loginSignUpScreen),
                icon: const Icon(Icons.arrow_back_outlined),
                color: Colors.white,
              ),
            ),
            //logo
            SizedBox(
              height: 20.h,
            ),
            BigText(text: 'Create an account \nNow.'),
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

            Align(
              alignment: Alignment.center,
              child: Container(
                height: 60.h,
                width: 300.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Color(0xFFA7A7A7),
                    )),
                child: Obx(() => TextFormField(
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
                          currentIndex == 0 ? 'Enter Phone' : 'Enter Email',
                          currentIndex == 0
                              ? Icons.call_outlined
                              : Icons.email_outlined),
                    )),
              ),
            ),
            //Email Input
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
                          validator: MultiValidator([
                            RequiredValidator(errorText: "* Required"),
                            MinLengthValidator(8,
                                errorText:
                                    "Password should be atleast 8 characters"),
                            PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                errorText:
                                    'passwords must have at least one special character'),
                            MaxLengthValidator(112,
                                errorText:
                                    "Password should not be greater than 12 characters")
                          ]),
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
              text: 'Continue',
              onAction: () {
                currentIndex == 0
                    ? signUpWithPhone(context)
                    : signUpWithEmail(context);
                //Auth().registration(_email.text, _pass.text, context);
              },
            ),
            SizedBox(
              height: 15.h,
            ),

            RichText(
                text: TextSpan(
                    text: "Already Have an Account?  ",
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
                ])),
          ],
        ),
      ),
    ));
  }
}
