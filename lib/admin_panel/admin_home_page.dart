import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:votingapp/admin_panel/candidate_screen.dart';
import 'package:votingapp/admin_panel/create_elc.dart';
import 'package:votingapp/admin_panel/my_elc.dart';
import 'package:votingapp/admin_panel/screens/alluser.dart';
import 'package:votingapp/admin_panel/screens/elction_report.dart';
import 'package:votingapp/admin_panel/widgets/custom_button.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/route/route.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';

class AdminHomePage extends StatelessWidget {
  TextEditingController _elcNameController = TextEditingController();
  TextEditingController _areacNameController = TextEditingController();
  Rx<TextEditingController> _starTimeController = TextEditingController().obs;
  Rx<TextEditingController> _endTimeController = TextEditingController().obs;

  String? startTime;
  String? endTime;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  dateTimePickerStartTime(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        DateTime selectdate = dateTime;
        final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
        print(selIOS);
        startTime = selIOS;
        _starTimeController.value.text = selIOS;
      },
    );
  }

  dateTimePickerendTime(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        DateTime selectdate = dateTime;
        final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
        print(selIOS);
        endTime = selIOS;
        _endTimeController.value.text = selIOS;
      },
    );
  }

  void logOut(context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Are You Sure To Logout?"),
              content: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Get.toNamed(loginSignUpScreen);
                      
                    },
                    child: Text("Yes"),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("No"),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
              fontSize: 23.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        centerTitle: true,
        // leading: IconButton(
        //     onPressed: () {},
        //     color: Colors.white,
        //     icon: Icon(
        //       Icons.menu_open_outlined,
        //       size: 30.sp,
        //     )),
        backgroundColor: AppColors.deepseaColor,
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       color: Colors.red,
        //       icon: Icon(
        //         Icons.exit_to_app,
        //       ))
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButtomAdminDashboard(text: 'Create Election', onAction: (){
                  showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text('Create Election'),
                            content: Container(
                              height: 300.h,
                              child: Column(
                                children: [
                                  TextFormField(
                                    //validator: ((value) => EmailVal().validateEmail(value)),
                                    controller: _elcNameController,
                                    keyboardType: TextInputType.text,
                                    style: AppStyle().myTextForm1,
                                    decoration: AppStyle().textFieldDecoration1(
                                      'Election Name',
                                    ),
                                  ),
                                  TextFormField(
                                    //validator: ((value) => EmailVal().validateEmail(value)),
                                    controller: _areacNameController,
                                    keyboardType: TextInputType.text,
                                    style: AppStyle().myTextForm1,
                                    decoration: AppStyle().textFieldDecoration1(
                                      'Election Code',
                                    ),
                                  ),
                                  TextFormField(
                                    //validator: ((value) => EmailVal().validateEmail(value)),
                                    controller: _starTimeController.value,
                                    keyboardType: TextInputType.text,
                                    style: AppStyle().myTextForm1,
                                    //readOnly: true,
                                    decoration: InputDecoration(
                                        hintText: 'Election Start Time',
                                        hintStyle: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () =>
                                                dateTimePickerStartTime(
                                                    context),
                                            icon: Icon(
                                                Icons.calendar_month_rounded))),
                                  ),
                                  TextFormField(
                                    //validator: ((value) => EmailVal().validateEmail(value)),
                                    controller: _endTimeController.value,
                                    keyboardType: TextInputType.text,
                                    style: AppStyle().myTextForm1,
                                    //readOnly: true,
                                    decoration: InputDecoration(
                                        hintText: 'Election End Time',
                                        hintStyle: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () =>
                                                dateTimePickerendTime(context),
                                            icon: Icon(
                                                Icons.calendar_month_rounded))),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  DeepseaButton(
                                      text: "Next",
                                      onAction: () async {
                                        try {
                                          CollectionReference election =
                                              FirebaseFirestore.instance
                                                  .collection('election');
                                          election
                                              .doc(_areacNameController.text)
                                              .set({
                                            'election_name':
                                                _elcNameController.text,
                                            'election_code':
                                                _areacNameController.text,
                                            'start_time': startTime,
                                            'end_time': endTime,
                                          }).whenComplete(
                                            () {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Create Election Successfully');
                                                      
                                              Get.to(CreateElection(
                                                electioncode:
                                                    _areacNameController.text,
                                              ));
                                              _elcNameController.clear();
                                                      _areacNameController.clear();
                                                      _endTimeController.value.clear();
                                                      _starTimeController.value.clear();
                                            },
                                          );
                                        } catch (e) {
                                          Fluttertoast.showToast(
                                              msg: 'error: $e');
                                        }
                                      })
                                ],
                              ),
                            ),
                          );
                        });
                }, icon: Icons.library_add),
                
                //Create Elc
                CustomButtomAdminDashboard(text: 'Election Update', onAction: ()=> Get.to(MyElc()), icon: Icons.update_outlined)
                
              ],
            ),
            //create elc
            SizedBox(height: 15.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButtomAdminDashboard(text: 'Import Members', onAction: (){}, icon: Icons.account_circle_outlined),
                CustomButtomAdminDashboard(text: 'Election Reports', onAction: ()=> Get.to(ElctionReport()), icon: Icons.pie_chart),
              ],
            ),
            SizedBox(height: 15.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButtomAdminDashboard(text: 'User Management', onAction: ()=>Get.to(UserListScreen()), icon: Icons.manage_accounts_outlined),
                CustomButtomAdminDashboard(text: 'Logout', onAction: ()=> logOut(context), icon: Icons.logout_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }
}
