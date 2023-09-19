import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:vidshare/components/persistant_bottom_nav.dart';
import 'package:vidshare/controllers/location_controller.dart';
import 'package:vidshare/controllers/update_prof.dart';
import 'package:vidshare/controllers/upload_post.dart';

class EditPostPage extends StatefulWidget {
  final AssetEntity selectedAsset;

  const EditPostPage({super.key, required this.selectedAsset});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? username;
    String? profimg;
    String? assetFilePath;
    String? location;
    UploadPost post = Get.put(UploadPost());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        actions: [
          IconButton(
              onPressed: () async {
                // Check if location permission is granted
                PermissionStatus status = await Permission.location.request();

                if (status.isGranted) {
                  // Location permission granted, you can now access the user's location

                  // Assuming you have an AssetEntity named 'asset'
                  final File? file = await widget.selectedAsset.file;
                  if (file != null) {
                    assetFilePath = file.path;
                  }

                  LocationController locate = Get.put(LocationController());
                  UpdateProfile prof = Get.put(UpdateProfile());
                  await prof.getProfileData().then((value) {
                    username = prof.usrname.toString();
                    profimg = prof.usrimg.toString();
                  });

                  await locate.getLocation().then((value) {
                    location = locate.lok.toString();
                    print('$location');
                  }); // Get the current location
                } else {
                  // Location permission denied, handle accordingly
                }

                String getFileExtension(String url) {
                  int lastIndex = url.lastIndexOf('.');
                  if (lastIndex != -1) {
                    return url.substring(lastIndex);
                  }
                  return '';
                }

                String type = getFileExtension(assetFilePath.toString());

                post
                    .uploadPost(
                      titleController.text,
                      descriptionController.text,
                      categoryController.text,
                      assetFilePath.toString(),
                      location.toString(),
                      username.toString(),
                      profimg.toString(),
                      type,
                    )
                    .then((value) => Get.off(const BottomNavBar()));
                print(assetFilePath);
              },
              icon: const Icon(Icons.arrow_forward))
        ],
        title: const Text("Edit Post"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the selected media preview
            Row(
              children: [
                Image(
                  image: AssetEntityImageProvider(widget.selectedAsset),
                  fit: BoxFit.cover,
                  height: 90,
                  width: 100,
                ),
                const SizedBox(width: 40),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 20),
                        hintText: 'Title',
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(
                color: Color.fromARGB(188, 158, 158, 158), height: 0.01),

            const SizedBox(height: 16),
            // Description input field
            TextFormField(
                textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              controller: descriptionController,
              decoration: const InputDecoration(
                  hintText: "Description", border: InputBorder.none),
              maxLines: 1,
            ),
            const Divider(
                color: Color.fromARGB(188, 158, 158, 158), height: 0.01),
            // Category input field
            const SizedBox(height: 5),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: categoryController,
              decoration: const InputDecoration(
                  hintText: "Category", border: InputBorder.none),
            ),
            const SizedBox(height: 5),
            const Divider(
                color: Color.fromARGB(188, 158, 158, 158), height: 0.01),
          ],
        ),
      ),
    );
  }
}
