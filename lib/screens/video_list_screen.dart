import 'package:flutter/material.dart';
import 'video_screen.dart'; // Đảm bảo import VideoScreen

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  // Danh sách video
  final List<Map<String, String>> videos = [
    {'title': 'Video 1', 'asset': '/sample_video.mp4'},
    {'title': 'Video 2', 'asset': '/sample_video2.mp4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video List")),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];

          return ExpansionTile(
            title: Text(video['title']!),
            leading: const Icon(Icons.video_library, size: 40),
            children: [
              ListTile(
                title: const Text("Play"),
                onTap: () {
                  // Khi nhấn vào một video, chuyển đến màn hình video
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoScreen(videoAsset: video['asset']!),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}