import 'package:stayverse/core/config/evn/env.dart';
import 'package:stayverse/core/event/brim_event.dart';
import 'package:stayverse/core/service/storage/brim_memory_cache.dart';
import 'package:stayverse/core/service/storage/brim_storage.dart';

class LoadStorageToCache<T> implements BrimEvent {
  @override
  Map<Type, BrimEventListener> listeners() {
    return {
      _DefaultListener: _DefaultListener(),
    };
  }
}

class _DefaultListener extends BrimEventListener {
  @override
  Future<void> handle(dynamic event) async {
    final dynamic authUser =
        await BrimStorage.instance.readJson(Env.currentUser);
    if (authUser != null) {
      BrimMemoryCache.instance.set(Env.currentUser, authUser);
    }

    final dynamic token = BrimStorage.instance.read(Env.token);
    if (token != null) {
      BrimMemoryCache.instance.set(Env.token, token);
    }
    final dynamic chatToken = BrimStorage.instance.read(Env.chatToken);
    if (chatToken != null) {
      BrimMemoryCache.instance.set(Env.chatToken, chatToken);
    }
  }
}
