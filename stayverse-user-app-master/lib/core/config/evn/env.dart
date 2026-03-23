// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'mode')
  static const String mode = _Env.mode;

  @EnviedField(varName: 'GOOGLE_API_KEY')
  static const String gooleApiKey = _Env.gooleApiKey;

  @EnviedField(varName: 'HOST_DEV', obfuscate: true)
  static final String hostDev = _Env.hostDev;

  @EnviedField(varName: 'HOST_PROD', obfuscate: true)
  static final String hostprod = _Env.hostprod;

  @EnviedField(varName: 'AUTH_USER_KEY', obfuscate: true)
  static final String currentUser = _Env.currentUser;

  @EnviedField(varName: 'TOKEN_KEY', obfuscate: true)
  static final String token = _Env.token;

  @EnviedField(varName: 'CHAT_TOKEN_KEY', obfuscate: true)
  static final String chatToken = _Env.chatToken;

  @EnviedField(varName: 'GET_STREAM_KEY', obfuscate: true)
  static final String getStreamKey = _Env.getStreamKey;

  @EnviedField(varName: 'RECENT_SEARCH_STORAGE_KEY', obfuscate: true)
  static final String recentSearchStorage = _Env.recentSearchStorage;

  @EnviedField(
    varName: 'SESSION_STORAGE_KEY',
  )
  static const String sessionKey = _Env.sessionKey;

  @EnviedField(varName: 'SENTRY_DNS', obfuscate: true)
  static final String sentryDns = _Env.sentryDns;


  @EnviedField(
    varName: 'SCREEN_STORAGE_KEY',
  )
  static const String screenStorageScreen = _Env.screenStorageScreen;
}
