import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/widgets/big_text.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';
import 'package:get/get.dart';
import '../ui/route/route.dart';

class LoginPanel extends StatefulWidget {
  @override
  State<LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<LoginPanel> {
  RxInt currentIndex = 0.obs;
  RxBool passVisibility = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _userController = TextEditingController();

  TextEditingController _passController = TextEditingController();

  late String _1stusername;
  late String _1stpass;

  late String _2ndusername;
  late String _2ndpass;

  late String _3rdusername;
  late String _3rdpass;

  @override
  void initState() {
    try {
      FirebaseFirestore.instance
          .collection('admin-panel')
          .doc('user1')
          .get()
          .then((value) {
        setState(() {
          _1stusername = value.data()!['username'];
          _1stpass = value.data()!['pass'];
          print(_1stusername);
          print(_1stpass);
        });
      });
      //1st user data get
      FirebaseFirestore.instance
          .collection('admin-panel')
          .doc('user2')
          .get()
          .then((value) {
        setState(() {
          _2ndusername = value.data()!['username'];
          _2ndpass = value.data()!['pass'];
          print(_2ndusername);
          print(_2ndpass);
        });
      });
      //2nd user data get
      FirebaseFirestore.instance
          .collection('admin-panel')
          .doc('user3')
          .get()
          .then((value) {
        setState(() {
          _3rdusername = value.data()!['username'];
          _3rdpass = value.data()!['pass'];
          print(_3rdusername);
          print(_3rdpass);
        });
      });
      //3rd user data get
    } catch (err) {
      print(err.runtimeType);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 70.h, left: 30.w, right: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45.h,
            width: 45.w,
            child: IconButton(
              onPressed: () {
                Get.toNamed(loginSignUpScreen);
              },
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
          BigText(text: 'ADMIN PANEL'),
          Text(
            'Control panel login',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w300,
                color: Colors.black54),
          ),
          SizedBox(
            height: 10.h,
          ),

          SizedBox(
            height: 35.h,
          ),

          Align(
            alignment: Alignment.center,
            child: Container(
              height: 55.h,
              width: 300.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Color(0xFFA7A7A7),
                  )),
              child: TextFormField(
                //validator: ((value) => EmailVal().validateEmail(value)),
                controller: _userController,
                keyboardType: TextInputType.name,
                style: AppStyle().myTextForm,
                decoration: AppStyle()
                    .textFieldDecoration('User name', Icons.person_pin),
              ),
            ),
          ),
          //Email Input
          SizedBox(
            height: 10.h,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 55.h,
              width: 300.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Color(0xFFA7A7A7),
                  )),
              child: Obx(() => TextFormField(
                    //validator: ((value) => EmailVal().validateEmail(value)),
                    controller: _passController,
                    obscureText: !passVisibility.value,
                    keyboardType: TextInputType.visiblePassword,
                    style: AppStyle().myTextForm,
                    decoration: AppStyle().textFieldDecoration(
                        'Password',
                        Icons.password_outlined,
                        IconButton(
                            onPressed: () {
                              passVisibility.value = !passVisibility.value;
                            },
                            icon: Icon(
                              Icons.visibility,
                              color: Color(0xFFA7A7A7),
                              size: 20.sp,
                            ))),
                  )),
            ),
          ),
          //Pass Input

          SizedBox(
            height: 25.h,
          ),

          DeepseaButton(
            text: 'Login',
            onAction: () {
              if (_1stusername == _userController.text &&
                      _1stpass == _passController.text ||
                  _2ndusername == _userController.text &&
                      _2ndpass == _passController.text ||
                  _3rdusername == _userController.text &&
                      _3rdpass == _passController.text) {
                Get.toNamed(adminhomepageScreen);
                Fluttertoast.showToast(msg: 'Login Successfull');
              } else {
                Fluttertoast.showToast(
                    msg: 'wrong info', textColor: Colors.red);
              }
            },
          ),
        ],
      ),
    ));
  }
}
