// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// class VideoPlayerItem extends StatelessWidget {
//   final Reference? videoRef;
//
//   VideoPlayerItem(this.videoRef);
//   Future<void> downloadVideo() async {
//     // Code that uses await
//     leading: Image(image: NetworkImage(await videoRef!.getDownloadURL()));
//   }
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: videoRef?.getDownloadURL(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Column(
//             children: [
//               AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: VideoPlayer(VideoPlayerController.network(snapshot.data.toString())),
//               ),
//               ListTile(
//                 title: Text(videoRef!.name),
//                 onTap: downloadVideo,),
//             ],
//           );
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }