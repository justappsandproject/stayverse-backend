
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HandleDeviceOrientation {
  static final HandleDeviceOrientation instance =
      HandleDeviceOrientation._internal();

  HandleDeviceOrientation._internal();

  void setDeviceOrientation(Axis axis) => switch (axis) {
        Axis.horizontal => SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]),
        Axis.vertical => SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]),
      };

  void supportAllDeviceOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
