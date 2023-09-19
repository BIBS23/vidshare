import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadPost extends GetxController {
  File? image;
  String? uid;
  String? imageUrl;
  String? usrimg;

  Future<void> uploadPost(
      String title,
      String description,
      String category,
      String path,
      String location,
      String username,
      String userimg,
      String type) async {
    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('users posts');

    //Create a reference for the image to be stored
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImageToUpload = referenceDirImages.child(fileName);

    image = File(path);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(path));
      //Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print('hwowowowowowo $imageUrl');
    } catch (error) {
      //Some error occurred
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      uid = user.uid;
      print("User UID: $uid");
    } else {
      print("User not signed in.");
    }

    DocumentSnapshot userprofile =
        await FirebaseFirestore.instance.collection('userprof').doc(uid).get();

    if (userprofile.exists) {
      // Access the data as a Map
      Map<String, dynamic> data = userprofile.data() as Map<String, dynamic>;

      // Access specific fields in the document
      username = data['username'];
      usrimg = data['userimg'];

      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('posts');

      try {
        collectionRef.add({
          'title': title,
          'description': description,
          'category': category,
          'posturl': imageUrl,
          'location': location,
          'username': username,
          'userimg': usrimg,
          'format': type,
        });
      } catch (e) {
        print('Error in uploading $e');
      }
    }
  }
}
