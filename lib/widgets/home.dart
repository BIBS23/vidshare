import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chewie/chewie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChewieController> chewieControllers = [];

  @override
  void initState() {
    super.initState();
    initializeChewieControllers();
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose of Chewie controllers
    for (var controller in chewieControllers) {
      controller.dispose();
    }
  }

  void initializeChewieControllers() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    querySnapshot.docs.forEach((documentSnapshot) async {
      final String format = documentSnapshot['format'];
      if (format != '.jpeg') {
        final VideoPlayerController videoController =
            VideoPlayerController.network(documentSnapshot['posturl']);
        try {
          await videoController.initialize();
        } catch (e) {
          print('Video initialization error: $e');
        }
        

        final ChewieController chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: true, // Adjust autoplay behavior as needed
          looping: false, // Adjust looping behavior as needed
        );
        setState(() {
          chewieControllers.add(chewieController);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VidShare',
          style: GoogleFonts.satisfy(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];
                final description = documentSnapshot['description'];
                final isDescriptionOverflow =
                    _isDescriptionOverflow(description);

                // Check the 'format' field to determine whether it's an image or video
                final String format = documentSnapshot['format'];

               Widget mediaWidget;
if (format == '.jpeg' || format == '.jpg' || format == '.png') {
  // Display the image
  mediaWidget = Image(
    image: NetworkImage(documentSnapshot['posturl']),
  );
} else {
  // Display the video using Chewie if there are controllers available
  if (chewieControllers.isNotEmpty) {
    mediaWidget = Chewie(
      controller: chewieControllers.last, // Use the last controller
    );
  } else {
    mediaWidget = SizedBox.shrink(); // Return an empty widget if chewieControllers is empty
  }
}


                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 15),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    documentSnapshot['userimg'],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(documentSnapshot['username']),
                                    Text(documentSnapshot['location']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          mediaWidget, // Display either image or video
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  documentSnapshot['title'],
                                  textAlign: TextAlign.justify,
                                  maxLines: isDescriptionOverflow ? 2 : null,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Show a collapsed description with a "Read More" button
                                Text(
                                  description,
                                  textAlign: TextAlign.justify,
                                  maxLines: isDescriptionOverflow ? 2 : null,
                                ),
                                // Show "Read More" button only when description overflows
                                if (isDescriptionOverflow)
                                  GestureDetector(
                                    onTap: () {
                                      // Handle the "Read More" button tap
                                    },
                                    child: const Text(
                                      "Read More",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  bool _isDescriptionOverflow(String description) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: description,
        style: DefaultTextStyle.of(context).style,
      ),
      maxLines: 2, // Adjust this value based on your requirements
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    return textPainter.didExceedMaxLines;
  }
}
