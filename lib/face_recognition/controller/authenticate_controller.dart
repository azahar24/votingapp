import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:developer';
import 'package:votingapp/face_recognition/model/face_features.dart';
import 'package:votingapp/face_recognition/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:votingapp/ui/views/confirm_vote_dialog.dart';

class AuthenticateController extends GetxController {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  FaceDetector get faceDetector => _faceDetector;
  
  FaceFeatures? _faceFeatures;
  FaceFeatures? get faceFeatures => _faceFeatures; 

  var image1 = regula.MatchFacesImage();
  var image2 = regula.MatchFacesImage();

  final nameController = TextEditingController();
  var canAuthenticate = false.obs;
  var similarity = "".obs;
  var users = [].obs;
  var userExists = false.obs;
  var isMatching = false.obs;
  UserModel? loggingUser;
  var trialNumber = 1.obs;

  void setImage(Uint8List imageToAuthenticate) {
    image2.bitmap = base64Encode(imageToAuthenticate);
    image2.imageType = regula.ImageType.PRINTED;
    canAuthenticate.value = true;
  }

  void setFaceFeatures(FaceFeatures faceFeatures) {
    _faceFeatures = faceFeatures;
  }

  double compareFaces(FaceFeatures face1, FaceFeatures face2) {
    double distEar1 = euclideanDistance(face1.rightEar!, face1.leftEar!);
    double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);
    double ratioEar = distEar1 / distEar2;

    double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
    double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);
    double ratioEye = distEye1 / distEye2;

    double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
    double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);
    double ratioCheek = distCheek1 / distCheek2;

    double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
    double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);
    double ratioMouth = distMouth1 / distMouth2;

    double distNoseToMouth1 =
        euclideanDistance(face1.noseBase!, face1.bottomMouth!);
    double distNoseToMouth2 =
        euclideanDistance(face2.noseBase!, face2.bottomMouth!);

    double ratioNoseToMouth = distNoseToMouth1 / distNoseToMouth2;

    double ratio =
        (ratioEye + ratioEar + ratioCheek + ratioMouth + ratioNoseToMouth) / 5;
    log(ratio.toString(), name: "Ratio");

    return ratio;
  }

  double euclideanDistance(Points p1, Points p2) {
    final sqr =
        math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
    return sqr;
  }

  Future<void> fetchUsersAndMatchFace() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection('user-form-data')
        .doc(_auth.currentUser!.uid)
        .collection("users")
        .get()
        .catchError((e) {
      log("Getting User Error: $e");
      isMatching.value = false;
      Fluttertoast.showToast(msg: "Something went wrong. Please try again.");
    }).then((snap) {
      if (snap.docs.isNotEmpty) {
        users.clear();
        log(snap.docs.length.toString(), name: "Total Registered Users");
        for (var doc in snap.docs) {
          UserModel user = UserModel.fromJson(doc.data());
          double similarity = compareFaces(_faceFeatures!, user.faceFeatures!);
          if (similarity >= 0.8 && similarity <= 1.5) {
            users.add([user, similarity]);
          }
        }
        log(users.length.toString(), name: "Filtered Users");

        // Match faces
        matchFaces();
      } else {
        showFailureDialog(
          title: "No Users Registered",
          description: "Make sure users are registered first before Authenticating.",
        );
      }
    });
  }

  Future<void> matchFaces() async {
    bool faceMatched = false;
    for (List user in users) {
      image1.bitmap = (user.first as UserModel).image;
      image1.imageType = regula.ImageType.PRINTED;

      // Face comparing logic.
      var request = regula.MatchFacesRequest();
      request.images = [image1, image2];
      dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));

      var response = regula.MatchFacesResponse.fromJson(json.decode(value));
      dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
          jsonEncode(response!.results), 0.75);

      var split =
          regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
      similarity.value = split!.matchedFaces.isNotEmpty
          ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)
          : "error";
      log("similarity: ${similarity.value}");

      if (similarity.value != "error" && double.parse(similarity.value) > 90.00) {
        faceMatched = true;
        loggingUser = user.first;
      }

      if (faceMatched) {
        trialNumber.value = 1;
        isMatching.value = false;

        //Get.toNamed('/pinLockScreen');
        Fluttertoast.showToast(msg: 'faceMatched');
        //vote done
        final box = GetStorage();
        var docid = box.read('docid');
        var documentid = box.read('documentid');
        Get.to(ConfirmVoteDialog(docid: docid, documentid: documentid));

        
        //vote done
        break;
      }
    }

    if (!faceMatched) {
      handleFaceMismatch();
    }
  }

  void handleFaceMismatch() {
    if (trialNumber.value == 4) {
      trialNumber.value = 1;
      showFailureDialog(
        title: "Redeem Failed",
        description: "Face doesn't match. Please try again.",
      );
    } else if (trialNumber.value == 3) {
      trialNumber.value++;
    } else {
      trialNumber.value++;
      showFailureDialog(
        title: "Redeem Failed",
        description: "Face doesn't match. Please try again.",
      );
    }
  }

  void showFailureDialog({required String title, required String description}) {
    isMatching.value = false;
    Get.defaultDialog(title: title, middleText: description);
  }
}
