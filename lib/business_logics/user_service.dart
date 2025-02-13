import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch specific fields (name, birthday, nid) based on the current user's UID
  Future<Map<String, dynamic>?> getUserDataByUID() async {
    try {
      String? userUID = FirebaseAuth.instance.currentUser?.uid;
      
      if (userUID == null) {
        return null; // Handle if user is not authenticated
      }

      DocumentSnapshot userDoc = await _db.collection('user-form-data').doc(userUID).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null; // No user data found for this UID
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
