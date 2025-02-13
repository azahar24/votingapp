import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';

class CreateElection extends StatefulWidget {
  String electioncode;
  CreateElection({required this.electioncode});
  @override
  State<CreateElection> createState() => _CreateElectionState();
}

class _CreateElectionState extends State<CreateElection> {
  XFile? _courseImage;

  TextEditingController _canditNameController = TextEditingController();
  TextEditingController _partyNameController = TextEditingController();

  chooseImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    _courseImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  writeDataElc() async {
    File imgFile = File(_courseImage!.path);
    FirebaseStorage _stroage = FirebaseStorage.instance;
    UploadTask _uploadTask =
        _stroage.ref('images').child(_courseImage!.name).putFile(imgFile);

    TaskSnapshot snapshot = await _uploadTask;
    var imageUrl = await snapshot.ref.getDownloadURL();
    print(imageUrl);
    try {
      CollectionReference _candit = FirebaseFirestore.instance
          .collection("election")
          .doc(widget.electioncode)
          .collection("candidate");
      _candit.doc().set({
        'candit_name': _canditNameController.text,
        'img': imageUrl,
        'party_name': _partyNameController.text,
        //'total_votes':'1'
      }).whenComplete(
        () {
          Fluttertoast.showToast(msg: 'Add Candidate Successfully');
          Get.back();
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'error is ${e}');
    }
  }

  updateDataElc(String candidateId) async {
    File imgFile = File(_courseImage!.path);
    FirebaseStorage _stroage = FirebaseStorage.instance;
    UploadTask _uploadTask =
        _stroage.ref('images').child(_courseImage!.name).putFile(imgFile);

    TaskSnapshot snapshot = await _uploadTask;
    var imageUrl = await snapshot.ref.getDownloadURL();
    print(imageUrl);
    try {
      CollectionReference _candit = FirebaseFirestore.instance
          .collection("election")
          .doc(widget.electioncode)
          .collection("candidate");
      _candit.doc(candidateId).update({
        'candit_name': _canditNameController.text,
        'img': imageUrl,
        'party_name': _partyNameController.text,
        //'total_votes':'1'
      }).whenComplete(
        () {
          Fluttertoast.showToast(msg: 'Update Candidate Successfully');
          Get.back();
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'error is ${e}');
    }
  }

  deleteCandidate(String candidateId) async {
  try {
    CollectionReference _candit = FirebaseFirestore.instance
        .collection("election")
        .doc(widget.electioncode)
        .collection("candidate");

    await _candit.doc(candidateId).delete().whenComplete(() {
      Fluttertoast.showToast(msg: 'Candidate deleted successfully');
      Get.back();
    });
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error deleting candidate: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
        FirebaseFirestore.instance
            .collection('election')
            .doc(widget.electioncode)
            .collection('candidate')
            .snapshots();
    return Scaffold(
        //floatingActionButtonLocation: FloatingActionButtonLocation.,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_box),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('Candidate Info'),
                      content: Container(
                        height: 350.h,
                        width: 300.w,
                        child: Column(
                          children: [
                            Container(
                              height: 50.h,
                              //width: 250.h,
                              child: DeepseaButton(
                                  text: "Add Candidate Photo",
                                  onAction: () {
                                    chooseImageFromGallery();
                                  }),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            TextFormField(
                              //validator: ((value) => EmailVal().validateEmail(value)),
                              controller: _canditNameController,
                              keyboardType: TextInputType.text,
                              style: AppStyle().myTextForm1,
                              decoration: AppStyle().textFieldDecoration1(
                                'Candidate Name',
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            TextFormField(
                              //validator: ((value) => EmailVal().validateEmail(value)),
                              controller: _partyNameController,
                              keyboardType: TextInputType.text,
                              style: AppStyle().myTextForm1,
                              decoration: AppStyle().textFieldDecoration1(
                                'Party Name',
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            DeepseaButton(
                                text: "Add Candidate",
                                onAction: () async {
                                  writeDataElc();
                                })
                          ],
                        ),
                      ),
                    );
                  });
            }),
        appBar: AppBar(
          title: Text(
            'Add Candidate',
            style: TextStyle(
                fontSize: 23.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Get.back(),
              color: Colors.white,
              icon: Icon(
                Icons.arrow_back,
                size: 25.sp,
              )),
          backgroundColor: AppColors.deepseaColor,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Container(
                    height: 75,
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('Candidate Info'),
                      content: Container(
                        height: 350.h,
                        width: 300.w,
                        child: Column(
                          children: [
                            Container(
                              height: 50.h,
                              //width: 250.h,
                              child: DeepseaButton(
                                  text: "Add Candidate Photo",
                                  onAction: () {
                                    chooseImageFromGallery();
                                  }),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            TextFormField(
                              //validator: ((value) => EmailVal().validateEmail(value)),
                              controller: _canditNameController,
                              keyboardType: TextInputType.text,
                              style: AppStyle().myTextForm1,
                              decoration: AppStyle().textFieldDecoration1(
                                'Candidate Name',
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            TextFormField(
                              //validator: ((value) => EmailVal().validateEmail(value)),
                              controller: _partyNameController,
                              keyboardType: TextInputType.text,
                              style: AppStyle().myTextForm1,
                              decoration: AppStyle().textFieldDecoration1(
                                'Party Name',
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 140.w,
                                  child: DeepseaButton(
                                      text: "Update",
                                      onAction: () async {
                                        updateDataElc(document.id);
                                      }),
                                ),
                                SizedBox(width: 10.w,),
                                Container(
                                  width: 140.w,
                                  child: DeepseaButton(
                                      text: "Delete",
                                      onAction: () async {
                                        deleteCandidate(document.id);
                                      }),
                                ),
                                    
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
                        },
                        title: Text(
                          data['candit_name'],
                          maxLines: 1,
                        ),
                        leading: Image.network(
                          data['img'],
                        ),
                        subtitle: Text(
                          data['party_name'],
                          maxLines: 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }));
  }
}
