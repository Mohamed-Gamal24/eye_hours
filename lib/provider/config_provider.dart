import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  String currentLanguage = 'en';

  bool get isEnglish => currentLanguage == "en";

  void changeAppLanguage(String newLang) {
    if (currentLanguage == newLang) return;
    currentLanguage = newLang;
    notifyListeners();
  }
}
