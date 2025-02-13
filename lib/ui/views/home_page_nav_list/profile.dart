import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:votingapp/business_logics/profile_photo_con.dart';
import 'package:votingapp/business_logics/user_controller.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/route/route.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/views/dev_screen.dart';
import 'package:votingapp/ui/views/need_help.dart';
import 'package:votingapp/ui/widgets/account_button.dart';

class ProfileScreen extends StatelessWidget {
  void logOut(context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Are You Sure To Logout?"),
              content: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut().then(
                            (value) => Fluttertoast.showToast(
                                msg: "Logout Successful"),
                          );
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DocumentReference userDoc = FirebaseFirestore.instance
      .collection('user-form-data')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController voterIDController = TextEditingController();
  Rx<TextEditingController> _dobController = TextEditingController().obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  String? dob;

  _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    );

    if (selected != null && selected != selectedDate) {
      dob = "${selected.day} - ${selected.month} - ${selected.year}";
      _dobController.value.text = dob!;
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final PhotoUploadController controller = Get.put(PhotoUploadController());

    return SafeArea(
      child: Scaffold(
        // backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  //edit name or vuter id
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Edit Name or Voter ID'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              //validator: ((value) => EmailVal().validateEmail(value)),
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              style: AppStyle().myTextForm1,
                              decoration: AppStyle().textFieldDecoration1(
                                'Full Name',
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              //validator: ((value) => EmailVal().validateEmail(value)),
                              controller: voterIDController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              style: AppStyle().myTextForm1,
                              decoration: AppStyle().textFieldDecoration1(
                                'Voter ID',
                              ),
                            ),
                            SizedBox(height: 10),
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
                                      icon:
                                          Icon(Icons.calendar_month_rounded))),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final newName = nameController.text;
                              final newVoterID = voterIDController.text;
                              final FirebaseAuth _auth = FirebaseAuth.instance;

                              print('New Name: $newName');
                              print('New Voter ID: $newVoterID');

                              try {
                                CollectionReference _course = FirebaseFirestore
                                    .instance
                                    .collection('user-form-data');
                                _course.doc(_auth.currentUser!.uid).update({
                                  'name': newName,
                                  'voterid': newVoterID,
                                  'dob': dob,
                                }).whenComplete(
                                  () {
                                    Fluttertoast.showToast(
                                        msg: 'Update Successfully');
                                    Navigator.of(context).pop();
                                  },
                                );
                              } catch (e) {
                                Fluttertoast.showToast(msg: 'error: $e');
                              }
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.edit_document))
          ],
          title: Text(
            'Profile',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.h, right: 15.w, left: 15.w),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Obx(() => Container(
      height: 110.h,
      width: 110.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: controller.firebaseImageUrl.isNotEmpty
              ? NetworkImage(controller.firebaseImageUrl.value)
              : controller.selectedImagePath.isNotEmpty
                  ? FileImage(File(controller.selectedImagePath.value))
                  : const AssetImage('assets/img/av.png') as ImageProvider,
          fit: BoxFit.cover,
        ),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () async {
          await controller.pickImage();
        },
        child: Align(
          alignment: Alignment.bottomRight,
          child: Icon(Icons.camera_alt, color: Colors.blue),
        ),
      ),
    )),

    SizedBox(height: 20),
Obx(() => ElevatedButton(
      onPressed: controller.isUploading.value
          ? null // Disable button during upload
          : () => controller.uploadPhoto(FirebaseAuth.instance.currentUser!.uid), // Replace with actual user ID
      child: controller.isUploading.value
          ? CircularProgressIndicator(color: Colors.white)
          : Text('Upload Photo'),
    )),

    


              SizedBox(
                height: 20.h,
              ),

              StreamBuilder<DocumentSnapshot>(
                stream: userDoc.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('No data found'));
                  }

                  // Extract data from the snapshot
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final name = userData['name'] ?? 'No Name';
                  final voterId = userData['voterid'] ?? 'N/A';

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: $name',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Voter ID: $voterId',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Text(
              //   '${_name}',
              //   style: TextStyle(
              //       color: Color(0xFFA898F6),
              //       fontSize: 18.sp,
              //       fontWeight: FontWeight.bold),
              // ),

              // SizedBox(
              //   height: 5.h,
              // ),
              // Text(
              //   '${_auth.currentUser!.email}',
              //   style: TextStyle(
              //       fontSize: 14.sp,
              //       //fontWeight: FontWeight.w400,
              //       color: Color.fromARGB(255, 243, 243, 243)),
              // ),
              SizedBox(
                height: 30.h,
              ),

              AccountButton(
                  text: 'App Information',
                  onAction: () {
                    Get.to(DeveloperProfilesScreen());
                  },
                  icon: Icons.info_outline,
                  iconlast: Icons.arrow_right),
              SizedBox(
                height: 15.h,
              ),
              AccountButton(
                  text: 'Customer Care',
                  onAction: () {
                    Get.to(ContactPage());
                  },
                  icon: Icons.headphones,
                  iconlast: Icons.arrow_right),
              SizedBox(
                height: 15.h,
              ),
              AccountButton(
                  text: 'logOut',
                  onAction: () => logOut(context),
                  icon: Icons.logout_outlined,
                  iconlast: Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
