// home_header.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Hi ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: ref.read(dashboadController).user?.firstname ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Text(
              "Let's start exploring!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Gap(4),
            Image.asset(
              AppAsset.smallSmile,
            )
          ],
        ),
      ],
    );
  }
}
