import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Election {
  final String id;
  final String name;
  final String elcCode;
  final DateTime startTime;
  final DateTime endTime;

  Election({required this.id, required this.name, required this.startTime, required this.endTime, required this.elcCode,});

  factory Election.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    DateFormat format = DateFormat("dd-MMM-yyyy - HH:mm");
    return Election(
      id: doc.id,
      name: data['election_name'],
      startTime: format.parse(data['start_time']),
      endTime: format.parse(data['end_time']),
       elcCode: data['election_code'],
    );
  }
}

Future<List<Election>> getElections() async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('election').get();
  return snapshot.docs.map((doc) => Election.fromFirestore(doc)).toList();
}


