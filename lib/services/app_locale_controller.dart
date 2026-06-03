import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english('en', Locale('en')),
  chinese('zh', Locale('zh'));

  const AppLanguage(this.storageValue, this.locale);

  final String storageValue;
  final Locale locale;

  static AppLanguage fromStorageValue(String? value) {
    return AppLanguage.values.firstWhere(
      (language) => language.storageValue == value,
      orElse: () => AppLanguage.english,
    );
  }
}

class AppLocaleController extends ChangeNotifier {
  AppLocaleController._(this._preferences, this._language);

  static const _storageKey = 'guitar_metronome.language.v1';

  final SharedPreferences _preferences;
  AppLanguage _language;

  AppLanguage get language => _language;
  Locale get locale => _language.locale;

  static Future<AppLocaleController> create() async {
    final preferences = await SharedPreferences.getInstance();
    return AppLocaleController._(
      preferences,
      AppLanguage.fromStorageValue(preferences.getString(_storageKey)),
    );
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) {
      return;
    }

    _language = language;
    await _preferences.setString(_storageKey, language.storageValue);
    notifyListeners();
  }
}
