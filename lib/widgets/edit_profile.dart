import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vidshare/controllers/access_controller.dart';
import 'package:vidshare/controllers/update_prof.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? userimg;

    MediaController media = Get.put(MediaController());
    TextEditingController username = TextEditingController();
    TextEditingController userbio = TextEditingController();
    UpdateProfile prof = Get.put(UpdateProfile());

    Future<void> fetchAndSetUsername() async {
      // Fetch the username from Firebase using your UpdateProfile object (prof)
      await prof.getProfileData();

      // Set the username in the TextEditingController
      username.text = prof.usrname ?? ""; // Use ?? "" to handle null values
      userbio.text = prof.usrbio ?? "";
      userimg = prof.usrimg.toString();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: FutureBuilder(
            future: fetchAndSetUsername(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: ((BuildContext context) {
                                return AlertDialog(
                                  content: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          media.pickImage(ImageSource.camera);
                                         
                                        },
                                        child: const Card(
                                          child: Image(
                                              height: 80,
                                              width: 80,
                                              image: AssetImage(
                                                  'assets/camera.png')),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          media.pickImage(ImageSource.gallery);
                                          
                                        },
                                        child: const Card(
                                          child: Image(
                                              height: 80,
                                              width: 80,
                                              image: AssetImage(
                                                  'assets/gallery.png')),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }));
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: userimg!=''?NetworkImage(userimg.toString()): const NetworkImage(
                              'https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1-768x768.jpg')
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: username,
                      decoration: const InputDecoration(
                          hintText: "User Name", border: InputBorder.none),
                    ),
                    const Divider(
                        color: Color.fromARGB(188, 158, 158, 158),
                        height: 0.01),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: userbio,
                      decoration: const InputDecoration(
                          hintText: "User Bio", border: InputBorder.none),
                      maxLines: 1,
                    ),
                    const Divider(
                        color: Color.fromARGB(188, 158, 158, 158),
                        height: 0.01),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        prof.createProfile(
                            username.text, userbio.text, media.imageUrl.toString());
                        Navigator.pop(context);
                      },
                      child: const Text("Save Changes"),
                    ),
                  ],
                ),
              );
            }));
  }
}
