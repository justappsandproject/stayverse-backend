import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/service/permission/permission_manager.dart';
import 'package:stayverse/core/service/streamChat/stream_client_service.dart';
import 'package:stayverse/core/wrapper/notification/pusher/pusher.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayverse/feature/dashboard/view/component/bottom_bar.dart';
import 'package:stayverse/feature/dashboard/view/component/navigation_item.dart';
import 'package:stayverse/shared/lazy_indexed_stack.dart';
import 'package:stayverse/shared/skeleton.dart';

class DashbBoardScreenPage extends ConsumerStatefulWidget {
  static const route = '/dashboard';
  const DashbBoardScreenPage({super.key});

  @override
  ConsumerState<DashbBoardScreenPage> createState() =>
      _DashbBoardScreenPageState();
}

class _DashbBoardScreenPageState extends ConsumerState<DashbBoardScreenPage> {
  @override
  void initState() {
    Future.microtask(() {
      StreamClientService.instance.connect();
      StreamClientService.instance.pushToken();
      BrimPusher.pushToken();
      ref.read(dashboadController.notifier).refreshUser();
      _requestForPermission();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _requestForPermission() {
    PermissionManager.checkAndRequestForLocationPermission();
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
        children: NavigationItems.items.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
