import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:votingapp/ui/views/result.dart';

class ResultScreen extends StatelessWidget {
  String docid;
  ResultScreen({required this.docid});

  Future<void> vote(String candidateId, String userId) async {}

  // final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
  //     FirebaseFirestore.instance
  //         .collection('election').doc(docid).collection('candidate').snapshots();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
        FirebaseFirestore.instance
            .collection('election')
            .doc(docid)
            .collection('candidate')
            .snapshots();
    return SafeArea(
      child: Scaffold(
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
                    color: Colors.red,
                    child: Card(
                      child: ListTile(
                          onTap: () {},
                          title: Text(
                            data['candit_name'],
                            maxLines: 1,
                          ),
                          leading: Image.network(
                            data['img'],
                          ),

                          // subtitle: Text(data['election_code'],maxLines: 1,),
                          trailing: IconButton(
                              onPressed: () async {
                                Get.to(ResultCandit(
                                  canditid: document.id,
                                  docid: docid,
                                ));

                                // try {
                                //   Future<int> getDocumentCount() async {
                                //   QuerySnapshot querySnapshot =
                                //       await FirebaseFirestore.instance
                                //           .collection('election')
                                //           .doc(docid)
                                //           .collection('candidate')
                                //           .doc(document.id)
                                //           .collection('vote')
                                //           .get();
                                //   return querySnapshot.size;
                                // }

                                // void getCount() async {
                                //   int count = await getDocumentCount();
                                //   print('Document count: $count');
                                //   Fluttertoast.showToast(msg: 'your $count');
                                // }
                                // } catch (e) {

                                // }
                                print('add');
                              },
                              icon: Icon(Icons.restaurant))),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
