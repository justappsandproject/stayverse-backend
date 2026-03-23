import 'package:stayvers_agent/auth/view/page/login_page.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/service/appSession/controller/log_out_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSession {
  static Future<void> logOut(WidgetRef ref, {String? route}) async {
    $navigate.clearAllTo(route ?? LoginPage.route);
    ref.read(logOutController).logOut();
  }
}



