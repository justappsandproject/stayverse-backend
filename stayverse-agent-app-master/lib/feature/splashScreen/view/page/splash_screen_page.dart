import 'package:gif/gif.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class SplashScreenPage extends StatelessWidget {
  static const route = '/';
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: AppColors.black,
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
