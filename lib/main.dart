import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidshare/firebase_options.dart';
import 'package:vidshare/components/persistant_bottom_nav.dart';
import 'package:vidshare/widgets/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    bool isLoggin = true;
  @override
  void initState() {
 
    super.initState();
    checkState();
  }

  checkState() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLoggin = true;
        });
      } else {
        setState(() {
          isLoggin = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: isLoggin? const  BottomNavBar():LoginPage(),
    );
  }
}
