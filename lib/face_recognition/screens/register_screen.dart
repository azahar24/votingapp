

import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:uuid/uuid.dart';
import 'package:votingapp/face_recognition/model/face_features.dart';
import 'package:votingapp/face_recognition/model/user_model.dart';
import 'package:votingapp/face_recognition/widgets/camera_view.dart';
import 'package:votingapp/face_recognition/services/extract_features.dart';
import 'package:votingapp/ui/route/route.dart';

class FaceRegisterScreen extends StatefulWidget {
  const FaceRegisterScreen({super.key});

  @override
  State<FaceRegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<FaceRegisterScreen> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  String? _image;
  FaceFeatures? _faceFeatures;

  bool isRegistering = false;
  final _formFieldKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: 'null');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Register User"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CameraView(
              onImage: (image) {
                setState(() {
                  _image = base64Encode(image);
                });
              },
              onInputImage: (inputImage) async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                        // color: accentColor,
                        ),
                  ),
                );
                await extractFaceFeatures(inputImage, _faceDetector)
                    .then((faceFeatures) {
                  setState(() {
                    _faceFeatures = faceFeatures;
                  });
                  Navigator.of(context).pop();
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formFieldKey,
                  child: Column(
                    children: [
                      
                      ElevatedButton(
                        child: const Text("Start Registering"),
                        onPressed: () {
                          if (_faceFeatures != null) {
                            if (_formFieldKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              );

                              String userId = const Uuid().v1();
                              UserModel user = UserModel(
                                id: userId,
                                name: _nameController.text.trim(),
                                image: _image,
                                registeredOn: Timestamp.now(),
                                faceFeatures: _faceFeatures,
                              );

                              final FirebaseAuth _auth = FirebaseAuth.instance;

                              FirebaseFirestore.instance.collection('user-form-data').doc(_auth.currentUser!.uid)
                                  .collection("users")
                                  .doc(userId)
                                  .set(user.toJson())
                                  .catchError((e) {
                                log("Registration Error: $e");
                                Navigator.of(context).pop();
                                showToast('Registration Failed! Try Again.');
                              }).whenComplete(() {
                                Navigator.of(context).pop();
                                showToast('Registered successfully');
                                Future.delayed(const Duration(seconds: 1), () {
                                  //Navigator.pop(context);
                                  Get.toNamed(homeScreen);
                                });
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showToast(msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
    );
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }
}