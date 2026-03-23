import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/feature/bookings/controller/bookings_controller.dart';
import 'package:stayverse/feature/bookings/view/component/tab/accepted_bookings.dart';
import 'package:stayverse/feature/bookings/view/component/tab/completed_bookings.dart';
import 'package:stayverse/feature/bookings/view/component/tab/pending_bookings.dart';
import 'package:stayverse/feature/bookings/view/component/tab/rejected_bookings.dart';
import 'package:stayverse/shared/skeleton.dart';

class BookingsPage extends ConsumerStatefulWidget {
  const BookingsPage({super.key});

  @override
  ConsumerState<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends ConsumerState<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _currentIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      _currentIndex.value = _tabController.index;
    });

    Future.microtask(() {
      ref.read(bookingController.notifier).getBookings(BookingStatus.pending);
      ref.read(bookingController.notifier).getBookings(BookingStatus.completed);
      ref.read(bookingController.notifier).getBookings(BookingStatus.accepted);
      ref.read(bookingController.notifier).getBookings(BookingStatus.rejected);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  BorderRadius _getTabBorderRadius(int tabIndex, int currentIndex) {
    if (tabIndex == currentIndex) {
      switch (tabIndex) {
        case 0: // First tab
          return const BorderRadius.only(
            topLeft: Radius.circular(18),
            bottomLeft: Radius.circular(18),
          );
        case 3: // Last tab
          return const BorderRadius.only(
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
          );
        default: // Middle tabs
          return const BorderRadius.all(Radius.circular(20));
      }
    }
    return BorderRadius.zero;
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
          'Bookings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const Gap(10),
          Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: context.color.primary, width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ValueListenableBuilder(
              valueListenable: _currentIndex,
              builder: (context, value, _) {
                return TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  physics: const NeverScrollableScrollPhysics(),
                  indicatorWeight: 0,
                  dividerHeight: 0,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  indicator: BoxDecoration(
                    borderRadius: _getTabBorderRadius(value, value),
                    color: context.color.primary,
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey.shade700,
                  labelStyle: $styles.text.body.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: $styles.text.body.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                  tabAlignment: TabAlignment.fill,
                  tabs: const [
                    Tab(
                      child: Text(
                        'Accepted',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Completed',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Pending',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Rejected',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Gap(20),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                AcceptedBookings(),
                CompletedBooking(),
                PendingBookings(),
                RejectedBookings(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
