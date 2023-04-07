import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_uploader/keys.dart';
import 'package:video_uploader/widgets/Custom_Text_Field.dart';
import '../modal/media_source.dart';
import 'Upload_Video.dart';

class PickImage extends StatefulWidget {
  const PickImage({Key? key}) : super(key: key);

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? result;
  File? fileMedia;

  File? videoFile;
  File? thumbnail;
  MediaSource? source;

  VideoPlayerController? videoPlayerController;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  Future capture(MediaSource source) async {
    setState(() {
      this.source = source;
      fileMedia = null;
    });
    final video = await ImagePicker().pickVideo(source: ImageSource.camera);

    setState(() {
      videoFile = File(video!.path);
    });

    final result = videoFile;

    if (result == null) {
      return;
    } else {
      setState(() {
        fileMedia = result;
      });
    }
  }

  Future<Uint8List?> getThumbnail(String videoFile) async {
    final thumbnailData = await VideoThumbnail.thumbnailData(
      video: videoFile,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 200,
      maxWidth: 200,
      quality: 75,
    );

    return thumbnailData;
  }

  Future<void> uploadVideo() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now().microsecondsSinceEpoch}.mp4');
      final ref2 = FirebaseStorage.instance
          .ref()
          .child('thumbnails/${DateTime.now().microsecondsSinceEpoch}.jpeg');

      if (videoFile != null) {
        await ref
            .putFile(videoFile!)
            .whenComplete(() => debugPrint("upload complete"));

        final uri = await ref.getDownloadURL();

        final awaitedThumbnail = await getThumbnail(videoFile!.path);
        await ref2
            .putData(awaitedThumbnail!)
            .whenComplete(() => debugPrint("thumbnail uploaded"));
        final thumbnailUri = await ref2.getDownloadURL();

        //get user location
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        double latitude = position.latitude;
        double longitude = position.longitude;
        final time = position.timestamp;
        position.accuracy;

        await FirebaseFirestore.instance.collection('user_data').add({
          "video_file_name": basename(videoFile!.path),
          "video_path": uri,
          "video_title": titleController.text,
          "video_description": descriptionController.text,
          "video_category": categoryController.text,
          "latitude": latitude,
          "longitude": longitude,
          "thumbnail_uri": thumbnailUri,
          "time": time
        });
      } else {
        Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: Text("No file Selected"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      Keys.scaffoldMessengerKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: fileMedia != null
                    ? Expanded(
                        child: VideoWidget(fileMedia!),
                      )
                    : const Icon(
                        Icons.video_camera_back_outlined,
                        color: Colors.black,
                        size: 200,
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                elevation: 2,
                backgroundColor: Colors.amber,
                child: const Icon(
                  Icons.video_call_sharp,
                  color: Colors.black,
                ),
                onPressed: () {
                  capture(MediaSource.video);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  hinttext: "Title",
                  controller: titleController,
                  prefixicon: Icons.title),
              CustomTextField(
                  hinttext: "Description",
                  controller: descriptionController,
                  prefixicon: Icons.description),
              CustomTextField(
                  hinttext: "Category",
                  controller: categoryController,
                  prefixicon: Icons.category),
              if (videoFile == null)
                const Text("No video selected")
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    onPressed: () {
                      uploadVideo();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Upload",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
