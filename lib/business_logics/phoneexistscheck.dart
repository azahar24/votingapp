import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StringCheckController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable state
  var stringExists = false.obs;
  var isLoading = false.obs;

  // Function to check if string exists in Firestore
  Future<void> checkIfStringExists(String searchString) async {
    isLoading.value = true;

    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('user-phone-number')
          .where('phone', isEqualTo: searchString)
          .get();

      stringExists.value = querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors that occur during the query
      print('Error checking string existence: $e');
      stringExists.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
