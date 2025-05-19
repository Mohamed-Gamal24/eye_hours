import 'package:eye_hours/OnboardingScreen.dart';
import 'package:eye_hours/provider/config_provider.dart';
import 'package:eye_hours/statues/main_statues_page.dart';
import 'package:eye_hours/temples/main_temples_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ConfigProvider(), child: const Eye_of_Hours()));
}

class Eye_of_Hours extends StatelessWidget {
  const Eye_of_Hours({super.key});

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context);

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      locale: configProvider.appLocale,
      routes: {
        '/MainPageTemples': (context) => MainPageTemples(),
        '/MainPageStatues': (context) => MainPageStatues(),
      },
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // تأخير لمدة 3 ثواني ثم الانتقال إلى الشاشة الرئيسية
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image/a297cfea26a95d5f4b019681e81e5608.jpg', // ضع مسار الصورة هنا
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // اجعلها في الأعلى
              crossAxisAlignment:
                  CrossAxisAlignment.center, // اجعلها في المنتصف
              children: [
                const SizedBox(height: 50), // مسافة من الأعلى
                ClipOval(
                  child: Image.asset(
                    'assets/image/hours.icon.jpg', // ضع مسار الايكون ال فوق هنا
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'EYE of HORUS',
                  style: TextStyle(
                      fontSize: 36,
                      color:
                          Color.fromARGB(255, 247, 187, 49), // تغيير اللون هنا
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
