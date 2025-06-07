// أولاً: إضافة الحزم المطلوبة في بداية الملف
import 'package:eye_hours/Home_Screen.dart';
import 'package:eye_hours/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http; // إضافة حزمة http للتعامل مع API
import 'dart:convert'; // للتعامل مع بيانات JSON
import 'package:shared_preferences/shared_preferences.dart'; // لتخزين رمز المصادقة JWT
import 'package:connectivity_plus/connectivity_plus.dart';

// نمودج المستخدم للتسجيل
class RegisterUserModel {
  final String email;
  final String password;
  final String name; // تم تغييره ليكون مطلوب
  final String? phoneNumber;

  RegisterUserModel({
    required this.email,
    required this.password,
    required this.name, // تم تغييره ليكون مطلوب
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name, // الآن مطلوب
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }
}

// توسيع خدمة المصادقة المنشأة سابقًا
class AuthService {
  static const String baseUrl =
      'http://192.168.1.100:8000/api/system/register/'; // تم تصحيح العنوان الأساسي للـ API

  // دالة تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  static Future<AuthResponse> login(String email, String password) async {
    // التحقق من اتصال الإنترنت
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception(
          'No internet connection. Please check your connectivity and try again.');
    }

    try {
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
        try {
          final errorJson = jsonDecode(response.body);
          final errorMessage =
              errorJson['message'] ?? 'Failed to login. Please try again.';
          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception('Failed to login. Server error occurred.');
        }
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception(
            'Connection error. Please check the server URL and try again.');
      }
      rethrow; // إعادة رمي أي استثناءات أخرى
    }
  }

  // دالة تسجيل مستخدم جديد - تم تعديلها
  static Future<AuthResponse> register(RegisterUserModel user) async {
    // التحقق من اتصال الإنترنت
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception(
          'No internet connection. Please check your connectivity and try again.');
    }

    try {
      // تصحيح عنوان URL
      final response = await http.post(
        Uri.parse('$baseUrl/api/AuthUser/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      print('Register API Response Status: ${response.statusCode}');
      print('Register API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return AuthResponse.fromJson(jsonResponse);
      } else {
        // معالجة أخطاء التسجيل بشكل أفضل
        try {
          final errorJson = jsonDecode(response.body);
          String errorMessage;

          // محاولة الحصول على رسالة الخطأ من أماكن مختملة في الـ JSON
          if (errorJson.containsKey('message')) {
            errorMessage = errorJson['message'];
          } else if (errorJson.containsKey('errors')) {
            // في حالة وجود مصفوفة أخطاء
            final errors = errorJson['errors'];
            if (errors is Map) {
              errorMessage = errors.values.first is List
                  ? errors.values.first.first
                  : errors.values.first.toString();
            } else if (errors is List && errors.isNotEmpty) {
              errorMessage = errors.first.toString();
            } else {
              errorMessage = 'Registration failed due to validation errors.';
            }
          } else {
            errorMessage = 'Failed to register. Please try again later.';
          }

          throw Exception(errorMessage);
        } catch (parseError) {
          // في حالة حدوث خطأ أثناء تحليل JSON
          throw Exception('Failed to register. Server error occurred.');
        }
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception(
            'Connection error. Please check the server URL and try again.');
      } else if (e is FormatException) {
        throw Exception(
            'Failed to process server response. Please try again later.');
      }
      rethrow; // إعادة رمي أي استثناءات أخرى
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
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

  void _navigateToLoginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  // تعديل دالة التسجيل لاستخدام API بدلاً من Firebase مباشرة
  Future<void> _signUpWithEmailPassword() async {
    // التحقق الأساسي - الاسم أصبح مطلوب
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showError('All fields are requiredة');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    // التحقق من صحة عنوان البريد الإلكتروني
    bool isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text.trim());
    if (!isValidEmail) {
      _showError('Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // التحقق من اتصال الإنترنت قبل محاولة التسجيل
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showError(
            'No internet connection. Please check your connectivity and try again.');
        return;
      }

      // إنشاء نموذج للمستخدم الجديد - الاسم أصبح مطلوب
      final newUser = RegisterUserModel(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(), // مطلوب الآن
      );

      // استدعاء API للتسجيل
      final authResponse = await AuthService.register(newUser);

      if (authResponse.success) {
        // حفظ الرمز والمعرف
        await AuthService.saveToken(authResponse.token, authResponse.userId);

        // يمكن أيضا تسجيل الدخول مع Firebase إذا كنت بحاجة لذلك
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
        } catch (e) {
          // يمكن التعامل مع أخطاء Firebase هنا، لكن لا تقلق كثيرًا
          // طالما أن التسجيل عبر API نجح
          print('Firebase registration failed: $e');
        }

        // التنقل إلى الصفحة الرئيسية بعد التسجيل بنجاح
        _navigateToHome();
      } else {
        _showError(authResponse.message.isNotEmpty
            ? authResponse.message
            : 'Registration failed. Please try again.');
      }
    } catch (e) {
      if (e is Exception) {
        _showError(e.toString().replaceAll('Exception: ', ''));
      } else {
        _showError('An error occurred during registration: $e');
      }
    }
  }

  // تسجيل الدخول باستخدام Facebook
  Future<void> _signUpWithFacebook() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // التحقق من اتصال الإنترنت
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showError(
            'No internet connection. Please check your connectivity and try again.');
        return;
      }

      // بدء عملية تسجيل الدخول
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // الحصول على معلومات المستخدم من Facebook
        final userData = await FacebookAuth.instance.getUserData();

        // إنشاء بيانات اعتماد من رمز الوصول
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        // يمكن هنا استخدام API لتسجيل المستخدم بواسطة Facebook
        // أو الاستمرار مع Firebase

        // تسجيل الدخول مع Firebase باستخدام بيانات الاعتماد
        await FirebaseAuth.instance.signInWithCredential(credential);
        _navigateToHome();
      } else {
        _showError('Facebook registration was cancelled or failed');
      }
    } catch (e) {
      _showError('Failed to register with Facebook: $e');
    }
  }

  // تسجيل الدخول باستخدام Google
  Future<void> _signUpWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // التحقق من اتصال الإنترنت
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showError(
            'No internet connection. Please check your connectivity and try again.');
        return;
      }

      // بدء تدفق تسجيل الدخول باستخدام Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        _showError('Google registration was cancelled');
        return;
      }

      // الحصول على تفاصيل المصادقة من الطلب
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // إنشاء بيانات اعتماد جديدة
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // تسجيل الدخول باستخدام بيانات الاعتماد
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      _showError('Failed to register with Google: $e');
    }
  }

  // تسجيل الدخول باستخدام Apple
  Future<void> _signUpWithApple() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // التحقق من اتصال الإنترنت
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showError(
            'No internet connection. Please check your connectivity and try again.');
        return;
      }

      // طلب بيانات اعتماد للمستخدم
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // إنشاء بيانات اعتماد OAuth
      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // تسجيل الدخول باستخدام بيانات الاعتماد
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      _showError('Failed to register with Apple: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/image/13c6e78b3aaa64d3f113da8db3d7773b.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: IntrinsicHeight(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: _navigateToLoginPage,
                              child: const Text(
                                'Login',
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
                          'Create an Account',
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
                        // حقل الاسم (مطلوب الآن)
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText:
                                'Full Name *', // إضافة علامة * للدلالة على أنه مطلوب
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
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
                        ),
                        const SizedBox(height: 20),
                        // Email field
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email *',
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
                        // Password field مع زر إظهار/إخفاء
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password *',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              size: 28,
                              color: Colors.black87,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          obscureText: !_showPassword,
                        ),
                        const SizedBox(height: 20),
                        // Confirm Password field مع زر إظهار/إخفاء
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password *',
                            labelStyle: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              size: 28,
                              color: Colors.black87,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showConfirmPassword = !_showConfirmPassword;
                                });
                              },
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          obscureText: !_showConfirmPassword,
                        ),
                        const SizedBox(height: 40),
                        // Sign up button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : _signUpWithEmailPassword,
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
                                    'Sign up',
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
                        // Social registration buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Facebook registration
                            InkWell(
                              onTap: _isLoading ? null : _signUpWithFacebook,
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
                            // Google registration
                            InkWell(
                              onTap: _isLoading ? null : _signUpWithGoogle,
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
                            // Apple registration
                            InkWell(
                              onTap: _isLoading ? null : _signUpWithApple,
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
                        // Login text
                        GestureDetector(
                          onTap: _navigateToLoginPage,
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                const TextSpan(
                                    text: "Already have an account? "),
                                TextSpan(
                                  text: 'Login',
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
                                        builder: (context) =>
                                            const HomeScreen()),
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
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
