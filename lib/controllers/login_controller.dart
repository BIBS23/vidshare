import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidshare/widgets/login_page.dart';
import 'package:vidshare/widgets/otp_page.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    if (phoneNumber == '') {
      Get.snackbar(
        "Please enter the mobile number!",
        "Failed",
        colorText: Colors.white,
      );
    } else {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          // authentication successful, do something
        },
        verificationFailed: (FirebaseAuthException e) {
          // authentication failed, do something
        },
        codeSent: (String verificationId, int? resendToken) async {
          // code sent to phone number, save verificationId for later use
          String smsCode = ''; // get sms code from user
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode,
          );
          Get.to(const OtpPage(), arguments: [verificationId]);
          await auth.signInWithCredential(credential);
          // authentication successful, do something
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  Future signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future createUser(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  void logout() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut().then((value) {
      return Get.off(const LoginPage());
    });
  }
}
