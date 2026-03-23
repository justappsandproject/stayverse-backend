import 'package:stayverse/core/config/appEnviroment/enviroment.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/util/style/app_style.dart';
import 'package:flutter/material.dart';

///Engine for the whole app
///This contains all the information you need
class BrimEngine {
  BrimEngine._();

  static final _instance = BrimEngine._();

  static final instance = _instance;

  factory BrimEngine() => _instance;

  Size get deviceSize {
    final w = WidgetsBinding.instance.platformDispatcher.views.first;
    return w.physicalSize / w.devicePixelRatio;
  }

  static AppStyle get style => _style;

  static AppStyle _style = AppStyle();

  Future<void> boot({Function? setup, Function()? setupFinished}) async {
    logger.i(
        '::::: Enviroment ${environment.name.toUpperCase()} , App Engine started ::::::, deviceSize >>> $deviceSize');
    if (setup != null) {
      await setup();
    }

    _style = AppStyle(screenSize: deviceSize);

    if (setupFinished != null) {
      await setupFinished();
    }
  }
}
