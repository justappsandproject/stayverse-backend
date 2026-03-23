import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/view/page/login_page.dart';
import 'package:stayverse/core/config/evn/env.dart';
import 'package:stayverse/core/event/brim_resgister.dart';
import 'package:stayverse/core/event/evenList/route_history_event.dart';
import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:stayverse/core/service/streamChat/stream_client_service.dart';

class LogOutController {
  final Ref ref;
  LogOutController(this.ref);

  Future<bool> logOut() async {
    await BrimAuth.logout();

    await eventOn<RouteHistoryEvent>(
        params: {Env.screenStorageScreen: LoginPage.route});

    StreamClientService.instance.dispose();

    return true;
  }
}

final logOutController = Provider((ref) {
  return LogOutController(ref);
});
