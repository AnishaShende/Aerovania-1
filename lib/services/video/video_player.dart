import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerModel extends StatefulWidget {
  final String videoUrl;
  final String name;

  const VideoPlayerModel({super.key, required this.videoUrl, required this.name});

  @override
  State<VideoPlayerModel> createState() => _VideoPlayerModelState();
}

class _VideoPlayerModelState extends State<VideoPlayerModel> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _controller.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: _controller.value.aspectRatio,
        autoPlay: true,
        looping: false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? Chewie(
              controller: _chewieController!,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}


// // video_list_screen.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

// class VideoPlayer extends StatelessWidget {
//   final String videoUrl;

//   VideoPlayer({required this.videoUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Courses'),
//       ),
//       body: 
//       // StreamBuilder<QuerySnapshot>(
//       //   stream: FirebaseFirestore.instance
//       //       .collection(collectionPath)
//       //       .orderBy('timestamp')
//       //       .snapshots(),
//       //   builder: (context, snapshot) {
//       //     if (!snapshot.hasData) {
//       //       return Center(child: CircularProgressIndicator());
//       //     }

//       //     var videos = snapshot.data!.docs;

// // // Sort the videos by name
// //           videos.sort((a, b) {
// //             var aName = a['name'].split('.')[0];
// //             var bName = b['name'].split('.')[0];
// //             return aName.compareTo(bName);
// //           });

//           // getVideoName(String name) {
//           //   name.replaceAll(RegExp('mp4'), '');
//           //   return name.split('.')[1].toUpperCase();
//           // }

//           // return ListView.builder(
//           //   itemCount: videos.length,
//           //   itemBuilder: (context, index) {
//           //     var video = videos[index];
//           //     var videoUrl = video['url'];
//           //     var videoName = video['name'];

//         //       return ListTile(
//         //         title: Text(getVideoName(videoName)),
//         //         onTap: () {
//         //           Navigator.push(
//         //             context,
//         //             MaterialPageRoute(
//         //               builder: (context) =>
//         //                   VideoPlayerScreen(videoUrl: videoUrl),
//         //             ),
//         //           );
//         //         },
//         //       );
//         //     },
//         //   );
//         // },
//     //   ),
//     // );
//   }
// }

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerScreen({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   ChewieController? _chewieController;

//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }

//   Future<void> _initializePlayer() async {
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//     await _controller.initialize();
//     setState(() {
//       _chewieController = ChewieController(
//         videoPlayerController: _controller,
//         aspectRatio: _controller.value.aspectRatio,
//         autoPlay: true,
//         looping: false,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Player'),
//       ),
//       body: _chewieController != null &&
//               _chewieController!.videoPlayerController.value.isInitialized
//           ? Chewie(
//               controller: _chewieController!,
//             )
//           : const Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
