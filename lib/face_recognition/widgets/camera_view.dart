import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:votingapp/face_recognition/controller/camera_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key, required this.onImage, required this.onInputImage}) : super(key: key);

  final Function(Uint8List image) onImage;
  final Function(InputImage inputImage) onInputImage;

  @override
  Widget build(BuildContext context) {
    final cameraController = Get.put(CameraController()); // Initialize the controller

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300.h,
          decoration: const BoxDecoration(
            //color: Colors.yellowAccent,
            //image: DecorationImage(image: AssetImage('assets/img/face_camara.png'))
          ),
          child: Obx(() {
            // Observe the image value from the controller
            return cameraController.image.value != null
                ? Image.file(
                    cameraController.image.value!,
                    fit: BoxFit.cover,
                  )
                : Container(
                  width: double.infinity,
                  height: 300.h,
                  decoration: const BoxDecoration(
            //color: Colors.yellowAccent,
            image: DecorationImage(image: AssetImage('assets/img/face_camara.png'))
          )
                );
          }),
        ),
        const SizedBox(
          height: 12,
        ),
        ElevatedButton(
          onPressed: () => cameraController.getImage(onImage, onInputImage),
          child: const Text(
            "Click here to Capture",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
