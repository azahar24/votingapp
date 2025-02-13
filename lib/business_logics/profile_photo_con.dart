import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadController extends GetxController {
  var selectedImagePath = ''.obs; // For local image path
  var firebaseImageUrl = ''.obs; // For Firebase image URL
  var isUploading = false.obs; // To track the upload status
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }

  Future<void> fetchFirebaseImage(String userId) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('user-form-data').doc(userId).get();
      if (docSnapshot.exists && docSnapshot['profileImage'] != null) {
        firebaseImageUrl.value = docSnapshot['profileImage'];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load image: $e');
    }
  }

  Future<void> uploadPhoto(String userId) async {
    if (selectedImagePath.value.isNotEmpty) {
      isUploading.value = true; // Start upload
      try {
        File file = File(selectedImagePath.value);
        String fileName =
            "users/$userId/profile_${DateTime.now().millisecondsSinceEpoch}.jpg";
        UploadTask uploadTask =
            FirebaseStorage.instance.ref(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;

        // Get the image URL
        String imageUrl = await snapshot.ref.getDownloadURL();

        // Save the image URL to Firestore
        await FirebaseFirestore.instance
            .collection('user-form-data')
            .doc(userId)
            .update({'profileImage': imageUrl});

        firebaseImageUrl.value = imageUrl;

        Get.snackbar('Success', 'Photo uploaded successfully!');
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload photo: $e');
      } finally {
        isUploading.value = false; // End upload
      }
    } else {
      Get.snackbar('Error', 'Please select an image first.');
    }
  }
}
