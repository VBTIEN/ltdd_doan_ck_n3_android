import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook-like Interface',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  AccountScreen(),
    );
  }
}

class AccountScreen extends StatefulWidget {
  final AuthService authService = AuthService();
   AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _showMore = false;
  bool _option1Expanded = false;
  bool _option2Expanded = false;
  bool _option3Expanded = false;

  final List<Map<String, dynamic>> _items = [
    {"icon": Icons.bookmark, "title": "Đã lưu"},
    {"icon": Icons.emoji_events, "title": "Kỷ niệm"},
    {"icon": Icons.pageview, "title": "Trang"},
    {"icon": Icons.ad_units, "title": "Trung tâm quảng cáo"},
    {"icon": Icons.favorite, "title": "Hen hò"},
    {"icon": Icons.video_label, "title": "Reels"},
    {"icon": Icons.videogame_asset, "title": "Chơi game"},
    {"icon": Icons.event, "title": "Sự kiện"},
    {"icon": Icons.visibility, "title": "Lướt thấy"},
    {"icon": Icons.face, "title": "Avatar"},
    {"icon": Icons.message, "title": "Messenger Kids"},
  ];

  final List<String> _imageAssets = [
    'assets/post_1.jpg',
    'assets/post_2.jpg',
    'assets/post_3.jpg',
    'assets/post_4.jpg',
    'assets/post_5.jpg',
    'assets/post_6.jpg',
    'assets/post_7.jpg',
    'assets/post_1.jpg',
    'assets/post_2.jpg',
    'assets/post_3.jpg',
    'assets/post_4.jpg',
    'assets/post_5.jpg',
    'assets/post_6.jpg',
    'assets/post_7.jpg',
    'assets/post_1.jpg',
    'assets/post_2.jpg',
    'assets/post_3.jpg',
    'assets/post_4.jpg',
    'assets/post_5.jpg',
    'assets/post_6.jpg',
    'assets/post_7.jpg',
  ];
  /*Future<bool> _logout() async {
    const url = 'http://localhost:5083/api/Authenticate/logout';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Sử dụng token từ SharedPreferences
        },
      );

      if (response.statusCode == 200) {
        // Xóa token trong SharedPreferences
        await prefs.remove('jwt_token');
        return true;
      } else {
        print('Lỗi khi đăng xuất: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi ngoại lệ khi đăng xuất: $e');
      return false;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[100],
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/post_7.jpg'),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Phan Hiếu Nghĩa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Title for shortcuts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                "Lối tắt của bạn",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),



            // Horizontal image list
            Container(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _imageAssets.map((image) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Options section
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              children: List.generate(
                _showMore ? _items.length : 6,
                    (index) {
                  return _buildGridItem(
                    _items[index]["icon"],
                    _items[index]["title"],
                  );
                },
              ),
            ),

            // Button section
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showMore = !_showMore;
                  });
                },
                child: Text(_showMore ? "Ẩn bớt" : "Xem thêm"),
              ),
            ),

            const SizedBox(height: 20),

            // Additional options section
            Column(
              children: [
                _buildExpandableButton(
                  title: "Trợ giúp & hỗ trợ",
                  isExpanded: _option1Expanded,
                  onPressed: () {
                    setState(() {
                      _option1Expanded = !_option1Expanded;
                    });
                  },
                  content: [
                    'Trung tâm và trợ giúp',
                    'Trạng thái tài khoản',
                    'Báo cáo sự cố',
                    'Hộp thư hỗ trợ',
                    'Điều khoản & chính sách',
                  ],
                ),
                const SizedBox(height: 10),
                _buildExpandableButton(
                  title: "Cài đặt & quyền riêng tư",
                  isExpanded: _option2Expanded,
                  onPressed: () {
                    setState(() {
                      _option2Expanded = !_option2Expanded;
                    });
                  },
                  content: [
                    'Cài đặt',
                    'Trung tâm quyền riêng tư',
                    'Yêu cầu từ thiết bị',
                    'Lịch sử liên kết',
                    'Ngôn ngữ',
                    'Đơn đặt hàng và thanh toán',
                  ],
                ),
                const SizedBox(height: 10),
                _buildExpandableButton(
                  title: "Cũng Từ Meta",
                  isExpanded: _option3Expanded,
                  onPressed: () {
                    setState(() {
                      _option3Expanded = !_option3Expanded;
                    });
                  },
                  content: [
                    'Messenger',
                    'Instagram',
                    'WhatsApp',
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Logout button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Hành động khi nhấn vào Đăng xuất
                  await widget.authService.logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                  ),
                  );
                  },
                child: const Text("Đăng xuất"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableButton({
    required String title,
    required bool isExpanded,
    required VoidCallback onPressed,
    required List<String> content,
  }) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 10),
          Column(
            children: content.map((text) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nhấn vào: $text')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.blue,
                    shadowColor: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(text, textAlign: TextAlign.left),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildGridItem(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // Thêm hành động khi nhấn
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}