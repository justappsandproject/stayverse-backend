import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/feature/favourite/view/component/category_widget.dart';
import 'package:stayverse/feature/favourite/view/component/tab/apartment.dart';
import 'package:stayverse/feature/favourite/view/component/tab/car_tabs.dart';
import 'package:stayverse/feature/favourite/view/component/tab/chefs_tab.dart';
import 'package:stayverse/shared/app_icons.dart';

class FavouriteCategorySection extends StatefulWidget {
  const FavouriteCategorySection({super.key});

  @override
  State<FavouriteCategorySection> createState() =>
      _FavouriteCategorySectionState();
}

class _FavouriteCategorySectionState extends State<FavouriteCategorySection>
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
              return CategoryItemWidget(
                icon: AppIcons.shortlet,
                label: "Apartments",
                isSelected: value == 0,
              );
            }),
            _tabValueNotifier.sync(builder: (_, value, __) {
              return CategoryItemWidget(
                icon: AppIcons.car,
                label: "Rides",
                isSelected: value == 1,
              );
            }),
            _tabValueNotifier.sync(builder: (_, value, __) {
              return CategoryItemWidget(
                icon: AppIcons.chef,
                label: "Chefs",
                isSelected: value == 2,
              );
            }),
          ],
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              FavouriteApartmentTab(),
              FavouriteCarRentalTab(),
              FavouriteChefsTab(),
            ],
          ),
        ),
      ],
    );
  }
}
