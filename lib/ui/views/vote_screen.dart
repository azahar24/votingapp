import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:votingapp/business_logics/user_controller.dart';
import 'package:votingapp/const/app_colors.dart';
import 'package:votingapp/face_recognition/screens/authenticate_screen.dart';
import 'package:votingapp/ui/styles/style.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';

class VoteScreen extends StatelessWidget {
  String docid;
  VoteScreen({required this.docid});

  Future<int> getDocumentCount() async {
    // Reference to your Firestore collection
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('election')
        .doc(docid)
        .collection('candidate');

    // Fetch the documents
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Return the count of documents
    return querySnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
        FirebaseFirestore.instance
            .collection('election')
            .doc(docid)
            .collection('candidate')
            .snapshots();

    final UserController controller = Get.put(UserController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.deepseaColor,
          centerTitle: true,
          title: Text(
            "Vote",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
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

              return Padding(
                padding: EdgeInsets.only(
                  top: 20.h,
                  right: 10.w,
                  left: 10.w,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder(
                          future: getDocumentCount(),
                          builder: (_, snapshot) {
                            return Text(
                              'CANDIDATES - ${snapshot.data}',
                              style: AppStyle().cardTitle,
                            );
                          }),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Expanded(
                      child: ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                          return Container(
                            height: 75,
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                  onTap: () {},
                                  title: Text(
                                    data['candit_name'],
                                    style: AppStyle().cardTitle,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(data['party_name']),
                                  leading: Image.network(
                                    data['img'],
                                  ),

                                  // subtitle: Text(data['election_code'],maxLines: 1,),
                                  trailing: IconButton(
                                      onPressed: () {
                                        final box = GetStorage();
                                        box.write('docid', docid);
                                        box.write('documentid', document.id);
                                        box.write('canditname', data['candit_name']);
                                        Get.to(AuthenticateScreen());
                                        // Get.dialog(
                                        //     name: 'Confirm Vote',
                                            
                                        //     );
                                      },
                                      icon: Icon(Icons.how_to_vote))),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
