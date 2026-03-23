import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/search/controller/search_controller.dart';
import 'package:stayverse/feature/search/view/page/apartment_filter_page.dart';
import 'package:stayverse/feature/search/view/page/car_filter_page.dart';
import 'package:stayverse/feature/search/view/page/chef_filter_page.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/full_screen_dailog.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                AppIcon(ref.watch(homeController).searchBarData.icon,
                    color: context.color.primary),
                const Gap(8),
                Expanded(
                  child: TextField(
                    style: $styles.text.body.copyWith(
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      ref.read(searchController.notifier).debounceSearch(value);
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: ref.watch(homeController).searchBarData.title,
                      hintStyle: $styles.text.body
                          .copyWith(color: Colors.grey.shade400),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(10),
        GestureDetector(
          onTap: () {
            _submit(ref, context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: context.color.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const AppIcon(AppIcons.filter, color: Colors.black),
          ),
        ),
      ],
    );
  }

  void _submit(WidgetRef ref, BuildContext context) {
    final serviceType = ref.read(searchController.notifier).serviceType;
    switch (serviceType) {
      case ServiceType.apartment:
        _showapApartmentFilterPage(context);
        break;
      case ServiceType.chefs:
        _showChefFilterPage();
        break;
      case ServiceType.rides:
        _showCarFilterPage();
        break;
    }
  }

  _showapApartmentFilterPage(BuildContext context) async {
    final shouldApply =
        await showFullScreenDialog(context, child: const ApartmentFilterPage());

    if (shouldApply == true) {
      ref.read(searchController.notifier).search(_searchController.text);
    }
  }

  _showChefFilterPage() async {
    final shouldApply =
        await showFullScreenDialog(context, child: const ChefFilterPage());

    if (shouldApply == true) {
      ref.read(searchController.notifier).search(_searchController.text);
    }
  }

  _showCarFilterPage() async {
    final shouldApply =
        await showFullScreenDialog(context, child: const CarFilterPage());

    if (shouldApply == true) {
      ref.read(searchController.notifier).search(_searchController.text);
    }
  }
}
