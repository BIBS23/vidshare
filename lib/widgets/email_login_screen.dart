import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vidshare/components/btn.dart';
import 'package:vidshare/components/persistant_bottom_nav.dart';
import 'package:vidshare/components/txt_field.dart';
import 'package:vidshare/controllers/login_controller.dart';
import 'package:vidshare/widgets/signup_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    LoginController signin = Get.put(LoginController());
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        MyTextField(
          hint: 'Email',
          obscureText: false,
          color: Colors.black38,
          controller: emailController,
        ),
        const SizedBox(
          height: 15,
        ),
        MyTextField(
          hint: 'Password',
          obscureText: true,
          color: Colors.black38,
          controller: passwordController,
        ),
        const SizedBox(height: 25),
        Btn(
            btntext: 'Sign in',
            onpressed: () async {
              FocusScope.of(context).unfocus();
              try {
                await signin
                    .signIn(emailController.text, passwordController.text)
                    .then((value) => Get.off(const BottomNavBar()));
              } on FirebaseAuthException catch (e) {
                emailController.clear();
                passwordController.clear();
                String errorMessage =
                    'An error occurred, please try again later.';
                if (e.code == 'user-not-found') {
                  errorMessage = 'No user found with that email address.';
                } else if (e.code == 'wrong-password') {
                  errorMessage = 'Wrong password provided for that user.';
                }
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(errorMessage)));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('An error occurred, please try again later.')));
              }
            }),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Not a member?', style: TextStyle(fontSize: 16)),
              GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Get.to(SignUpPage());
                  },
                  child: const Text('Register now',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ],
    ));
  }
}
