import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_uploader/keys.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final String category;

  const VideoPlayerWidget({Key? key,required this.videoUrl, required this.title, required this.description, required this.category}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  String? videoUrl;
  @override
  void initState() {
    super.initState();
      videoPlayerController = VideoPlayerController.network(widget.videoUrl);
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: true,
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: () => debugPrint('My option works!'),
              iconData: Icons.chat,
              title: 'My localized title',
            ),
            OptionItem(
              onTap: () => debugPrint('Another option working!'),
              iconData: Icons.chat,
              title: 'Another localized title',
            ),
          ];
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController?.dispose();
    chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),

                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: Chewie(
                          controller: chewieController!,
                      ),
                  ),
                ),),
                Text(widget.title,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                Text(widget.description,style: TextStyle(fontSize: 20),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Category: "),
                    Text(widget.category),
                  ],
                ),

          ],
        ),
      ),
    );
  }
}
