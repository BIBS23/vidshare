import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidshare/controllers/login_controller.dart';
import 'package:vidshare/controllers/update_prof.dart';
import 'package:vidshare/widgets/edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    UpdateProfile prof = Get.put(UpdateProfile());
    LoginController user = Get.put(LoginController());
    prof.fetchProfile();

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: GoogleFonts.satisfy(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userprof')
            .doc(prof.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData != null) {
            final userImg = userData['userimg'] as String;
            final username = userData['username'] as String;
            final bio = userData['bio'] as String;

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      radius: 60, backgroundImage: NetworkImage(userImg)),
                  const SizedBox(height: 20),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bio,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                     const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(const EditProfileScreen());
                        },
                        child: const Card(
                          color: Colors.black45,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              'Edit profile',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          user.logout();
                        },
                        child: const Card(
                          color: Colors.black45,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          } else {
            // If the user profile data is not available, show the default image and text
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1-768x768.jpg',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'add username',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'add bio',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(const EditProfileScreen());
                        },
                        child: const Card(
                          color: Colors.black45,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              'Edit profile',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          user.logout();
                        },
                        child: const Card(
                          color: Colors.black45,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
