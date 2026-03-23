import 'dart:collection';

import 'package:stayvers_agent/core/config/evn/env.dart';

class BrimMemoryCache {
  final HashMap<String, dynamic> _values = HashMap();

  BrimMemoryCache._privateConstructor();

  static final BrimMemoryCache instance = BrimMemoryCache._privateConstructor();

  dynamic read(String key, {dynamic defaultValue}) {
    if (!_values.containsKey(key)) {
      if (defaultValue != null) return defaultValue;
      return null;
    }
    return _values[key];
  }

  bool contains(String key) {
    return _values.containsKey(key);
  }

  void set(String key, dynamic value) => _values[key] = value;

  void delete(String key) {
    if (_values.containsKey(key)) {
      _values.remove(key);
    }
  }

  void deleteAll() {
    _values.clear();
  }

  dynamic currentUser({String? key}) {
    String storageKey = Env.currentUser;
    if (key != null) {
      storageKey = key;
    }
    if (!_values.containsKey(storageKey)) {
      return null;
    }
    return _values[storageKey];
  }
}
