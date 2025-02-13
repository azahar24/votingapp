import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:votingapp/face_recognition/controller/authenticate_controller.dart';
import 'package:votingapp/face_recognition/services/extract_features.dart';
import 'package:votingapp/face_recognition/widgets/camera_view.dart';

class AuthenticateScreen extends StatelessWidget {
  final AuthenticateController controller = Get.put(AuthenticateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Authenticate"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Camera view that captures the image and processes face recognition
            CameraView(
              onImage: (image) {
                controller.setImage(image);
              },
              onInputImage: (inputImage) async {
                controller.isMatching.value = true;

                // Extract face features from the input image
                var features = await extractFaceFeatures(
                    inputImage, controller.faceDetector); // Use the getter
                if (features != null) {
                  controller.setFaceFeatures(features);

                  // Auto authenticate as soon as face features are set
                  await controller.fetchUsersAndMatchFace();
                }

                controller.isMatching.value = false;
              },
            ),

            // Display a loading spinner during the matching process
            Obx(
              () => controller.isMatching.value
                  ? const Center(child: CircularProgressIndicator())
                  : Container(), // No button or UI elements, just the spinner
            ),

            const SizedBox(height: 38),
          ],
        ),
      ),
    );
  }
}
