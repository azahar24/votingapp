import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:votingapp/business_logics/user_data_db.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/widgets/big_text.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';
import 'package:get/get.dart';

import '../../../const/app_colors.dart';

class UserFormEmail extends StatelessWidget {
  RxInt currentIndex = 0.obs;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _voteridController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  Rx<TextEditingController> _dobController = TextEditingController().obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  String? dob;
  String gender = "Male";

  _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1950),
      lastDate: DateTime(2026),
    );

    if (selected != null && selected != selectedDate) {
      dob = "${selected.day} - ${selected.month} - ${selected.year}";
      _dobController.value.text = dob!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 70.h, left: 30.w, right: 30.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   height: 45.h,
            //   width: 45.w,
            //   child: IconButton(
            //     onPressed: () {},
            //     icon: Icon(Icons.arrow_back_outlined),
            //     color: Colors.white,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFC4C4C4),
            //     borderRadius: BorderRadius.circular(25.r),
            //   ),
            // ),
            //logo
            SizedBox(
              height: 20.h,
            ),
            BigText(text: 'Tell Us More About You.'),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'We will not share your information outside this application.',
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
            SizedBox(
              height: 35.h,
            ),

            SizedBox(
              height: 15.h,
            ),
            TextFormField(
              //validator: ((value) => EmailVal().validateEmail(value)),
              controller: _nameController,
              keyboardType: TextInputType.text,
              style: AppStyle().myTextForm1,
              decoration: AppStyle().textFieldDecoration1(
                'Full Name',
              ),
            ),
            TextFormField(
              //validator: ((value) => EmailVal().validateEmail(value)),
              controller: _voteridController,
              inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
              keyboardType: TextInputType.number,
              style: AppStyle().myTextForm1,
              decoration: AppStyle().textFieldDecoration1(
                'Voter ID',
              ),
            ),

            TextFormField(
              //validator: ((value) => EmailVal().validateEmail(value)),
              controller: _phoneController,
              inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
              keyboardType: TextInputType.phone,
              style: AppStyle().myTextForm1,
              decoration: AppStyle().textFieldDecoration1(
                'Phone Number',
              ),
            ),
            TextFormField(
              //validator: ((value) => EmailVal().validateEmail(value)),
              controller: _addressController,
              keyboardType: TextInputType.streetAddress,
              style: AppStyle().myTextForm1,
              decoration: AppStyle().textFieldDecoration1(
                'Address',
              ),
            ),
            TextFormField(
              //validator: ((value) => EmailVal().validateEmail(value)),
              controller: _dobController.value,
              readOnly: true,
              keyboardType: TextInputType.number,
              style: AppStyle().myTextForm1,
              decoration: InputDecoration(
                  hintText: 'Date of birth',
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(Icons.calendar_month_rounded))),
            ),
            SizedBox(
              height: 15.h,
            ),

            ToggleSwitch(
              initialLabelIndex: 0,
              totalSwitches: 2,
              labels: [
                'Male',
                'Female',
              ],
              onToggle: (index) {
                if (index == 0) {
                  gender = "Male";
                } else {
                  gender = "Female";
                }
                print('switched to: $index');
              },
            ),

            SizedBox(
              height: 25.h,
            ),

            DeepseaButton(
              text: 'Continue',
              onAction: () async {
                if (_nameController.text.length < 1) {
                  Fluttertoast.showToast(msg: 'Name field can\'t be empty');
                } else if(_voteridController.text.length < 10){
                  Fluttertoast.showToast(msg: 'Minimum 10 Digit VoterId');
                } else if(_voteridController.text.length > 14){
                  Fluttertoast.showToast(msg: 'Max 14 Digit VoterId');
                }
                else if(_phoneController.text.length < 11){
                  Fluttertoast.showToast(msg: 'Minimum 11 Digit Phone');
                }
                else if(_addressController.text.length < 1){
                  Fluttertoast.showToast(msg: 'Address field can\'t be empty');
                }
                else if(dob!.isEmpty){
                  Fluttertoast.showToast(msg: 'Birthday field can\'t be empty');
                }
                 else {
                  UsersInfo().sendFromDataToDBEmail(
                    _nameController.text,
                    _phoneController.text,
                    _voteridController.text,
                    _addressController.text,
                    dob!,
                    gender);

                 }
                
              },
            ),
            // ElevatedButton(
            //     onPressed: () async {
            //       UsersInfo().sendFromDataToDB(
            //           _nameController.text,
            //           _phoneController.text,
            //           _voteridController.text,
            //           _emailController.text,
            //           _addressController.text,
            //           dob!,
            //           gender);
            //     },
            //     child: Text('send'))
          ],
        ),
      ),
    ));
  }
}
