import 'dart:async';

import 'package:get/get.dart';

class HomePageController extends GetxController {
  Timer? timer;
  RxInt _inactiveTimeInSeconds =
      40.obs; // Set the inactive time limit in seconds

  

  void resetTimer() {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(Duration(seconds: _inactiveTimeInSeconds.value), () {
      // Lock the app or perform any other action when inactive
      //Get.toNamed(pinLockScreen);
      print('App locked due to inactivity.');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  // RxInt minutes = 2.obs;
  RxInt failedLoginAttemps = 0.obs;

  

  void failedLoginIncriment() {
    failedLoginAttemps++;
    print(failedLoginAttemps);
  }
}
