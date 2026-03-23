// home_page.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/favourite/controller/favourite_controller.dart';
import 'package:stayverse/feature/favourite/view/component/favorite_category_section.dart';
import 'package:stayverse/shared/skeleton.dart';

class FavouritePage extends ConsumerStatefulWidget {
  static const route = '/FavouritePage';
  const FavouritePage({super.key});

  @override
  ConsumerState<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends ConsumerState<FavouritePage> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(favouriteController.notifier).getApartmentFavourites();
      ref.read(favouriteController.notifier).getChefFavourites();
      ref.read(favouriteController.notifier).getRideFavourites();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(),
        centerTitle: true,
        title: const Text(
          'Favourite',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20),
          Expanded(child: FavouriteCategorySection()),
        ],
      ),
    );
  }
}
