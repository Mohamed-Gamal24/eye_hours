import 'package:eye_hours/provider/config_provider.dart';
import 'package:eye_hours/splash_screen.dart';
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
