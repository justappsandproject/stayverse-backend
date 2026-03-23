// home_page.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/home/view/component/category_section.dart';
import 'package:stayverse/feature/home/view/component/home_app_bar.dart';
import 'package:stayverse/feature/home/view/component/home_search_bar.dart';
import 'package:stayverse/shared/skeleton.dart';

class HomePage extends ConsumerStatefulWidget {
  static const route = '/HomePage';
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    Future.microtask(() {

      ref.read(homeController.notifier).getApartmentRecommendations();
      ref.read(homeController.notifier).getChefRecommendations();
      ref.read(homeController.notifier).getRideRecommendations();
      ref.read(homeController.notifier).getNewlyListedApartment();
      ref.read(homeController.notifier).getNewlyListedChef();
      ref.read(homeController.notifier).getNewlyListedRide();
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(0.1.sh),
          const HomeHeader(),
          const Gap(20),
          const HomeSearchBar(),
          const Gap(20),
          const Expanded(
            child: CategorySection(),
          ),
        ],
      ),
    );
  }
}
