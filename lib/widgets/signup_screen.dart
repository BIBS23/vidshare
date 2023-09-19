import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidshare/components/persistant_bottom_nav.dart';
import 'package:vidshare/components/txt_field.dart';
import 'package:vidshare/controllers/login_controller.dart';
import '../components/btn.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    LoginController signup = Get.put(LoginController());
      TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [
              0,
              0.5,
              1
            ],
                colors: [
              Colors.grey.shade200,
              Colors.blue.shade100,
              Colors.blueAccent.withOpacity(0.3),
            ])),
        child: Column(children: [
          const SizedBox(height: 200),
          Text('Create Account',
              style: TextStyle(fontSize: 25, color: Colors.grey.shade700)),
          const SizedBox(height: 20),
          MyTextField(
              obscureText: false,
              controller: emailController,
              hint: 'Email',
              color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 15),
          MyTextField(
              obscureText: true,
              controller: passwordController,
              hint: 'Password',
              color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 15),
          MyTextField(
              obscureText: true,
              controller: passwordController,
              hint: 'Confirm Password',
              color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 20),
          Btn(
              btntext: 'Sign Up',
              onpressed: () {
                signup
                    .createUser(emailController.text, passwordController.text)
                    .then((_) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavBar())));
              }),
        ]),
      ),
    ));
  }
}
