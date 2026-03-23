import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/widget_extension.dart';
import 'package:stayverse/feature/search/view/component/search_map_view.dart';
import 'package:stayverse/feature/search/view/component/search_result_dialog.dart';
import 'package:stayverse/feature/search/view/component/search_widget.dart';
import 'package:stayverse/feature/search/view/component/tab/list_view_tab.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/skeleton.dart';

class SearchResultPage extends StatefulWidget {
  static const route = '/SearchResultPage';
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
}
