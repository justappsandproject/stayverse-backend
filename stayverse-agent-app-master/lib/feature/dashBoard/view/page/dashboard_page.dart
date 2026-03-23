import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/service/streamChat/stream_client_service.dart';
import 'package:stayvers_agent/shared/lazy_indexed_stack.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../controller/dashboard_controller.dart';
import '../component/bottom_bar.dart';
import '../component/navigation_items.dart';
import 'package:stayvers_agent/core/wrapper/notification/pusher/pusher.dart';

class DashBoardPage extends ConsumerStatefulWidget {
  static const route = '/DashBoardPage';
  const DashBoardPage({super.key});

  @override
  ConsumerState<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends ConsumerState<DashBoardPage> {
  @override
  void initState() {
    Future.microtask(() {
      StreamClientService.instance.connect();
      StreamClientService.instance.pushToken();
      BrimPusher.pushToken();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        ref.watch(dashboadController.select((state) => state.currentPageIndex));

    return BrimSkeleton(
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      body: LazyIndexedStack(
        index: currentIndex,
        children:
            NavigationItems.items(ref).map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
