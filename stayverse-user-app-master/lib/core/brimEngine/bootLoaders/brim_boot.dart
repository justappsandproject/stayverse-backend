import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/brimEngine/bootLoaders/brim_boot_loader.dart';
import 'package:stayverse/core/brimEngine/brim_loaders.dart';

class BrimBoot {
  static Future<void> brim() async {
    await _setup();
    await bootApplication(bootLoaders);
  }

  static Future<void> finished() async {
    await bootFinished(bootLoaders);
  }

  static Future<void> _setup() async {
    injectDependency();
  }
}
