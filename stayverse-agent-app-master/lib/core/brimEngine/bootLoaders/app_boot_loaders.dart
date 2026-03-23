import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:stayvers_agent/core/brimEngine/bootLoaders/brim_boot_loader.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/appEnviroment/enviroment.dart';
import 'package:stayvers_agent/core/config/evn/env.dart';
import 'package:stayvers_agent/core/event/brim_resgister.dart';
import 'package:stayvers_agent/core/event/evenList/load_storage_to_cache.dart';
import 'package:stayvers_agent/core/service/storage/brim_storage.dart';
import 'package:stayvers_agent/core/service/streamChat/stream_client_service.dart';
import 'package:stayvers_agent/core/util/app/orientation.dart';
import 'package:stayvers_agent/core/util/app/platform_info.dart';
import 'package:stayvers_agent/core/util/map/map_utility.dart';
import 'package:stayvers_agent/feature/splashScreen/view/page/onboarding.dart';

class AppBootLoaders extends BrimBootLoader {
  @override
  Future<void> boot() async {
    await BrimStorage.instance.initializeDataBase();

    await eventOn<LoadStorageToCache>();

    if (PlatformInfo.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
    HandleDeviceOrientation.instance.setDeviceOrientation(Axis.vertical);

    MapUtility.instance.loadMapAssest();

    StreamClientService.instance.initClient(environment);
  }

  @override
  Future<void> afterBoot() async {
    navigate();
  }

  Future<void> navigate() async {
    await _fakeDelay();

    String route = BrimStorage.instance.read(Env.screenStorageScreen) ??
        OnboardingScreen.route;
    $navigate.clearAllTo(route);
  }

  Future<void> _fakeDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
