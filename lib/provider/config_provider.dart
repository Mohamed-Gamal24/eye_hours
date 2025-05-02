import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  String currentLanguage = 'en';

  bool get isEnglish => currentLanguage == "en";

  void ChangeAppLanguage(String newlang) {
    if (currentLanguage == newlang) return;
    currentLanguage = newlang;
    notifyListeners();
  }
}
