import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/feature/Reviews/controller/review_controller.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_args.dart';
import 'package:stayvers_agent/feature/Reviews/model/data/review_response.dart';
import 'package:stayvers_agent/feature/Reviews/view/component/reviews_list_card.dart';
import 'package:stayvers_agent/shared/empty_state_view.dart';
import 'package:stayvers_agent/shared/item_view.dart';
import 'package:stayvers_agent/shared/lazy_load_scroll_view.dart';
import 'package:stayvers_agent/shared/shimmer/booked_vertical_shimmer.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class ReviewsPage extends ConsumerStatefulWidget {
  static const route = '/ReviewsPage';

  final ReviewArgs review;
  const ReviewsPage({super.key, required this.review});

  @override
  ConsumerState<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends ConsumerState<ReviewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(reviewController.notifier)
          .getReviews(widget.review.serviceType, widget.review.serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.white,
        title: Text(
          'Reviews',
          style: $styles.text.body.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        displacement: 20,
        onRefresh: () async => ref.read(reviewController.notifier).getReviews(
              widget.review.serviceType,
              widget.review.serviceId,
            ),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: ItemView<Review>(
                  items: ref.watch(reviewController).reviews,
                  isAdsLoading: ref.watch(reviewController).isLoading,
                  loader: const BookedListShimmerLoader(),
                  emptyState: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlexibleEmptyStateView(
                          message: 'No Reviews Found',
                          subtitle: 'No Reviews available for this ',
                          lottieAsset: AppAsset.empty,
                        ),
                      ],
                    ),
                  ),
                  itemViewBuilder: (context, child, List<Review> items) {
                    return LazyLoadScrollView(
                      showLoadinIndicator: true,
                      onEndOfPage: () async {
                        await ref.read(reviewController.notifier).getReviews(
                            widget.review.serviceType, widget.review.serviceId);
                      },
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ReviewsListCard(
                            review: items[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Gap(15);
                        },
                        itemCount: items.length,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
