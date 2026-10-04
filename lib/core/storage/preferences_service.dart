import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

abstract class PreferencesService {
  Future<void> setRememberUsername(String username);
  String? getRememberUsername();
  Future<void> removeRememberUsername();
  Future<void> clear();
}

class PreferencesServiceImpl implements PreferencesService {
  final SharedPreferences _prefs;

  PreferencesServiceImpl(this._prefs);

  @override
  Future<void> setRememberUsername(String username) async {
    await _prefs.setString(AppConstants.keyRememberUser, username);
  }

  @override
  String? getRememberUsername() {
    return _prefs.getString(AppConstants.keyRememberUser);
  }

  @override
  Future<void> removeRememberUsername() async {
    await _prefs.remove(AppConstants.keyRememberUser);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}
