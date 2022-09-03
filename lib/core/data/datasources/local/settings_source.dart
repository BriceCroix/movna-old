import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:movna/core/data/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsSource {
  Future<SettingsModel> getSettings();

  Future<void> saveSettings(SettingsModel model);
}

@Injectable(as: SettingsSource)
class SettingsSourceImpl extends SettingsSource {
  static const String _settingsKey = 'settings';

  @override
  Future<SettingsModel> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonSettings = prefs.getString(_settingsKey);
    if (jsonSettings != null) {
      return SettingsModel.fromJson(jsonDecode(jsonSettings));
    } else {
      return const SettingsModel();
    }
  }

  @override
  Future<void> saveSettings(SettingsModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(model.toJson()));
  }
}
