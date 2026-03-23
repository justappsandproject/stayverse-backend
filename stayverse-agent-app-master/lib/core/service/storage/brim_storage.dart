import 'dart:convert';

import 'package:stayvers_agent/core/service/storage/brim_memory_cache.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:stayvers_agent/core/util/app/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrimStorage {
  final _log = BrimLogger.load(BrimStorage);
  SharedPreferences? _manager;

  // Singleton instance
  static final BrimStorage _instance = BrimStorage._internal();

  static final BrimStorage instance = _instance;

  factory BrimStorage() => _instance;
  BrimStorage._internal();

  /// Ensures the SharedPreferences instance is initialized.
  void _ensureInitialized() {
    if (_manager == null) {
      throw Exception(
          'BrimStorage not initialized. Call initializeDataBase() first.');
    }
  }

  /// Initialize the SharedPreferences instance.
  Future<void> initializeDataBase() async {
    _manager = await SharedPreferences.getInstance();
  }

  /// Clears all data from SharedPreferences.
  Future<void> deleteAll({bool deleteFromCache = false}) async {
    _ensureInitialized();
    if (deleteFromCache == true) {
      BrimMemoryCache.instance.deleteAll();
    }
    await _manager!.clear();
  }

  /// Returns all keys stored in SharedPreferences.
  List<String> keys() {
    _ensureInitialized();
    return _manager!.getKeys().toList();
  }

  /// Stores a string [data] in Disk with the given [key].
  /// Optionally, caches the value in memory if [cache] is true.
  Future<void> store(String key, String data, {bool cache = false,}) async {
    _ensureInitialized();
    if (cache) {
      BrimMemoryCache.instance.set(key, data);
    }
    await _putData(key, data);
  }

  /// Stores a JSON-encoded object [data] in Disk with the given [key].
  /// Optionally, caches the value in memory if [cache] is true.
  Future<void> storeJson(String key, dynamic data, {bool cache = false}) async {
    _ensureInitialized();
    if (cache) {
      BrimMemoryCache.instance.set(key, data);
    }
    await _putData(key, jsonEncode(data));
  }

  /// Deletes the value associated with [key] from SharedPreferences.
  Future<void> delete(String key, {bool deleteFromCache = false}) async {
    _ensureInitialized();
    if (deleteFromCache == true) {
      BrimMemoryCache.instance.delete(key);
    }
    if (_manager!.containsKey(key)) {
      await _manager!.remove(key);
    }
  }

  /// Reads the value associated with [key] from SharedPreferences.
  String? read(String key) {
    _ensureInitialized();
    return _manager?.getString(key);
  }

  /// Reads and decodes a JSON object from SharedPreferences.
  Future<dynamic> readJson(String key) async {
    _ensureInitialized();
    final data = read(key);
    return data != null ? decodeJson(data) : null;
  }

  Map<String, String> readAll() {
    _ensureInitialized();

    final Map<String, String> result = {};
    final storageKeys = keys();

    for (String key in storageKeys) {
      final value = _manager!.getString(key);
      if (value != null) {
        result[key] = value;
      }
    }

    return result;
  }

  /// Update a value in the local storage by [index].
  Future<bool> updateCollectionByIndex<T>(int index, T Function(T item) object,
      {required String key}) async {
    List<T> collection = await readCollection<T>(key);

    // Check if the collection is empty or the index is out of bounds
    if (collection.isEmpty || index < 0 || index >= collection.length) {
      _log.e(
          '[BrimStorage.updateCollectionByIndex] The collection is empty or the index is out of bounds.');
      return false;
    }

    // Update the item
    T newItem = object(collection[index]);

    collection[index] = newItem;

    await saveCollection<T>(key, collection);
    return true;
  }

  /// Deletes a collection from the given [key].
  Future deleteCollection(String key, {bool andFromBackpack = false}) async {
    await delete(key, deleteFromCache: andFromBackpack);
  }

  Future<List<T>> addRecentToCollection<T>(
    String key, {
    required T item,
    bool allowDuplicates = true,
    RecentTechnique recentTechnique = RecentTechnique.fifo,
    int limit = 20,
    Map<Type, dynamic>? modelDecoders,
  }) async {
    List<T> collection =
        await readCollection<T>(key, modelDecoders: modelDecoders);

    if (!allowDuplicates) {
      collection.removeWhere((collect) => collect == item);
    }

    collection.insert(0, item);

    if (recentTechnique == RecentTechnique.fifo) {
      if (collection.length > limit) {
        collection.removeLast();
      }
    }

    await saveCollection<T>(key, collection);

    return collection;
  }

  /// Add a newItem to the collection using a [key].
  Future<void> addToCollection<T>(String key,
      {required dynamic item,
      bool allowDuplicates = true,
      Map<Type, dynamic>? modelDecoders}) async {
    List<T> collection =
        await readCollection<T>(key, modelDecoders: modelDecoders);
    if (allowDuplicates == false) {
      if (collection.any((collect) => collect == item)) {
        return;
      }
    }
    collection.add(item);
    await saveCollection<T>(key, collection);
  }

  /// Update item(s) in a collection using a where query.
  Future updateCollectionWhere<T>(bool Function(dynamic value) where,
      {required String key, required T Function(dynamic value) update}) async {
    List<T> collection = await readCollection<T>(key);
    if (collection.isEmpty) return;

    collection.where((value) => where(value)).forEach((element) {
      update(element);
    });

    await saveCollection<T>(key, collection);
  }

  /// Read the collection values using a [key].
  Future<List<T>> readCollection<T>(String key,
      {Map<Type, dynamic>? modelDecoders}) async {
    final listData = await readJson(key) as List<dynamic>?;

    if (listData == null || listData.isEmpty) return [];

    if (!["dynamic", "string", "double", "int"]
        .contains(T.toString().toLowerCase())) {
      return List.from(listData)
          .map((json) =>
              dataToModel<T>(data: json, modelDecoders: modelDecoders))
          .toList();
    }
    return List.from(listData).toList().cast();
  }

  /// Delete item(s) from a collection using a where query.
  Future deleteFromCollectionWhere<T>(bool Function(dynamic value) where,
      {required String key}) async {
    List<T> collection = await readCollection<T>(key);
    if (collection.isEmpty) return;

    collection.removeWhere((value) => where(value));

    await saveCollection<T>(key, collection);
  }

  /// Delete an item of a collection using a [index] and the collection [key].
  Future deleteFromCollection<T>(int index, {required String key}) async {
    List<T> collection = await readCollection<T>(key);
    if (collection.isEmpty) return;
    collection.removeAt(index);
    await saveCollection<T>(key, collection);
  }

  /// Save a list of objects to a [collection] using a [key].
  Future saveCollection<T>(String key, List collection) async {
    if (["dynamic", "string", "double", "int"]
        .contains(T.toString().toLowerCase())) {
      await storeJson(key, collection);
      return;
    }

    final list = collection.map((item) {
      Map<String, dynamic>? data = _objectToJson(item);
      if (data != null) {
        return data;
      }
      return item;
    }).toList();
    await storeJson(key, list);
  }

  /// Delete a value from a collection using a [key] and the [value] you want to remove.
  Future deleteValueFromCollection<T>(String key, {dynamic value}) async {
    List<T> collection = await readCollection<T>(key);
    collection.removeWhere((item) => item == value);
    await saveCollection<T>(key, collection);
  }

  /// Checks if a collection is empty
  Future<bool> isCollectionEmpty(String key) async =>
      (await readCollection(key)).isEmpty;

  /// Reloads the SharedPreferences instance (usually after external changes).
  Future<void> reload() async {
    _ensureInitialized();
    await _manager?.reload();
  }

  /// Helper method to put string data in SharedPreferences.
  Future<void> _putData(String key, String data) async {
    await _manager!.setString(key, data);
  }

  ///This sync this
  static Future syncToBrimCache({bool overwrite = false}) async {
    final instance = BrimStorage.instance;
    await instance.reload();

    Map<String, String> values = instance.readAll();

    final brimMemoryCache = BrimMemoryCache.instance;

    for (var data in values.entries) {
      if (overwrite == false && brimMemoryCache.contains(data.key)) {
        continue;
      }
      dynamic result = instance.read(data.key);
      BrimMemoryCache.instance.set(data.key, result);
    }
  }

  Map<String, dynamic>? _objectToJson(dynamic object) {
    try {
      Map<String, dynamic> json = object.toJson();
      return json;
    } on NoSuchMethodError catch (e) {
      _log.d(e.toString());
      _log.d(
          '[BrimStorage.store] ${object.runtimeType.toString()} model needs to implement the toJson() method.');
    }
    return null;
  }
}

enum RecentTechnique {
  fifo,
  none;
}
