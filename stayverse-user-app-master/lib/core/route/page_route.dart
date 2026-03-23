import 'package:flutter/material.dart';


class CustomMaterialPageRoute extends MaterialPageRoute {
  @protected
  @override
  bool get hasScopedWillPopCallback {
    return false;
  }

  CustomMaterialPageRoute({
    required super.builder,
    required super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });
}
