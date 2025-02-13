import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:votingapp/admin_panel/candidate_screen.dart';
import 'package:votingapp/ui/views/result_published.dart';
import 'package:votingapp/ui/views/vote_screen.dart';

class ResultCandit extends StatelessWidget {
  String canditid;
  String docid;
  ResultCandit({
    required this.canditid,
    required this.docid,
  });

  Future<int> getDocumentCount() async {
  // Reference to your Firestore collection
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('election')
                                          .doc(docid)
                                          .collection('candidate')
                                          .doc(canditid)
                                          .collection('vote');
  
  // Fetch the documents
  QuerySnapshot querySnapshot = await collectionRef.get();
  
  // Return the count of documents
  return querySnapshot.docs.length;
}


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
      child: FutureBuilder(future: getDocumentCount(),
       builder:  (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Center(child: Text('vote count: ${snapshot.data}'));
        } else {
          return Text('No data');
        }
      },
      ),
    ),
    );
  }
}
