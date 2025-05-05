import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  Locale _appLocale = const Locale('en');

  Locale get appLocale => _appLocale;

  bool get isEnglish => _appLocale.languageCode == 'en';

  void changeAppLanguage(String languageCode) {
    if (_appLocale.languageCode == languageCode) return;
    _appLocale = Locale(languageCode);
    notifyListeners();
  }
}
