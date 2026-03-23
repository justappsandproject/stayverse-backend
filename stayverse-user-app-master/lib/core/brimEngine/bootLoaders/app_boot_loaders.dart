import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:stayverse/core/brimEngine/bootLoaders/brim_boot_loader.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/appEnviroment/enviroment.dart';
import 'package:stayverse/core/config/evn/env.dart';
import 'package:stayverse/core/event/brim_resgister.dart';
import 'package:stayverse/core/event/evenList/load_storage_to_cache.dart';
import 'package:stayverse/core/service/storage/brim_storage.dart';
import 'package:stayverse/core/service/streamChat/stream_client_service.dart';
import 'package:stayverse/core/util/app/orientation.dart';
import 'package:stayverse/core/util/app/platform_info.dart';
import 'package:stayverse/core/util/map/map_utility.dart';
import 'package:stayverse/feature/splashScreen/view/page/onboarding.dart';

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
