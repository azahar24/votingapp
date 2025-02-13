import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CameraController extends GetxController {
  var image = Rx<File?>(null);
  var imagePicker = ImagePicker();

  Future<void> getImage(Function(Uint8List) onImage, Function(InputImage) onInputImage) async {
    image.value = null;
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 400,
      maxHeight: 400,
    );
    if (pickedFile != null) {
      final path = pickedFile.path;
      image.value = File(path);

      // Send data to the provided callback functions
      Uint8List imageBytes = image.value!.readAsBytesSync();
      onImage(imageBytes);

      InputImage inputImage = InputImage.fromFilePath(path);
      onInputImage(inputImage);
    }
  }
}
