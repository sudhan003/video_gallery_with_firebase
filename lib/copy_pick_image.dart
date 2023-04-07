// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
//
// import 'package:video_player/video_player.dart';
// import 'package:video_uploader/Pages/camera_page.dart';
// import 'package:video_uploader/widgets/Custom_Text_Field.dart';
// import 'package:video_uploader/widgets/auth_button.dart';
//
// import '../modal/media_source.dart';
// import 'Upload_Video.dart';
//
// class PickImage extends StatefulWidget {
//   const PickImage({Key? key}) : super(key: key);
//
//   @override
//   State<PickImage> createState() => _PickImageState();
// }
//
// class _PickImageState extends State<PickImage> {
//   File? result;
//   File? fileMedia;
//
//   File? videoFile;
//   MediaSource? source;
//
//   VideoPlayerController? videoPlayerController;
//
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController categoryController = TextEditingController();
//
//   Future capture(MediaSource source) async {
//     setState(() {
//       this.source = source;
//       this.fileMedia = null;
//     });
//     final video = await ImagePicker().pickVideo(source: ImageSource.camera);
//
//     // final file = File(video!.path);
//
//     // Navigator.of(context).pop(file);
//
//     // await Navigator.of(context).push(
//     //   MaterialPageRoute(
//     //     builder: (context) => CameraPageWidget(),
//     //     settings: RouteSettings(
//     //       arguments: source,
//     //     ),
//     //   ),
//     // );
//     setState((){
//       videoFile = File(video!.path);
//     });
//     final result = videoFile;
//     // Navigator.of(context).pop(videoFile);
//
//     if (result == null) {
//       return;
//     } else {
//       setState(() {
//
//         fileMedia = result;
//       });
//     }
//   }
//
//   // Future pickCameraMedia(BuildContext context) async {
//   //   ModalRoute.of(context)?.settings.arguments;
//   //
//   //   final video = await ImagePicker().pickVideo(source: ImageSource.camera);
//   //   setState((){
//   //     videoFile = File(video!.path);
//   //   });
//   //
//   //   Navigator.of(context).pop(videoFile);
//   // }
//
//   uploadVideo() async {
//     try {
//       // final file = File(result!.path);
//       // final ref = FirebaseStorage.instance
//       //     .ref()
//       //     .child("videos")
//       //     .child(basename(fileMedia!.path));
//       // await ref
//       //     .putFile(fileMedia!)
//       //     .whenComplete(() => debugPrint("Video upload completed"));
//       print("phase 1");
//       FirebaseStorage storage = FirebaseStorage.instance;
//       Reference storageReference = storage
//           .ref()
//           .child('videos/${DateTime.now().microsecondsSinceEpoch}.mp4');
//       print('PHASE 2');
//       if (videoFile != null) {
//         UploadTask uploadTask = storageReference.putFile(videoFile!);
//         await uploadTask.whenComplete(() => print('Video uploaded'));
//       } else {
//         print('No video file selected');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//                 child: fileMedia != null
//                     ? VideoWidget(fileMedia!)
//                     : Icon(Icons.image)),
//             ElevatedButton(
//               child: const Icon(Icons.video_call_sharp),
//               onPressed: () {
//                 capture(MediaSource.video);
//               },
//             ),
//             CustomTextField(
//                 hinttext: "Title",
//                 controller: titleController,
//                 prefixicon: Icons.title),
//             CustomTextField(
//                 hinttext: "Description",
//                 controller: descriptionController,
//                 prefixicon: Icons.description),
//             CustomTextField(
//                 hinttext: "Category",
//                 controller: categoryController,
//                 prefixicon: Icons.category),
//             const Spacer(),
//             if (videoFile == null)
//               const Text("No video selected")
//             else
//               Image.file(videoFile!),
//             ElevatedButton(
//               onPressed: uploadVideo,
//               child: const Text("Upload Video"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
