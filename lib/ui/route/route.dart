import 'package:get/get.dart';
import 'package:votingapp/admin_panel/admin_home_page.dart';
import 'package:votingapp/face_recognition/screens/register_screen.dart';
import 'package:votingapp/ui/views/auth/authentication_screen.dart';
import 'package:votingapp/ui/views/auth/pin_lock.dart';
import 'package:votingapp/ui/views/auth/sign_in.dart';
import 'package:votingapp/ui/views/auth/sign_up.dart';
import 'package:votingapp/ui/views/auth/user_form_email_screen.dart';
import 'package:votingapp/ui/views/auth/user_form_phone_screen.dart';
import 'package:votingapp/ui/views/main_screen.dart';

import '../views/splash_screen.dart';

const String splash = '/splash-screen';
const String onbording = '/onbording-screen';

const String homeScreen = '/home-screen';
const String loginSignUpScreen = '/login-signup-screen';
const String loginScreen = '/login-screen';
const String signUpScreen = '/signup-screen';
const String pinLockScreen = '/pinlock-screen';
const String userFormEmailScreen = '/userform-email-screen';
const String userFormPhoneScreen = '/userform-phone-screen';
const String emailVerifiScreen = '/email-verifi-screen';
const String createelectionScreen = '/create-ele-screen';
const String forgetScreen = '/forget-screen';
const String changepassScreen = '/changepass-screen';
const String adminhomepageScreen = '/admin-homepage-screen';
const String faceregisterscreen = '/face-reg-screen';




List<GetPage> getPages = [
  GetPage(
      name: splash,
      page: () => SplashScreen()
  ),
  GetPage(
      name: loginSignUpScreen,
      page: () => AuthenticationScreen()
  ),
  GetPage(
      name: loginScreen,
      page: () => Login()
  ),
  GetPage(
      name: signUpScreen,
      page: () => SignUp()
  ),
  GetPage(
      name: userFormEmailScreen,
      page: () => UserFormEmail()
  ),
  GetPage(
      name: userFormPhoneScreen,
      page: () => UserFormPhone()
  ),
  GetPage(
      name: homeScreen,
      page: () => MainScreen()
  ),
  
  GetPage(
      name: adminhomepageScreen,
      page: () => AdminHomePage()
  ),
  GetPage(
      name: pinLockScreen,
      page: () => PinLock()
  ),
  GetPage(
      name: faceregisterscreen,
      page: () => FaceRegisterScreen()
  ),







];