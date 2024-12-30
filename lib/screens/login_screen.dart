import 'package:flutter/material.dart';
import 'package:ltdd_doan_ck_n3_android/screens/registration_creen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/auth.dart';
import 'admin_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkToken(); // Kiểm tra token khi mở màn hình
  }

  // Kiểm tra token trong SharedPreferences
  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      // Nếu token tồn tại, chuyển hướng đến MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  // Hàm xử lý đăng nhập
  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Gọi Auth.login để xử lý đăng nhập
    Map<String, dynamic> result = await Auth.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      // Lưu token vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', result['token']); // Lưu token

      // Lấy vai trò người dùng từ token
      String role = result['decodedToken']['role'] ?? 'User'; // Thay đổi cách lấy vai trò

      if (role == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } else {
      // Hiển thị thông báo lỗi
      String errorMessage = result['message'] ?? 'Tên đăng nhập hoặc mật khẩu không đúng';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền
          Positioned.fill(
            child: Image.asset(
              'anh_nen.jpg', // Đường dẫn đến ảnh
              fit: BoxFit.cover, // Đảm bảo ảnh phủ toàn màn hình
            ),
          ),
          // Nội dung màn hình đăng nhập
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
//----------------------------------------------------------------
                    Stack(
                      alignment: Alignment.center, // Căn giữa cả chiều ngang và dọc
                      children: [
                        // Viền ngoài (Stroke)
                        Text(
                          'Driver Management App',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3 // Độ dày viền vừa phải
                              ..color = Colors.black.withOpacity(0.4), // Độ trong suốt giảm còn một nửa
                          ),
                        ),
                        // Chữ chính (Màu cyan + bóng mờ)
                        Text(
                          'Driver Management App',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan, // Màu chữ chính
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2), // Đổ bóng (X, Y)
                                blurRadius: 5, // Bóng mờ
                                color: Colors.black.withOpacity(0.5), // Màu bóng
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
//----------------------------------------------------------------
                    const SizedBox(height: 40),
                    TextField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Usrname',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.85), // Nền nhẹ hơn
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), // Góc bo tròn
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.cyan.shade700, width: 1.5), // Viền khi focus
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.grey.shade600), // Biểu tượng
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.85), // Nền nhẹ hơn
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.cyan.shade700, width: 1.5), // Viền khi focus
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey.shade600, // Biểu tượng
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600), // Biểu tượng
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
//----------------------------------------------------------------
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          // Thay đổi màu nền
                          backgroundColor: Colors.cyan, // Màu nền mặc định
                          foregroundColor: Colors.white, // Màu chữ "Đăng nhập"
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Bo tròn các góc
                          ),
                          elevation: 0, // Không có bóng
                        ).copyWith(
                          // Tùy chỉnh trạng thái hover (khi rê chuột vào nút)
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.cyan.shade700; // Màu đậm hơn khi hover
                              }
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.cyan.shade200; // Màu nhạt khi nút bị vô hiệu hóa
                              }
                              return Colors.cyan; // Màu mặc định
                            },
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Màu trắng cho ProgressIndicator
                          ),
                        )
                            : const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Màu chữ trắng
                          ),
                        ),
                      ),
                    ),
//----------------------------------------------------------------
                    const SizedBox(height: 20),
                    // Thêm điều hướng đến màn hình đăng ký
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Chưa có tài khoản? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                            );
                          },
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
