import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/feature/home/controller/home_controller.dart';
import 'package:stayverse/feature/home/model/data/search_bar_data.dart';
import 'package:stayverse/feature/home/view/component/category_item.dart';
import 'package:stayverse/feature/home/view/component/tab/apartment_tab.dart';
import 'package:stayverse/feature/home/view/component/tab/car_tabs.dart';
import 'package:stayverse/feature/home/view/component/tab/chefs_tab.dart';
import 'package:stayverse/feature/search/controller/search_controller.dart';
import 'package:stayverse/shared/app_icons.dart';

class CategorySection extends ConsumerStatefulWidget {
  const CategorySection({super.key});

  @override
  ConsumerState<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends ConsumerState<CategorySection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabValueNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    _tabValueNotifier.value = _tabController.index;
    _updateSearchBarData(_tabValueNotifier.value);
  }

  _updateSearchBarData(int index) {
    ref
        .read(homeController.notifier)
        .updateSearchBarData(SearchBarData.byIndex(index));
    ref
        .read(searchController.notifier)
        .setServiceType(SearchBarData.byIndex(index).serviceType);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          isScrollable: false,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.black,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.only(right: 16),
          splashFactory: NoSplash.splashFactory,
          tabAlignment: TabAlignment.center,
          unselectedLabelColor: Colors.grey.shade400,
          indicator: const BoxDecoration(),
          tabs: [
            _tabValueNotifier.sync(builder: (_, value, __) {
              return CategoryItem(
                icon: AppIcons.shortlet,
                label: "Apartments",
                isSelected: value == 0,
              );
            }),
            _tabValueNotifier.sync(builder: (_, value, __) {
              return CategoryItem(
                icon: AppIcons.car,
                label: "Rides",
                isSelected: value == 1,
              );
            }),
            _tabValueNotifier.sync(builder: (_, value, __) {
              return CategoryItem(
                icon: AppIcons.chef,
                label: "Chefs",
                isSelected: value == 2,
              );
            }),
          ],
        ),
        const Gap(10),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              ApartmentTab(),
              CarRentalTab(),
              ChefsTab(),
            ],
          ),
        ),
      ],
    );
  }
}
