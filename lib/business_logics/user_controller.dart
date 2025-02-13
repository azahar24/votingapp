import 'package:get/get.dart';
import 'package:votingapp/business_logics/user_service.dart';

class UserController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  
  var userData = {}.obs;  // Observable map to store user data
  var isLoading = true.obs; // Observable for loading state

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Fetch user data from Firestore based on UID
  void fetchUserData() async {
    isLoading.value = true;
    var data = await _firestoreService.getUserDataByUID();
    if (data != null) {
      userData.value = data;
    } else {
      userData.value = {};  // Handle case where no data is found
    }
    isLoading.value = false;
  }
}
