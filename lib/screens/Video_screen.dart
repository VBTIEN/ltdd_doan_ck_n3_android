import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  // Danh sách video (bao gồm tên video và đường dẫn đến tài nguyên)
  final List<Map<String, String>> videos = [
    {'title': 'Video 1', 'asset': 'assets/sample_video.mp4'},
    {'title': 'Video 2', 'asset': 'assets/sample_video.mp4'},
    {'title': 'Video 3', 'asset': 'assets/sample_video.mp4'},
    {'title': 'Video 4', 'asset': 'assets/sample_video.mp4'},
    // có thể thêm nhiều video ở đây
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video List")),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];

          return ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading:const Icon(Icons.video_library, size: 40), // Thêm icon video
            title: Text(video['title']!), // Tiêu đề video
            onTap: () {
              // Khi nhấn vào một video, chuyển đến màn hình video
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoScreen(videoAsset: video['asset']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String videoAsset;

  const VideoScreen({super.key, required this.videoAsset});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video: ${widget.videoAsset}")),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.7,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Text(
                _controller.value.isPlaying ? "Pause" : "Play",
              ),
            ),
          ],
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
