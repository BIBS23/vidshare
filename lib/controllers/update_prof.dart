import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UpdateProfile extends GetxController {
  String? uid;
  String? usrname;
  String? usrimg;
  String? usrbio;
  String? usruid;

  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('userprof');

  void createProfile(String username, String bio, String userimg) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      uid = user.uid;
      print("User UID: $uid");
    } else {
      print("User not signed in.");
    }
    collectionRef.doc(uid).set({
      'username': username,
      'bio': bio,
      'userimg': userimg,
    });
  }

  Future<DocumentSnapshot> fetchProfile() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      uid = user.uid;
      print("User UID: $uid");
    } else {
      print("User not signed in.");
    }

    print(uid);

    // Fetch the user's profile data from Firestore
    return await FirebaseFirestore.instance
        .collection('userprof')
        .doc(uid)
        .get();
  }

  Future<void> getProfileData() async {
    try {
      DocumentSnapshot profileSnapshot = await fetchProfile();

      if (profileSnapshot.exists) {
        // Access the data as a Map
        Map<String, dynamic> userData =
            profileSnapshot.data() as Map<String, dynamic>;

        usrname = userData['username'];
        usrimg = userData['userimg'];
        usrbio = userData['bio'];
        usruid = userData['uid'];


        print('fghfghfhfghfghfghfghfgh $usrbio');
      } else {
        print("Profile document does not exist.");
      }
    } catch (error) {
      print("Error fetching profile data: $error");
    }
  }
}
