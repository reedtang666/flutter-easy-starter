import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储服务
class StorageService {
  StorageService._();

  static final StorageService _instance = StorageService._();
  static StorageService get instance => _instance;

  SharedPreferences? _prefs;

  /// 初始化
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 获取实例（确保已初始化）
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ========== String ==========
  Future<bool> setString(String key, String value) {
    return prefs.setString(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return prefs.getString(key) ?? defaultValue;
  }

  // ========== int ==========
  Future<bool> setInt(String key, int value) {
    return prefs.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return prefs.getInt(key) ?? defaultValue;
  }

  // ========== double ==========
  Future<bool> setDouble(String key, double value) {
    return prefs.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return prefs.getDouble(key) ?? defaultValue;
  }

  // ========== bool ==========
  Future<bool> setBool(String key, bool value) {
    return prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return prefs.getBool(key) ?? defaultValue;
  }

  // ========== List<String> ==========
  Future<bool> setStringList(String key, List<String> value) {
    return prefs.setStringList(key, value);
  }

  List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    return prefs.getStringList(key) ?? defaultValue;
  }

  // ========== 通用方法 ==========
  Future<bool> remove(String key) {
    return prefs.remove(key);
  }

  Future<bool> clear() {
    return prefs.clear();
  }

  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  Set<String> getKeys() {
    return prefs.getKeys();
  }
}
