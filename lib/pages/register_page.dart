// أولاً: إضافة الحزم المطلوبة في بداية الملف
import 'dart:async';
import 'package:eye_hours/Home_Screen.dart';
import 'package:eye_hours/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// نمودج المستخدم للتسجيل - محدث ليحتوي على الحقول المطلوبة فقط
class RegisterUserModel {
  final String email;
  final String password;
  final String name;

  RegisterUserModel({
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }
}

// خدمة المصادقة المحدثة مع حل مشكلة 301
class AuthService {
  // تصحيح عنوان الـ API - إضافة followRedirects والتعامل مع 301
  static const String baseUrl = 'https://horuseye.site/api/system';

  // إنشاء HTTP client مخصص للتعامل مع إعادة التوجيه
  static http.Client createHttpClient() {
    return http.Client();
  }

  // دالة تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور - محدثة
  static Future<AuthResponse> login(String email, String password) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception(
          'No internet connection. Please check your connectivity and try again.');
    }

    http.Client client = createHttpClient();

    try {
      List<String> urlsToTry = [
        'https://horuseye.site/api/system/login',
        'https://www.horuseye.site/api/system/login',
        'http://horuseye.site/api/system/login',
        'http://www.horuseye.site/api/system/login',
      ];

      http.Response? response;

      for (String url in urlsToTry) {
        try {
          print('Trying login URL: $url');

          final request = http.Request('POST', Uri.parse(url));
          request.headers.addAll({
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'User-Agent': 'Flutter-App/1.0',
          });
          request.body = jsonEncode({
            'email': email,
            'password': password,
          });

          final streamedResponse =
              await client.send(request).timeout(const Duration(seconds: 30));
          response = await http.Response.fromStream(streamedResponse);

          print('Login response from $url - Status: ${response.statusCode}');

          // التعامل مع إعادة التوجيه
          if (response.statusCode == 301 || response.statusCode == 302) {
            String? location = response.headers['location'];
            if (location != null) {
              print('Login redirect detected to: $location');

              if (!location.startsWith('http')) {
                Uri originalUri = Uri.parse(url);
                location =
                    '${originalUri.scheme}://${originalUri.host}${location}';
              }

              final redirectRequest = http.Request('POST', Uri.parse(location));
              redirectRequest.headers.addAll({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'User-Agent': 'Flutter-App/1.0',
              });
              redirectRequest.body = jsonEncode({
                'email': email,
                'password': password,
              });

              final redirectStreamedResponse = await client
                  .send(redirectRequest)
                  .timeout(const Duration(seconds: 30));
              response =
                  await http.Response.fromStream(redirectStreamedResponse);

              print(
                  'Response from login redirect $location - Status: ${response.statusCode}');
            }
          }

          if (response.statusCode != 301 && response.statusCode != 302) {
            break;
          }
        } catch (e) {
          print('Error with login URL $url: $e');
          continue;
        }
      }

      if (response == null) {
        throw Exception('Unable to connect to server. All endpoints failed.');
      }

      print('Login API Response Status: ${response.statusCode}');
      print('Login API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 301 || response.statusCode == 302) {
        throw Exception('API endpoint has moved. Please contact support.');
      } else {
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
      rethrow;
    } finally {
      client.close();
    }
  }

  // دالة تسجيل مستخدم جديد - محدثة مع معالجة أفضل للأخطاء وحل مشكلة 301
  static Future<AuthResponse> register(RegisterUserModel user) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception(
          'No internet connection. Please check your connectivity and try again.');
    }

    http.Client client = createHttpClient();

    try {
      print('Sending registration request...');
      print('Request body: ${jsonEncode(user.toJson())}');

      // محاولة عدة عناوين محتملة للتعامل مع إعادة التوجيه
      List<String> urlsToTry = [
        'https://horuseye.site/api/system/register',
        'https://www.horuseye.site/api/system/register',
        'http://horuseye.site/api/system/register',
        'http://www.horuseye.site/api/system/register',
      ];

      http.Response? response;
      String? workingUrl;

      for (String url in urlsToTry) {
        try {
          print('Trying registration URL: $url');

          final request = http.Request('POST', Uri.parse(url));
          request.headers.addAll({
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'User-Agent': 'Flutter-App/1.0',
          });
          request.body = jsonEncode(user.toJson());

          final streamedResponse =
              await client.send(request).timeout(const Duration(seconds: 30));
          response = await http.Response.fromStream(streamedResponse);

          print('Response from $url - Status: ${response.statusCode}');

          // إذا كان الرد 301 أو 302، نحاول الحصول على العنوان الجديد
          if (response.statusCode == 301 || response.statusCode == 302) {
            String? location = response.headers['location'];
            if (location != null) {
              print('Redirect detected to: $location');

              // إذا كان العنوان نسبي، نجعله مطلق
              if (!location.startsWith('http')) {
                Uri originalUri = Uri.parse(url);
                location =
                    '${originalUri.scheme}://${originalUri.host}${location}';
              }

              // محاولة العنوان الجديد
              final redirectRequest = http.Request('POST', Uri.parse(location));
              redirectRequest.headers.addAll({
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'User-Agent': 'Flutter-App/1.0',
              });
              redirectRequest.body = jsonEncode(user.toJson());

              final redirectStreamedResponse = await client
                  .send(redirectRequest)
                  .timeout(const Duration(seconds: 30));
              response =
                  await http.Response.fromStream(redirectStreamedResponse);

              print(
                  'Response from redirect $location - Status: ${response.statusCode}');
            }
          }

          // إذا كانت الاستجابة ناجحة أو خطأ معروف (ليس 301)، نتوقف
          if (response.statusCode != 301 && response.statusCode != 302) {
            workingUrl = url;
            break;
          }
        } catch (e) {
          print('Error with URL $url: $e');
          continue;
        }
      }

      if (response == null) {
        throw Exception('Unable to connect to server. All endpoints failed.');
      }

      print('Final API Response Status: ${response.statusCode}');
      print('Final API Response Headers: ${response.headers}');
      print('Final API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonResponse = jsonDecode(response.body);
          return AuthResponse.fromJson(jsonResponse);
        } catch (parseError) {
          print('JSON Parse Error: $parseError');
          // إذا كانت الاستجابة نجحت لكن لا يمكن تحليلها، ننشئ استجابة افتراضية
          return AuthResponse(
            token: '',
            userId: '',
            message: 'Registration successful!',
            success: true,
          );
        }
      } else if (response.statusCode == 422) {
        // خطأ في البيانات المدخلة
        try {
          final errorJson = jsonDecode(response.body);
          String errorMessage = 'Validation error occurred.';

          if (errorJson.containsKey('errors')) {
            final errors = errorJson['errors'];
            if (errors is Map) {
              List<String> errorMessages = [];
              errors.forEach((key, value) {
                if (value is List) {
                  errorMessages.addAll(value.map((e) => e.toString()));
                } else {
                  errorMessages.add(value.toString());
                }
              });
              errorMessage = errorMessages.join(', ');
            }
          } else if (errorJson.containsKey('message')) {
            errorMessage = errorJson['message'];
          }

          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception('Invalid data provided. Please check your input.');
        }
      } else if (response.statusCode == 409) {
        // المستخدم موجود مسبقاً
        throw Exception(
            'Email already exists. Please use a different email or login.');
      } else if (response.statusCode >= 500) {
        // خطأ في الخادم
        throw Exception(
            'Server is temporarily unavailable. Please try again later.');
      } else if (response.statusCode == 301 || response.statusCode == 302) {
        // لا يزال يحدث إعادة توجيه
        String redirectInfo = '';
        String? location = response.headers['location'];
        if (location != null) {
          redirectInfo = ' The server is redirecting to: $location';
        }
        throw Exception(
            'API endpoint has moved permanently. Please contact support.$redirectInfo');
      } else {
        // أخطاء أخرى
        try {
          final errorJson = jsonDecode(response.body);
          String errorMessage = errorJson['message'] ??
              errorJson['error'] ??
              'Registration failed. Please try again.';
          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception(
              'Registration failed with status: ${response.statusCode}. Please try again or contact support.');
        }
      }
    } on TimeoutException {
      throw Exception(
          'Request timeout. Please check your internet connection and try again.');
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception(
            'Connection error. Please check your internet connection and try again.');
      } else if (e is FormatException) {
        throw Exception('Invalid server response. Please try again later.');
      } else if (e.toString().contains('Exception:')) {
        // إذا كان الخطأ يحتوي على Exception: نعيد رسالة الخطأ كما هي
        rethrow;
      } else {
        throw Exception('Unexpected error occurred: ${e.toString()}');
      }
    } finally {
      client.close();
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

// نموذج لاستجابة API - محدث
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
    // طباعة البيانات المستلمة للتشخيص
    print('AuthResponse.fromJson: $json');

    return AuthResponse(
      token: json['token']?.toString() ??
          json['access_token']?.toString() ??
          json['auth_token']?.toString() ??
          '',
      userId: json['userId']?.toString() ??
          json['user_id']?.toString() ??
          json['id']?.toString() ??
          json['user']?['id']?.toString() ??
          '',
      message: json['message']?.toString() ??
          json['msg']?.toString() ??
          'Operation completed successfully',
      success: json['success'] == true ||
          json['status'] == 'success' ||
          json['token'] != null ||
          json['access_token'] != null ||
          json['auth_token'] != null,
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
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
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

  // دالة التسجيل المحدثة مع معالجة أفضل للأخطاء
  Future<void> _signUpWithEmailPassword() async {
    // التحقق من أن جميع الحقول مملوءة
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showError('All fields are required');
      return;
    }

    // التحقق من تطابق كلمات المرور
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    // التحقق من طول كلمة المرور
    if (_passwordController.text.length < 6) {
      _showError('Password must be at least 6 characters long');
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
      // التحقق من اتصال الإنترنت
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showError(
            'No internet connection. Please check your connectivity and try again.');
        return;
      }

      // إنشاء نموذج للمستخدم الجديد
      final newUser = RegisterUserModel(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      print('Starting registration process...');

      // استدعاء API للتسجيل
      final authResponse = await AuthService.register(newUser);

      print(
          'Registration API call completed. Success: ${authResponse.success}');

      if (authResponse.success) {
        // حفظ الرمز والمعرف إذا كانا متوفرين
        if (authResponse.token.isNotEmpty && authResponse.userId.isNotEmpty) {
          await AuthService.saveToken(authResponse.token, authResponse.userId);
        }

        // إظهار رسالة نجاح
        _showSuccess(authResponse.message.isNotEmpty
            ? authResponse.message
            : 'Registration successful!');

        // محاولة تسجيل الدخول مع Firebase (اختياري - لا نوقف العملية إذا فشل)
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
          print('Firebase registration successful');
        } catch (firebaseError) {
          print('Firebase registration failed: $firebaseError');
          // لا نوقف العملية إذا فشل Firebase
        }

        // انتظار قصير لإظهار رسالة النجاح ثم الانتقال
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          _navigateToHome();
        }
      } else {
        _showError(authResponse.message.isNotEmpty
            ? authResponse.message
            : 'Registration failed. Please try again.');
      }
    } catch (e) {
      print('Registration error: $e');
      String errorMessage = e.toString();

      // إزالة كلمة Exception: من بداية الرسالة
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }

      _showError(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showError(
            'No internet connection. Please check your connectivity and try again.');
        return;
      }

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        _navigateToHome();
      } else {
        _showError('Facebook registration was cancelled or failed');
      }
    } catch (e) {
      _showError('Failed to register with Facebook: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // تسجيل الدخول باستخدام Google
  Future<void> _signUpWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showError(
            'No internet connection. Please check your connectivity and try again.');
        return;
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        _showError('Google registration was cancelled');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      _showError('Failed to register with Google: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // تسجيل الدخول باستخدام Apple
  Future<void> _signUpWithApple() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showError(
            'No internet connection. Please check your connectivity and try again.');
        return;
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      _showError('Failed to register with Apple: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // حقل الاسم الكامل
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name *',
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
                        // حقل البريد الإلكتروني
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
                        // حقل كلمة المرور
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
                        // حقل تأكيد كلمة المرور
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
                        // زر التسجيل
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
                        // فاصل "أو"
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
                        // أزرار التسجيل عبر وسائل التواصل الاجتماعي
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Facebook
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
                            // Google
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
                            // Apple
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
                        // نص الانتقال لتسجيل الدخول
                        GestureDetector(
                          onTap: _isLoading ? null : _navigateToLoginPage,
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
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
                        // زر الدخول كضيف
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
                            'Continue as Guest',
                            style: TextStyle(
                              color: Colors.brown[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
