import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:votingapp/business_logics/encrypt_data.dart';
import 'package:votingapp/ui/route/route.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';


class PinLock extends StatefulWidget {
  @override
  State<PinLock> createState() => _PinLockState();
}

class _PinLockState extends State<PinLock> {
  final _formKey = GlobalKey<FormState>();
  final box = GetStorage();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool passVisibility = false.obs;

  TextEditingController _pinController = TextEditingController();

  late String _oldPin;

  @override
  void initState() {
    try {
      

      FirebaseFirestore.instance
          .collection('user-form-data')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        setState(() {
          _oldPin = value.data()!['pin'];
          print(_oldPin);
        });
      });
    } catch (err) {
      print(err.runtimeType);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Color(0xFF161730),
        body: Padding(
          padding: EdgeInsets.only(top: 25.h, right: 15.w, left: 15.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Let’s Unlock',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),

                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(() => TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _pinController,
                    maxLength: 5,
                    obscureText: !passVisibility.value,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "this field can't be empty";
                      } else if (val.length < 5) {
                        return "Minimum 5 Digit Pin";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Pin',
                      suffixIcon: IconButton(
                          onPressed: () {
                            passVisibility.value = !passVisibility.value;
                          },
                          icon: Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 15.sp,
                          )),
                      filled: true,
                      fillColor: Color(0xFF202244),
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none),
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),),
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 32.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: Colors.white),
                      child: Center(
                        child: Text(
                          'Forget Pin',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFF030303),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  DeepseaButton(text: 'Submit', onAction: (){
                    final decrypted_pin = MyEncryptionDecryption.encrypter.decrypt64(_oldPin, iv: MyEncryptionDecryption.iv);
                        print(_oldPin);
                        int _pin = int.parse(_pinController.text);
                        print(_pin);
                        int _oldpinlast = int.parse(decrypted_pin);
                        print(_oldpinlast);
                        var output = (_oldpinlast == _pin)
                            ? Get.toNamed(homeScreen)
                            : Fluttertoast.showToast(
                                msg: 'wrong Pin', textColor: Colors.red);
                        print(output);
                     
                    
                  }),
                  
                  SizedBox(
                    height: 10.h,
                  ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: RichText(
                  //       text: TextSpan(
                  //           text: "Don’t have registered yet? ",
                  //           style: TextStyle(
                  //               fontSize: 13.sp,
                  //               fontWeight: FontWeight.w300,
                  //               color: Colors.white),
                  //           children: [
                  //         TextSpan(
                  //           text: 'Sign Up',
                  //           style: TextStyle(
                  //             fontSize: 13.sp,
                  //             fontWeight: FontWeight.w600,
                  //             color: Color(0xFFA898F6),
                  //           ),
                  //           recognizer: TapGestureRecognizer()
                  //             ..onTap = () => Get.toNamed(signUpScreen),
                  //         )
                  //       ])),
                  // ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
