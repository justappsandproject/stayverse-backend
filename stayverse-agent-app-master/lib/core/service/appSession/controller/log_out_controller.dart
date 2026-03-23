import 'package:stayvers_agent/auth/view/page/login_page.dart';
import 'package:stayvers_agent/core/config/evn/env.dart';
import 'package:stayvers_agent/core/event/brim_resgister.dart';
import 'package:stayvers_agent/core/event/evenList/route_history_event.dart';
import 'package:stayvers_agent/core/service/brimAuth/brim_auth.dart';
import 'package:stayvers_agent/core/socketio/socketEngines/background_socket_io.dart';
import 'package:stayvers_agent/core/socketio/socketEngines/main_socket_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/feature/dashBoard/controller/dashboard_controller.dart';

class LogOutController {
  final Ref ref;
  LogOutController(this.ref);

  Future<bool> logOut() async {
    await BrimAuth.logout();

    ref.invalidate(dashboadController);
   
    await eventOn<RouteHistoryEvent>(
        params: {Env.screenStorageScreen: LoginPage.route});
    MainSocketIO.disconnect();
    BackgroundSocketIO.disconnect();
    return true;
  }
}

final logOutController = Provider((ref) {
  return LogOutController(ref);
});
