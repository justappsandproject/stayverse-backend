import 'package:gif/gif.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/shared/skeleton.dart';

class SplashScreenPage extends StatelessWidget {
  static const route = '/';
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: context.color.primary,
      body: Center(
          child: Gif(
        image: AssetImage(AppAsset.splashingGif),
        autostart: Autostart.once,
        width: 150,
        height: 150,
      )),
    );
  }
}
