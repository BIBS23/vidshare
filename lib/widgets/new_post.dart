import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:vidshare/controllers/access_controller.dart';
import 'package:vidshare/controllers/update_prof.dart';
import 'package:vidshare/widgets/edit_post.dart';
import 'package:permission_handler/permission_handler.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  List<AssetEntity> assets = [];

  @override
  void initState() {
    super.initState();
    getAssets();
    checkUserDataAndInitialize();
  }

  Future<void> getAssets() async {
    final FilterOptionGroup filter = FilterOptionGroup();
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      filterOption: filter,
    );

    if (albums.isNotEmpty) {
      final recentAlbum = albums.first;
      final assets = await recentAlbum.getAssetListRange(start: 0, end: 50000);
      setState(() {
        this.assets = assets;
        // Add a dummy asset at the beginning for the "Use Camera" tile
        this.assets.insert(
            0,
            const AssetEntity(
                title: 'Camera',
                id: 'camera_tile',
                height: 50,
                width: 50,
                typeInt: 1));
      });
    }
  }

  Future<void> checkUserDataAndInitialize() async {
    UpdateProfile prof = Get.put(UpdateProfile());
    prof.fetchProfile();
    // Query Firestore to check if user data is present
    final userDataSnapshot = await FirebaseFirestore.instance
        .collection('userprof')
        .doc(prof.uid)
        .get();

    final userData = userDataSnapshot.data() as Map<String, dynamic>?;

    if (userData != null) {
      // User data is present, initialize assets
      getAssets();
    } else {
      // User data is not present, show a dialog to create profile and enable location
      showCreateProfileDialog();
    }
  }

  Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      // Location permission granted, you can now enable location services
    } else if (status.isDenied) {
      // Location permission denied, show a message to the user
    } else if (status.isPermanentlyDenied) {
      // Location permission permanently denied, open app settings
      openAppSettings();
    }
  }

  void showCreateProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Create Profile'),
          content: Text('Please create your profile and enable location.'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("New Post"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
        ),
        itemCount: assets.length,
        itemBuilder: (BuildContext context, int index) {
          final asset = assets[index];
          if (asset.id == 'camera_tile') {
            // Display the "Use Camera" tile
            return GestureDetector(
              onTap: () {
                MediaController media = Get.put(MediaController());

                showDialog(
                    barrierLabel: 'Choose',
                    barrierColor: const Color.fromARGB(113, 255, 255, 255),
                    context: context,
                    builder: ((BuildContext context) {
                      return AlertDialog(
                        backgroundColor: const Color.fromARGB(132, 0, 0, 0),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                media.pickVideo(ImageSource.camera);
                              },
                              child: const Card(
                                child: Image(
                                    height: 80,
                                    width: 80,
                                    image: AssetImage('assets/gallery.png')),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                media.pickImage(ImageSource.camera);
                              },
                              child: const Card(
                                child: Image(
                                    height: 80,
                                    width: 80,
                                    image: AssetImage('assets/camera.png')),
                              ),
                            ),
                          ],
                        ),
                      );
                    }));

      
              },
              child: const GridTile(
                child: Icon(
                  Icons.camera_alt,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                Get.to(EditPostPage(selectedAsset: asset));
              },
              child: GridTile(
                child: Image(
                  image: AssetEntityImageProvider(asset),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
