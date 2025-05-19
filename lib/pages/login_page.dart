import 'package:eye_hours/Home_Screen.dart';
import 'package:eye_hours/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http; // إضافة حزمة http للتعامل مع API
import 'dart:convert'; // للتعامل مع بيانات JSON
import 'package:shared_preferences/shared_preferences.dart'; // لتخزين رمز المصادقة JWT

// إضافة نموذج لاستجابة API
class AuthResponse {
  final String token;
  final String userId;
  final String message;
  final bool success;

  AuthResponse({
    required this.token,
    required this.userId,
    required this.message,
    required this.success,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}

// إضافة خدمة API للمصادقة
class AuthService {
  static const String baseUrl =
      'https://your-api-domain.com'; // استبدل هذا بعنوان API الخاص بك

  // دالة تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  static Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/AuthUser/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      // إذا لم تنجح العملية، قم برمي استثناء مع الرسالة المناسبة
      final errorJson = jsonDecode(response.body);
      final errorMessage = errorJson['message'] ?? 'Failed to login';
      throw Exception(errorMessage);
    }
  }

  // حفظ رمز المصادقة في التخزين المحلي
  static Future<void> saveToken(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_id', userId);
  }

  // الحصول على رمز المصادقة من التخزين المحلي
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // مسح رمز المصادقة عند تسجيل الخروج
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  // تعديل دالة تسجيل الدخول لاستخدام API بدلاً من Firebase مباشرة
  Future<void> _signInWithEmailPassword() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('البريد الإلكتروني وكلمة المرور لا يمكن أن يكونا فارغين');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // استدعاء API للمصادقة
      final authResponse = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (authResponse.success) {
        // حفظ الرمز والمعرف
        await AuthService.saveToken(authResponse.token, authResponse.userId);

        // بعد ذلك يمكنك استخدام Firebase للمصادقة إذا كنت بحاجة للاستمرار مع Firebase
        // هذا مثال لكيفية استخدام الرمز المخصص مع Firebase
        try {
          await FirebaseAuth.instance.signInWithCustomToken(authResponse.token);
        } catch (e) {
          // يمكنك التعامل مع أخطاء Firebase هنا إذا لزم الأمر
          print('Firebase custom token sign in failed: $e');
          // لكن يمكننا الاستمرار طالما أننا حصلنا على استجابة ناجحة من API الخاص بنا
        }

        _navigateToHome();
      } else {
        _showError(authResponse.message);
      }
    } catch (e) {
      if (e is Exception) {
        _showError(e.toString().replaceAll('Exception: ', ''));
      } else {
        _showError('حدث خطأ أثناء تسجيل الدخول: $e');
      }
    }
  }

  // Facebook login
  Future<void> _signInWithFacebook() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        // Sign in with the credential
        await FirebaseAuth.instance.signInWithCredential(credential);
        _navigateToHome();
      } else {
        _showError('Facebook login canceled or failed');
      }
    } catch (e) {
      _showError('Facebook sign in failed: $e');
    }
  }

  // Google login
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        _showError('Google sign in canceled');
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      _showError('Google sign in failed: $e');
    }
  }

  // Apple login
  Future<void> _signInWithApple() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Request credential for the user
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuthCredential
      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      _showError('Apple sign in failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام خاصية resizeToAvoidBottomInset لتجنب مشكلات العرض عند فتح لوحة المفاتيح
      resizeToAvoidBottomInset: true,
      body: Container(
        // جعل الحاوية الرئيسية تملأ الشاشة بالكامل
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/image/13c6e78b3aaa64d3f113da8db3d7773b.jpg'), // صوره الخلفيه لل Login
            fit: BoxFit.cover,
          ),
        ),
        // استخدام SingleChildScrollView بدلاً من ListView للمرونة أكثر
        child: SingleChildScrollView(
          // تمكين التمرير عند ظهور لوحة المفاتيح لتجنب مشكلة overflow
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            // تحديد ارتفاع الحاوية لتكون بحجم الشاشة على الأقل
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                // استخدام IntrinsicHeight لضمان أن المحتوى يملأ الارتفاع المطلوب
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // إضافة مساحة إضافية في الأعلى للتأكد من عدم اختفاء العناصر
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: _navigateToRegisterPage,
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Error message
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      // Email field
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            size: 28,
                            color: Colors.black87,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      // Password field
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 28,
                            color: Colors.black87,
                          ),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          suffixIcon: TextButton(
                            onPressed: () {
                              // Navigate to forgot password screen
                            },
                            child: const Text(
                              'Forgot?',
                              style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        obscureText: true,
                      ),
                      const SizedBox(height: 40),
                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isLoading ? null : _signInWithEmailPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Or divider
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Colors.black54)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Social login buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Facebook login
                          InkWell(
                            onTap: _isLoading ? null : _signInWithFacebook,
                            borderRadius: BorderRadius.circular(24),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.blue[800],
                              child: const Text(
                                'f',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Google login
                          InkWell(
                            onTap: _isLoading ? null : _signInWithGoogle,
                            borderRadius: BorderRadius.circular(24),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                'assets/google_logo.png',
                                height: 30,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Text('G',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        )),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Apple login
                          InkWell(
                            onTap: _isLoading ? null : _signInWithApple,
                            borderRadius: BorderRadius.circular(24),
                            child: const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.apple,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Sign up text
                      GestureDetector(
                        onTap: _navigateToRegisterPage,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  color: Colors.brown[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              },
                        child: Text(
                          'Continue as Guest?',
                          style: TextStyle(
                            color: Colors.brown[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // إضافة مساحة إضافية في الأسفل للتأكد من ظهور كل المحتوى
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
