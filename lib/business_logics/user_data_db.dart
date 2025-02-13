import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:votingapp/ui/route/route.dart';

class UsersInfo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  sendFromDataToDBEmail(String name, String phone, String voterid,
      String address, String dob, String gender) async {
    try {
      CollectionReference _course =
          FirebaseFirestore.instance.collection('user-form-data');
      _course.doc(_auth.currentUser!.uid).set({
        'name': name,
        'voterid': voterid,
        'phone': phone,
        'address': address,
        'dob': dob,
        'gender': gender,
      }).whenComplete(
        () {
          Fluttertoast.showToast(msg: 'Added Successfully');
          Get.toNamed(faceregisterscreen);
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'error: $e');
    }
  }

  //save data for email signup
  sendFromDataToDBPhone(
    String name,
    String email,
    String voterid,
    String address,
    String pin,
    String dob,
    String gender,
  ) async {
    try {
      CollectionReference _course =
          FirebaseFirestore.instance.collection('user-form-data');
      _course.doc(_auth.currentUser!.uid).set({
        'name': name,
        'voterid': voterid,
        'email': email,
        'address': address,
        'pin': pin,
        'dob': dob,
        'gender': gender,
      }).whenComplete(
        () {
          Fluttertoast.showToast(msg: 'Added Successfully');
          Get.toNamed(faceregisterscreen);
        },
      );
      //db info
      CollectionReference userphonestore =
          FirebaseFirestore.instance.collection('user-phone-number');
      userphonestore.doc().set({
        'phone': _auth.currentUser!.phoneNumber,
      }).whenComplete(
        () {
          Fluttertoast.showToast(msg: 'Added Successfully');
          Get.toNamed(faceregisterscreen);
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'error: $e');
    }
  }
  //save data for phone signup
}
