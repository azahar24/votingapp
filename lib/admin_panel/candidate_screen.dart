import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class CandidateScreen extends StatelessWidget {

   String docid;
  CandidateScreen({required this.docid});

  

  

  // final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
  //     FirebaseFirestore.instance
  //         .collection('election').doc(docid).collection('candidate').snapshots();

 

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
      FirebaseFirestore.instance
          .collection('election').doc(docid).collection('candidate').snapshots();
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
                        onTap: () {
                          
                        },
                        title: Text(data['candit_name'],maxLines: 1,),
                        leading: Image.network(data['img'], ),

                       // subtitle: Text(data['election_code'],maxLines: 1,),
                        trailing: IconButton(onPressed: (){
                          
                        }, icon: Icon(Icons.edit))
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}