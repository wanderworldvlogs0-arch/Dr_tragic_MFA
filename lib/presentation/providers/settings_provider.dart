import 'package:flutter/material.dart';
import 'package:dr_tragic_mfa/core/database/database_helper.dart';

class SettingsProvider extends ChangeNotifier {
  Map<String, String> _settings = {};
  bool _isLoading = false;

  ThemeMode _themeMode = ThemeMode.system;
  String _fontSize = 'medium';
  String _language = 'english';

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  String get fontSize => _fontSize;
  String get language => _language;

  bool get negativeMarking => _getSetting('negative_marking') == 'on';
  bool get vibration => _getSetting('vibration') == 'on';
  bool get soundEffects => _getSetting('sound_effects') == 'on';

  String get themeModeSetting => _getSetting('theme') ?? 'system';
  String get themeModeName {
    switch (themeModeSetting) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  String get fontSizeSetting => _getSetting('font_size') ?? 'medium';

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    final db = await DatabaseHelper.instance.database;
    final results = await db.query('settings');
    
    _settings = {};
    for (var row in results) {
      _settings[row['key'] as String] = row['value'] as String;
    }

    _themeMode = _getThemeMode(_getSetting('theme') ?? 'system');
    _fontSize = _getSetting('font_size') ?? 'medium';
    _language = _getSetting('language') ?? 'english';

    _isLoading = false;
    notifyListeners();
  }

  String? _getSetting(String key) => _settings[key];

  Future<void> _updateSetting(String key, String value) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _settings[key] = value;
    notifyListeners();
  }

  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setTheme(String theme) {
    _updateSetting('theme', theme);
    _themeMode = _getThemeMode(theme);
  }

  void setFontSize(String size) {
    _updateSetting('font_size', size);
    _fontSize = size;
  }

  void setLanguage(String language) {
    _updateSetting('language', language);
    _language = language;
  }

  void toggleNegativeMarking() {
    _updateSetting('negative_marking', negativeMarking ? 'off' : 'on');
  }

  void toggleVibration() {
    _updateSetting('vibration', vibration ? 'off' : 'on');
  }

  Future<void> resetAllProgress() async {
    final db = await DatabaseHelper.instance.database;
    
    // Clear all user data
    await db.delete('user_progress');
    await db.delete('bookmarks');
    await db.delete('test_results');
    await db.delete('flashcards');
    
    notifyListeners();
  }
}
