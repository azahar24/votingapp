import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:votingapp/ui/route/route.dart';
import 'package:votingapp/ui/views/auth/resend_email_link.dart';
import 'package:votingapp/ui/views/auth/user_form_email_screen.dart';
import 'package:votingapp/ui/widgets/deepsea_button.dart';

class Auth {
  final box = GetStorage();
  TextEditingController _otpCon = TextEditingController();

  Future registration(String emailAddress, String password, context) async {
    try {
      UserCredential usercredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);

      var user = usercredential.user;
      print(user);
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification email sent. Please check your inbox.')),
          
        );
        Future.delayed(Duration(seconds: 3), (){
          Get.to(ResendEmailLink());
        });

        //Get.to(UserFormEmail());
      } else {
        print('Sign up failed');
        Fluttertoast.showToast(msg: 'Sign up failed');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error is : $e');
    }
  }

Future<void> login(String emailAddress, String password, BuildContext context) async {
  try {
    // Attempt to sign in
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);

    final authCredential = userCredential.user;

    if (authCredential != null) {
      if (authCredential.emailVerified) {
        // Fetch user data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('user-form-data')
            .doc(authCredential.uid)
            .get();

        if (userDoc.exists) {
          // Check if 'name' or 'dob' is empty
          final userData = userDoc.data() as Map<String, dynamic>;
          final String? name = userData['name'];
          final String? dob = userData['dob'];

          if (name != null && name.isNotEmpty && dob != null && dob.isNotEmpty) {
            Fluttertoast.showToast(
              msg: 'Login Successful',
              backgroundColor: Colors.green,
            );
            box.write('uid', authCredential.uid);
            Get.toNamed(homeScreen); // Redirect to home screen
          } else {
            Fluttertoast.showToast(
              msg: 'Please complete your profile details.',
              backgroundColor: Colors.orange,
            );
            Get.to(UserFormEmail());// Redirect to user form screen
          }
        } else {
          // User document doesn't exist in Firestore
          Fluttertoast.showToast(
            msg: 'User data not found. Redirecting to profile form.',
            backgroundColor: Colors.orange,
          );
          Get.to(UserFormEmail()); // Redirect to user form screen
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Email not verified. Please verify your email.',
          backgroundColor: Colors.red,
        );
        Future.delayed(Duration(seconds: 3), () {
          Get.to(ResendEmailLink());
        });
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(
        msg: 'No user found for that email.',
        backgroundColor: Colors.red,
      );
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(
        msg: 'Wrong password provided.',
        backgroundColor: Colors.red,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Sign in failed: ${e.message}',
        backgroundColor: Colors.red,
      );
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: 'An unexpected error occurred: $e',
      backgroundColor: Colors.red,
    );
  }
}



  phoneAuth(number, context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential _userCredential =
            await auth.signInWithCredential(credential);

        User? _user = _userCredential.user;
        if (_user!.uid.isNotEmpty) {
          Get.toNamed(userFormPhoneScreen);
        } else {
          Fluttertoast.showToast(msg: 'Sign up failed');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('Enter Your Otp'),
                content: Container(
                  height: 200.h,
                  child: Column(
                    children: [
                      TextField(
                        controller: _otpCon,
                      ),
                      SizedBox(height: 10.h,),
                      DeepseaButton(
                          text: "Continue",
                          onAction: () async {
                            PhoneAuthCredential _phoneAuthCredential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: _otpCon.text);
                                    UserCredential _userCredential =
                              await auth.signInWithCredential(_phoneAuthCredential);
                  
                          User? _user = _userCredential.user;
                          if (_user!.uid.isNotEmpty) {
                            Get.toNamed(userFormPhoneScreen);
                          } else {
                            Fluttertoast.showToast(msg: 'Sign up failed');
                          }
                          })
                    ],
                  ),
                ),
              );
            }
            );
      },
      timeout: Duration(minutes: 2),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
  //phon auth signup

  phoneAuthlogin(number, context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signInWithPhoneNumber(number, ).whenComplete((){
      Get.toNamed(pinLockScreen);
    });

    

    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: number,
    //   verificationCompleted: (PhoneAuthCredential credential) async {
    //     UserCredential _userCredential =
    //         await auth.signInWithCredential(credential);

    //     User? _user = _userCredential.user;
    //     box.write('uid', _user!.uid);
    //     if (_user!.uid.isNotEmpty) {
    //       Get.toNamed(pinLockScreen);
    //     } else {
    //       Fluttertoast.showToast(msg: 'Sign up failed');
    //     }
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     if (e.code == 'invalid-phone-number') {
    //       print('The provided phone number is not valid.');
    //     }
    //   },
    //   codeSent: (String verificationId, int? resendToken) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text('Enter Your Otp'),
    //             content: Container(
    //               height: 200.h,
    //               child: Column(
    //                 children: [
    //                   TextField(
    //                     controller: _otpCon,
    //                   ),
    //                   SizedBox(height: 10.h,),
    //                   DeepseaButton(
    //                       text: "Continue",
    //                       onAction: () async {
    //                         PhoneAuthCredential _phoneAuthCredential =
    //                             PhoneAuthProvider.credential(
    //                                 verificationId: verificationId,
    //                                 smsCode: _otpCon.text);
    //                                 UserCredential _userCredential =
    //                           await auth.signInWithCredential(_phoneAuthCredential);
                  
    //                       User? _user = _userCredential.user;
    //                       if (_user!.uid.isNotEmpty) {
    //                         Get.toNamed(pinLockScreen);
    //                       } else {
    //                         Fluttertoast.showToast(msg: 'Sign up failed');
    //                       }
    //                       })
    //                 ],
    //               ),
    //             ),
    //           );
    //         });
    //   },
    //   timeout: Duration(minutes: 2),
    //   codeAutoRetrievalTimeout: (String verificationId) {},
    // );
  }
}
