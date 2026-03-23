import 'package:stayvers_agent/core/config/evn/env.dart';
import 'package:stayvers_agent/core/data/current_user.dart';
import 'package:stayvers_agent/core/service/storage/brim_memory_cache.dart';
import 'package:stayvers_agent/core/service/storage/brim_storage.dart';

class BrimAuth {
  // Stores the user data in BrimStorage under a specified key or default to the current user key.
  static Future<void> _set(dynamic user, {String? customUserKey}) async {
    String storageKey = Env.currentUser; // Default key for storing user data
    if (customUserKey != null) {
      storageKey = customUserKey; // Use provided key if available
    }
    await BrimStorage.instance.storeJson(
      storageKey,
      user,
      cache: true,
    );
  }

  // Stores the authentication token in BrimStorage with a fixed key for the token.
  static Future<void> _injectToken(String token) async {
    await BrimStorage.instance.store(
      Env.token,
      token,
      cache: true,
    );
  }

  // NEW: Inject a custom token with a custom key
  static Future<void> _injectCustomToken(String token, String tokenKey) async {
    await BrimStorage.instance.store(
      tokenKey,
      token,
      cache: true,
    );
  }

  // Refreshes the stored authentication token if a new token is provided.
  static Future<void> refreshToken(String? token) async {
    if (token != null) {
      await _injectToken(token); // Update the token if provided
    }
  }

  // NEW: Public method to inject a custom token
  static Future<void> injectToken(String token, {String? tokenKey}) async {
    if (tokenKey != null) {
      await _injectCustomToken(token, tokenKey);
    } else {
      await _injectToken(token);
    }
  }

  // NEW: Public method to inject multiple tokens at once
  static Future<void> injectMultipleTokens(Map<String, String> tokens) async {
    for (final entry in tokens.entries) {
      await _injectCustomToken(entry.value, entry.key);
    }
  }

  static Future<CurrentUser> updateCurrentUser(CurrentUser currentUser,
      {String? customUserKey}) async {
    await _set(currentUser.toJson(), customUserKey: customUserKey);
    return currentUser;
  }

  /// Removes the authentication user and token for a given [customUserKey].
  /// If no customUserKey is provided, defaults to the current user and token keys.
  static Future _remove({String? customUserKey, String? tokenKey}) async {
    String storageKey = Env.currentUser; // Default key for user data
    String tokenStorageKey = Env.token; // Default key for token

    if (customUserKey != null) {
      storageKey = customUserKey; // Use provided key if available
    }
    if (tokenKey != null) {
      tokenStorageKey = tokenKey; // Use provided token key if available
    }

    // Delete user data and token from BrimStorage and cache
    await BrimStorage.instance.delete(storageKey, deleteFromCache: true);
    await BrimStorage.instance.delete(tokenStorageKey, deleteFromCache: true);
  }

  /// Logs in a user by storing user data and optionally storing tokens.
  /// Use [tokens] map to store multiple tokens with custom keys, or [token] for single default token.
  static Future login(dynamic user,
      {String? customUserKey,
      String? token,
      Map<String, String>? customTokens}) async {
    await _set(user, customUserKey: customUserKey); // Store user data

    // Handle single token with default key
    if (token != null) {
      await _injectToken(token);
    }

    // Handle multiple tokens with custom keys
    if (customTokens != null) {
      await injectMultipleTokens(customTokens);
    }
  }

  /// Checks if a user is logged in based on the presence of user data.
  /// Returns true if the user is logged in, otherwise false.
  static bool isLoggeIn({String? customUserKey}) {
    return curentUser(customUserKey: customUserKey) !=
        null; // Check if current user is not null
  }

  // Retrieves the authentication token from memory cache.
  static String? token({String? tokenKey}) {
    String key = tokenKey ?? Env.token;
    return BrimMemoryCache.instance.read(key); // Get token from cache
  }

  // NEW: Get all stored tokens (useful for debugging or multi-token scenarios)
  static Map<String, String?> getAllTokens(List<String> tokenKeys) {
    Map<String, String?> tokens = {};
    for (String key in tokenKeys) {
      tokens[key] = BrimMemoryCache.instance.read(key);
    }
    return tokens;
  }

  // NEW: Remove a specific token by key
  static Future<void> removeToken(String tokenKey) async {
    await BrimStorage.instance.delete(tokenKey, deleteFromCache: true);
  }

  // NEW: Check if a specific token exists
  static bool hasToken({String? tokenKey}) {
    String key = tokenKey ?? Env.token;
    return BrimMemoryCache.instance.read(key) != null;
  }

  /// Logs out the user by removing user data and token for a given [customUserKey].
  /// If no customUserKey is provided, defaults to the current user and token keys.
  static Future logout({String? customUserKey, String? tokenKey}) async =>
      await _remove(customUserKey: customUserKey, tokenKey: tokenKey);

  /// Gets the authenticated user from memory cache using an optional [customUserKey].
  /// If a customUserKey is provided, tries to fetch the user with that key.
  /// If no customUserKey is provided or no user is found with the key, fetches the default user.
  static CurrentUser? curentUser({String? customUserKey}) {
    // Check if a customUserKey was provided and attempt to fetch the user with the given key
    if (customUserKey != null) {
      final authData = BrimMemoryCache.instance.currentUser(key: customUserKey);
      if (authData != null) {
        return CurrentUser.fromJson(
            authData); // Return user created from JSON data
      }
    }
    // Fetch the default user if no customUserKey or no user was found with the key
    final defaultAuthData = BrimMemoryCache.instance.currentUser();
    if (defaultAuthData != null) {
      return CurrentUser.fromJson(
          defaultAuthData); // Return user created from default JSON data
    }
    // Return null if no user was found
    return null;
  }
}
