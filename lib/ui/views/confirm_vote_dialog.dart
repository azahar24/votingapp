import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:votingapp/business_logics/user_controller.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/ui/views/vote_screen.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';

class ConfirmVoteDialog extends StatelessWidget {
  String docid;
  var documentid;
  ConfirmVoteDialog({required this.docid, required this.documentid});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    return Scaffold(
      body: Dialog(
        child: Container(
          height: 250.h,
          width: 150.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.deepseaColor
            )
          ),
          padding: EdgeInsets.all(10.r),
          child: Column(
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.userData.isEmpty) {
                  return Center(child: Text('No user data found'));
                } else {
                  var user = controller.userData;
                  return Padding(
                    padding: EdgeInsets.all(4.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${user['name']}",
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        Text(
                          "Voter ID: ${user['voterid']}",
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      ],
                    ),
                  );
                }
              }),
      
              //const Text("Name: ${userController.userData['']}"),
              DeepseaButton(
                  text: 'Confirm Vote',
                  onAction: () async {
                    try {
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      final FirebaseFirestore _firestore =
                          FirebaseFirestore.instance;
      
                      final userDocCheckVote = await _firestore
                          .collection('election')
                          .doc(docid)
                          .collection('vote')
                          .doc(_auth.currentUser!.uid)
                          .get();
                      if (userDocCheckVote.exists) {
                        // throw Exception('User has already voted.');
                        // Fluttertoast.showToast(
                        //     msg: 'User has already voted.');
      
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          headerAnimationLoop: false,
                          title: 'Error',
                          desc: 'User has already voted.',
                          btnOkOnPress: () {
                            Future.delayed(const Duration(seconds: 1), () {
                                  //Navigator.pop(context);
                                  Get.to(VoteScreen(docid: docid));
                                });
                          },
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red,
                        ).show();

                      } else {
                        await _firestore
                            .collection('election')
                            .doc(docid)
                            .collection('vote')
                            .doc(_auth.currentUser!.uid)
                            .set({
                          'candidateId': documentid,
                          'vote_done': '1',
                        });
                        //vote check
      
                        await _firestore
                            .collection('election')
                            .doc(docid)
                            .collection('candidate')
                            .doc(documentid)
                            .update({
                          'total_votes': FieldValue.increment(1),
                        });
      
                        // Fluttertoast.showToast(
                        //     msg: 'Vote cast successfully!');
                        
                        final box = GetStorage();
                        var canditdate = box.read('canditname');
                        await _firestore
                            .collection('user-form-data')
                            .doc(_auth.currentUser!.uid).
                            collection('notification').add({
                          'candidatename': canditdate,
                          'timestamp': Timestamp.now(),
                        });
      
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.leftSlide,
                          headerAnimationLoop: false,
                          dialogType: DialogType.success,
                          showCloseIcon: true,
                          title: 'Succes',
                          desc: 'Vote cast successfully!',
                          btnOkOnPress: () {
                            debugPrint('OnClcik');
                            Future.delayed(const Duration(seconds: 1), () {
                                  //Navigator.pop(context);
                                  Get.to(VoteScreen(docid: docid));
                                });
                          },
                          btnOkIcon: Icons.check_circle,
                          onDismissCallback: (type) {
                            debugPrint('Dialog Dissmiss from callback $type');
                          },
                        ).show();
                      }
      
                      // }
                    } catch (e) {
                      Get.snackbar('Error', e.toString());
                      print(e);
                    }
                  }),
              SizedBox(
                height: 20.h,
              ),
              DeepseaButton(
                  text: 'Cancel',
                  onAction: () {
                    Future.delayed(const Duration(seconds: 1), () {
                                  //Navigator.pop(context);
                                  Get.to(VoteScreen(docid: docid));
                                });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
