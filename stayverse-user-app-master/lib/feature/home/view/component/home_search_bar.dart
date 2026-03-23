import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/search/view/page/search_result_page.dart';
import 'package:stayverse/shared/app_icons.dart';

class HomeSearchBar extends ConsumerWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchBarData = ref.watch(homeController).searchBarData;

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
                AppIcon(
                  searchBarData.icon,
                  size: 24,
                  color: Colors.grey[400],
                ),
                const Gap(8),
                Expanded(
                  child: TextField(
                    onTap: () {
                      
                      $navigate.to(SearchResultPage.route);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: searchBarData.title,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // const Gap(10),
        // AppBtn.basic(
        //   onPressed: () {
        //     $navigate.to(ChefFilterPage.route);
        //   },
        //   semanticLabel: 'Filter Button',
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        //     decoration: BoxDecoration(
        //       color: context.color.primary,
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     child: const AppIcon(AppIcons.filter, color: Colors.black),
        //   ),
        // ),
      ],
    );
  }
}
