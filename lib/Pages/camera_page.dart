// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_uploader/Pages/pick_image.dart';
//
// import '../modal/media_source.dart';
//
// class CameraPageWidget extends StatelessWidget {
//   @override
//   File? video;
//   Widget build(BuildContext context) => Scaffold(
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   pickCameraMedia(context);
//                 },
//                 child: Icon(Icons.done_all),
//               ),
//             ),
//           ],
//         ),
//       );
//
//   Future pickCameraMedia(BuildContext context) async {
//     ModalRoute.of(context)?.settings.arguments;
//
//     final video = await ImagePicker().pickVideo(source: ImageSource.camera);
//
//     final file = File(video!.path);
//
//     Navigator.of(context).pop(file);
//   }
// }
