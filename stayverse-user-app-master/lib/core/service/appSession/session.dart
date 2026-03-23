import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/view/page/login_page.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/service/appSession/controller/log_out_controller.dart';

class AppSession {
  static Future<void> logOut(WidgetRef ref, {String? route}) async {
    $navigate.clearAllTo(route ?? LoginPage.route);
    ref.read(logOutController).logOut();
  }
}
