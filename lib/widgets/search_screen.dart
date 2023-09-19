import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isSearching = false;
  late Stream<QuerySnapshot> _stream;
  late TextEditingController _searchController;
    List<ChewieController> chewieControllers = [];

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance.collection('posts').snapshots();
    _searchController = TextEditingController();
     initializeChewieControllers();
  }

  void _handleSearch(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        _stream = FirebaseFirestore.instance.collection('posts').snapshots();
        _isSearching = false;
      });
    } else {
      String firstLetter = searchText.substring(0, 1);
      String secondLetter =
          searchText.length >= 2 ? searchText.substring(1, 2) : "";
      String thirdLetter =
          searchText.length >= 3 ? searchText.substring(2, 3) : "";
      String fourthLetter =
          searchText.length >= 4 ? searchText.substring(3, 4) : "";
      setState(() {
        _stream = FirebaseFirestore.instance
            .collection('posts')
            .where('title',
                isGreaterThanOrEqualTo:
                    firstLetter + secondLetter + thirdLetter + fourthLetter)
            .where('title',
                isLessThan:
                    '$firstLetter$secondLetter$thirdLetter${fourthLetter}z')
            .snapshots();
        _isSearching = true;
      });
    }
  }

  bool shouldDisplayListView = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    for (var controller in chewieControllers) {
      controller.dispose();
    }
  }

  void initializeChewieControllers() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    querySnapshot.docs.forEach((documentSnapshot) {
      final String format = documentSnapshot['format'];
      if (format != '.jpeg') {
        final VideoPlayerController videoController =
            VideoPlayerController.network(documentSnapshot['posturl']);
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
        title: Card(
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: _searchController,
            onChanged: _handleSearch,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
              hintText: 'Search by title',
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data'));
          } else {
            return _isSearching
                ? ListView.builder(
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
                      if (format == '.jpeg') {
                        // Display the image
                        mediaWidget = Image(
                          image: NetworkImage(documentSnapshot['posturl']),
                        );
                      } else {
                           final int chewieIndex = chewieControllers.isNotEmpty
                      ? chewieControllers.length - 1
                      : 0;
                  mediaWidget = SizedBox(
                    width: 500,
                    height: 200,
                    child: Chewie(
                      controller: chewieControllers[chewieIndex],
                    ),
                  );
               
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                color: Colors.black,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      maxLines:
                                          isDescriptionOverflow ? 2 : null,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Show a collapsed description with a "Read More" button
                                    Text(
                                      description,
                                      textAlign: TextAlign.justify,
                                      maxLines:
                                          isDescriptionOverflow ? 2 : null,
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
                      );
                    },
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                     

                      // Check the 'format' field to determine whether it's an image or video
                      final String format = documentSnapshot['format'];

                      Widget mediaWidget;
                      if (format == '.jpeg') {
                        // Display the image
                        mediaWidget = Image(
                          image: NetworkImage(documentSnapshot['posturl']),
                        );
                      } else {
                        // Display the video
                        final int chewieIndex = chewieControllers.isNotEmpty
                      ? chewieControllers.length - 1
                      : 0;
                  mediaWidget = Chewie(
                    controller: chewieControllers[chewieIndex],
                  );
               
                      
                      }

                      return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            elevation: 3,
                            child: mediaWidget, // Display either image or video
                          ));
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
