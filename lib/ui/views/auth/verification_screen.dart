import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:votingapp/business_logics/auth.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/route/route.dart';

import 'package:votingapp/ui/widgets/big_text.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';
import '../../styles/style.dart';

class EmailVerify extends StatefulWidget {
  String email;

  EmailVerify(this.email);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  final box = GetStorage();
  EmailOTP myauth = EmailOTP();

  @override
  void initState() {
    _email.text = widget.email;
    super.initState();
  }

  TextEditingController _email = TextEditingController();
  TextEditingController _otpController = TextEditingController();

 // final OTPController otpController = Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 25.h, right: 15.w, left: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                SizedBox(
                  width: 60.w,
                ),
                BigText(text: 'Verification Code')
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Enter the code we sent you',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
                height: 50.h,
                width: 400.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Color(0xFFA7A7A7),
                    )),
                child: TextFormField(
                  //validator: ((value) => EmailVal().validateEmail(value)),
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  style: AppStyle().myTextForm,
                  decoration: AppStyle()
                      .textFieldDecoration('Enter Email', Icons.email_outlined),
                )),
            SizedBox(
              height: 7.h,
            ),
            DeepseaButton(
                text: 'Sent Code',
                onAction: () async {
                  final email = _email.text.trim();
                if (email.isNotEmpty) {
                 // await otpController.sendOtp(email);
                  //Get.to(() => OTPVerificationScreen(email: widget.email));
                } else {
                  Get.snackbar('Error', 'Please enter an email', snackPosition: SnackPosition.BOTTOM);
                }
                  //var _passW = box.read('passw');
                 // Auth().registration(_email.text, _passW, context);
                  // myauth.setConfig(
                  //       appEmail: "ballotbox@ballotbox.com",
                  //       appName: "BallotBox",
                  //       userEmail: _email.text,
                  //       otpLength: 4,
                  //       otpType: OTPType.digitsOnly);
                  //   if (await myauth.sendOTP() == true) {
                  //     Fluttertoast.showToast(msg: 'OTP has been sent');
                  //     print('OTP has been sent');
                  //   } else {
                  //     Fluttertoast.showToast(msg: 'Oops, OTP send failed');
                  //     print('Oops, OTP send failed');
                  //   }

                  // EmailOTP.config(
                  //   appName: 'BallotBox',
                  //   otpType: OTPType.numeric,
                  //   expiry: 30000,
                  //   emailTheme: EmailTheme.v6,
                  //   appEmail: 'ballotbox@ballotbox.com',
                  //   otpLength: 4,
                  // );
                }),
            SizedBox(
              height: 10.h,
            ),
            PinCodeTextField(
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: AppColors.deepseaColor,
              ),
              pastedTextStyle: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: Colors.white,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],

              //backgroundColor: Colors.white,
              controller: _otpController,
              appContext: context,
              length: 4,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal),
              onChanged: (value) {},
              onCompleted: (value) {
                // EmailOtp().verifyOTP(_email.text);
                if (EmailOTP.verifyOTP(otp: value) == true) {
                  var _passW = box.read('passw');
                  Fluttertoast.showToast(msg: 'OTP is verified');
                  Future.delayed(Duration(seconds: 2), () {
                    Auth().registration(_email.text, _passW, context);
                  });
                } else {
                  Fluttertoast.showToast(msg: 'Invalid OTP');
                  print('Invalid OTP');
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
}
