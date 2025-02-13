import 'package:cloud_firestore/cloud_firestore.dart';

class AllUserFetchController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('user-form-data').get();
      List<Map<String, dynamic>> users = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      return users;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }
}
