import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video screen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          takeVideoFromLocalStorage();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: getUploadedVideos(),
          builder: (_, snap) {
            var videos = snap.data?.docs;
            if (videos?.isNotEmpty == true) {
              return ListView.builder(
                  itemCount: videos?.length,
                  itemBuilder: (_, index) {
                    return SizedBox(
                      height: 500,
                      child: AppVideoPlayer(
                          videoUrl: videos![index].data()['url']),
                    );
                    // return showPdfView(videos![index].data()['url']);
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  takeVideoFromLocalStorage() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );
    if (result != null) {
      var files = result.files.map((path) => File(path.path!)).toList();
      for (var singleFile in files) {
        uploadPdf(singleFile);
        print(singleFile.path);
      }
      print(files.first.path);
    }
  }

  uploadPdf(File file) {
    var storage = FirebaseStorage.instance;
    storage
        .ref("videos")
        .child(file.path.split("/").last)
        .putFile(file)
        .then((value) async {
      var pdfUrl = await value.ref.getDownloadURL();
      print(pdfUrl);
      FirebaseFirestore.instance.collection("videos").add({"url": pdfUrl});
      Fluttertoast.showToast(msg: "Pdf uploaded");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUploadedVideos() {
    var instance = FirebaseFirestore.instance.collection("videos");
    return instance.snapshots();
  }
}

class AppVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const AppVideoPlayer({super.key, required this.videoUrl});

  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: videoPlayer()),
    );
  }

  Widget videoPlayer() {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              VideoPlayer(_controller),
              Positioned(
                  bottom: 10,
                  child: IconButton(
                      onPressed: () {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                        setState(() {

                        });
                      },
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 35,
                        color: Colors.white,
                      )))
            ],
          )
        : Container(
            child: const Text("Video not playing"),
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
