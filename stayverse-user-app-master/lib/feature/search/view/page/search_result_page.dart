import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/widget_extension.dart';
import 'package:stayverse/feature/search/controller/search_controller.dart';
import 'package:stayverse/feature/search/view/component/search_map_view.dart';
import 'package:stayverse/feature/search/view/component/search_result_dialog.dart';
import 'package:stayverse/feature/search/view/component/search_widget.dart';
import 'package:stayverse/feature/search/view/component/tab/list_view_tab.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  static const route = '/SearchResultPage';
  const SearchResultPage({super.key});

  @override
  ConsumerState<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllListings();
    });
  }

  Future<void> _loadAllListings() async {
    final notifier = ref.read(searchController.notifier);
    await Future.wait([
      notifier.searchApartmentsWithFilter(),
      notifier.searchChefs(''),
      notifier.searchRides(''),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final currentServiceType =
        ref.watch(searchController.select((state) => state.serviceType));
    return BrimSkeleton(
      appBar: AppBar(
        leading: AppBackButton(
          onBack: () {
            SearchResultDialog.closeSearchResult();
            $navigate.back();
          },
        ),
        title: Text(
          'Search',
          style: $styles.text.title1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      body: Column(
        children: [
          Gap(0.04.sh),
          const SearchWidget().paddingSymmetric(horizontal: 16),
          const Gap(16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _serviceTypeChip('Rent', ServiceType.apartment,
                    currentServiceType == ServiceType.apartment),
                const Gap(8),
                _serviceTypeChip('Cars', ServiceType.rides,
                    currentServiceType == ServiceType.rides),
                const Gap(8),
                _serviceTypeChip('Chefs', ServiceType.chefs,
                    currentServiceType == ServiceType.chefs),
              ],
            ),
          ),
          const Gap(20),
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            unselectedLabelColor: Colors.grey.shade400,
            labelStyle: $styles.text.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: $styles.text.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            tabs: const [
              Tab(child: Text('List View')),
              Tab(child: Text('Map View'))
            ],
          ),
          Expanded(
              child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [ListViewTab(), SearchMapView()],
          ))
        ],
      ),
    );
  }

  Widget _serviceTypeChip(String label, ServiceType serviceType, bool selected) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        ref.read(searchController.notifier).setServiceType(serviceType);
      },
      selectedColor: Colors.black12,
      backgroundColor: Colors.grey.shade200,
      labelStyle: $styles.text.body.copyWith(
        color: selected ? Colors.black : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
