import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class StringController extends GetxController {
  var myString = ''.obs; // Observable string
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchString();
  }

  void fetchString() async {
    try {
      // Replace 'collection' and 'document' with your actual collection and document names
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('user-form-data')
          .doc(_auth.currentUser!.uid)
          .get();
      
      if (doc.exists) {
        myString.value = doc.get('pin');
      }
    } catch (e) {
      print('Error fetching string: $e');
    }
  }
}
