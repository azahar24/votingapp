import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:votingapp/business_logics/encrypt_data.dart';
import 'package:votingapp/ui/views/splash_screen.dart';

import 'ui/route/route.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  //DependencyInjection.init();
  MyEncryptionDecryption.encrypter;

  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    name: "BallotBox",
    options: FirebaseOptions(
        apiKey: "AIzaSyBLwOHeLOTTygcPRvnYMpAU0kLKpBN8Lgg",
        appId: "1:993809756834:android:18e7a3e694522b376e1dfb",
        messagingSenderId: "993809756834",
        projectId: "voting-app-59654"),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          }
          return CircularProgressIndicator();
        });
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430, 932),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
         initialRoute: splash,
          getPages: getPages,
          //home: MainScreen(),
          //home: AdminHomePage(),
        home: SplashScreen(),
        );
      },
    );
  }
}
