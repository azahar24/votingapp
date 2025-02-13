import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateElectionController extends GetxController {
  XFile? courseImage;
  TextEditingController canditNameController = TextEditingController();
  TextEditingController partyNameController = TextEditingController();

  // Function to choose image from gallery
  chooseImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    courseImage = await _picker.pickImage(source: ImageSource.gallery);
    if (courseImage != null) {
      update(); // Notify UI to update
    } else {
      Fluttertoast.showToast(msg: 'No image selected');
    }
  }

  // Function to write candidate data to Firebase
  Future<void> writeDataElc(String electionCode) async {
    if (courseImage == null) {
      Fluttertoast.showToast(msg: 'Please select an image first');
      return; // Exit the function if no image is selected
    }

    File imgFile = File(courseImage!.path);
    FirebaseStorage _storage = FirebaseStorage.instance;
    UploadTask _uploadTask =
        _storage.ref('images').child(courseImage!.name).putFile(imgFile);

    TaskSnapshot snapshot = await _uploadTask;
    var imageUrl = await snapshot.ref.getDownloadURL();

    try {
      CollectionReference _candit = FirebaseFirestore.instance
          .collection("election")
          .doc(electionCode)
          .collection("candidate");
      await _candit.doc().set({
        'candit_name': canditNameController.text,
        'img': imageUrl,
        'party_name': partyNameController.text,
      });

      // Clear the text fields after successful update
      canditNameController.clear();
      partyNameController.clear();
      Fluttertoast.showToast(msg: 'Add Candidate Successfully');

      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  // Function to update candidate data in Firebase
  Future<void> updateDataElc(String electionCode, String candidateId) async {
    if (courseImage == null) {
      Fluttertoast.showToast(msg: 'Please select an image first');
      return; // Exit the function if no image is selected
    }

    File imgFile = File(courseImage!.path);
    FirebaseStorage _storage = FirebaseStorage.instance;
    UploadTask _uploadTask =
        _storage.ref('images').child(courseImage!.name).putFile(imgFile);

    TaskSnapshot snapshot = await _uploadTask;
    var imageUrl = await snapshot.ref.getDownloadURL();

    try {
      CollectionReference _candit = FirebaseFirestore.instance
          .collection("election")
          .doc(electionCode)
          .collection("candidate");
      await _candit.doc(candidateId).update({
        'candit_name': canditNameController.text,
        'img': imageUrl,
        'party_name': partyNameController.text,
      }).whenComplete(() {
        canditNameController.clear();
        partyNameController.clear();
        Fluttertoast.showToast(msg: 'Update Candidate Successfully');
        Get.back();
      });

      // Clear the text fields after successful update
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  // Function to delete candidate data from Firebase
  Future<void> deleteCandidate(String electionCode, String candidateId) async {
    try {
      CollectionReference _candit = FirebaseFirestore.instance
          .collection("election")
          .doc(electionCode)
          .collection("candidate");
      await _candit.doc(candidateId).delete();
      Fluttertoast.showToast(msg: 'Candidate deleted successfully');
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}
