import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/statusPost.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String baseUrl = 'https://smallaquamouse33.conveyor.cloud/api/StatusApi';  // API URL cho các bài viết
  late Future<List<StatusPost>> postsFuture;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    postsFuture = fetchPosts(); // Lấy danh sách bài viết ban đầu
  }

  // Lấy danh sách bài viết từ API
  Future<List<StatusPost>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl)); // Dùng API mới
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => StatusPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Thêm bài viết mới
  Future<void> addPost(StatusPost status) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(status.toJson()),
    );
    if (response.statusCode == 201) {
      setState(() {
        postsFuture = fetchPosts(); // Cập nhật danh sách bài viết sau khi thêm
      });
    } else {
      throw Exception('Failed to add post');
    }
  }

  // Sửa bài viết
  Future<void> editPost(StatusPost post) async {
    final TextEditingController nameController = TextEditingController(text: post.name);
    final TextEditingController contentController = TextEditingController(text: post.content);
    final TextEditingController imageController = TextEditingController(text: post.image);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Post Name'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),

              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup nếu bấm Cancel
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                StatusPost updatedPost = StatusPost(
                  id: post.id!,
                  name: nameController.text,
                  image: imageController.text,
                  content: contentController.text,
                );
                await updatePost(updatedPost);
                Navigator.of(context).pop(); // Đóng popup khi bấm Save
              },
            ),
          ],
        );
      },
    );
  }

  // Cập nhật bài viết trong API
  Future<void> updatePost(StatusPost status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${status.id}'),  // Dùng URL API với ID bài viết
      headers: {'Content-Type': 'application/json'},
      body: json.encode(status.toJson()),
    );
    if (response.statusCode == 200) {
      setState(() {
        postsFuture = fetchPosts(); // Cập nhật lại danh sách bài viết
      });
    } else {
      throw Exception('Failed to update post');
    }
  }

  // Xóa bài viết
  Future<void> deletePost(int statusId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$statusId'),  // Dùng URL API với ID bài viết
    );
    if (response.statusCode == 200) {
      setState(() {
        postsFuture = fetchPosts();
      });
    } else {
      throw Exception('Failed to delete post');
    }
  }

  // Hiển thị hộp thoại thêm bài viết mới
  void _showAddPostDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Post'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Post Name'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),

              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup nếu bấm Cancel
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                StatusPost newPost = StatusPost(
                  id: 0,
                  name: nameController.text,
                  image: imageController.text,
                  content: contentController.text,
                );
                await addPost(newPost);
                Navigator.of(context).pop(); // Đóng popup sau khi thêm bài viết
              },
            ),
          ],
        );
      },
    );
  }

  // Tìm kiếm bài viết
  void _handleSearch() async {
    String query = searchController.text.trim();
    if (query.isNotEmpty) {
      try {
        List<StatusPost> results = await searchPosts(query);
        setState(() {
          postsFuture = Future.value(results);  // Cập nhật danh sách với kết quả tìm kiếm
        });
      } catch (e) {
        _showErrorDialog('No posts found');
      }
    }
  }

  // Hiển thị thông báo lỗi
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Tìm kiếm bài viết từ API
  Future<List<StatusPost>> searchPosts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?search=$query'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => StatusPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "facebook",
          style: TextStyle(
            color: Colors.blue[800], // Màu xanh đặc trưng của Facebook
            fontSize: 32,            // Kích thước lớn hơn
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',     // Font gần giống với Facebook
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),  // Icon dấu cộng
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),  // Icon kính lúp
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.message, color: Colors.black),  // Icon Messenger
            onPressed: () {},
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.cyan,
              floating: true,
              pinned: false,
              snap: true,
              expandedHeight: 80.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/post_1.jpg'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Bạn đang nghĩ gì?",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onSubmitted: (_) => _handleSearch(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder<List<StatusPost>>(
          future: postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No posts available.'));
            }

            List<StatusPost> posts = snapshot.data!;

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                StatusPost post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage('assets/post_1.jpg'),
                        ),
                        title: Text(post.name ?? 'Unknown'),
                        subtitle: Text('5 minutes ago'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(post.content ?? 'No content available'),
                      ),
                      if (post.image != null && post.image!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            post.image!,
                            width: 200, height: 200,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text('Share'),
                            ),
                            // Nút Edit
                            TextButton(
                              onPressed: () {
                                editPost(post);
                              },
                              child: const Text('Edit'),
                            ),
                            // Nút Delete
                            TextButton(
                              onPressed: () {
                                deletePost(post.id!);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
