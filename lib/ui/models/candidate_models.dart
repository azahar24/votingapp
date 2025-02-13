import 'package:cloud_firestore/cloud_firestore.dart';

class ElectionCanditdate {
  final String id;
  final String name;
  final String img;
  final String party;

  ElectionCanditdate({required this.id, required this.name, required this.img, required this.party,});

  factory ElectionCanditdate.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ElectionCanditdate(
      id: doc.id,
      name: data['candit_name'],
      img: data['img'], 
      party: data['party_name'],
    );
  }
}

Future<List<ElectionCanditdate>> getCandidate(docid) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('election').doc(docid).collection('candidate').get();
  return snapshot.docs.map((doc) => ElectionCanditdate.fromFirestore(doc)).toList();
}


