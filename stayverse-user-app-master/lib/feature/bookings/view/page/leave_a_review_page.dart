import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/bookings/controller/review_controller.dart';
import 'package:stayverse/feature/bookings/controller/bookings_controller.dart';
import 'package:stayverse/feature/bookings/model/data/add_a_review_request.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class LeaveAReviewPage extends ConsumerStatefulWidget {
  static const route = '/LeaveAReviewPage';

  final LeaveAReviewArgs review;

  const LeaveAReviewPage({super.key, required this.review});

  @override
  ConsumerState<LeaveAReviewPage> createState() => _LeaveAReviewPageState();
}

class _LeaveAReviewPageState extends ConsumerState<LeaveAReviewPage> {
  double userRating = 0;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewController);

    return BrimSkeleton(
      isBusy: reviewState.isBusy,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Rating',
          style: $styles.text.title1.copyWith(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ),
      body: Column(
        children: [
          const Gap(80),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Rate Your Experience',
                style: $styles.text.body.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Gap(17),
              RatingBar(
                initialRating: userRating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 60,
                glow: false,
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: Colors.amber),
                  half: const Icon(Icons.star_half, color: Colors.amber),
                  empty: const Icon(Icons.star, color: Color(0xFFD9D9D9)),
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    userRating = rating;
                  });
                },
              ),
              const Gap(25),
              AppTextField(
                hintText: 'Describe your experience (optional)',
                controller: _reviewController,
                textInputAction: TextInputAction.done,
                borderRadius: BorderRadius.circular(10),
                minLines: 4,
              ),
            ],
          ),
          const Spacer(),
          AppBtn.from(
            text: 'Submit',
            expand: true,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            onPressed: () {
              _submitReview();
            },
          ),
          const Gap(40),
        ],
      ),
    );
  }

  void _submitReview() async {
    final addReviewController = ref.read(reviewController.notifier);

    if (userRating == 0) {
      BrimToast.showHint('Please add a rating');
      return;
    }

    final request = AddAReviewRequest(
      rating: userRating,
      review: _reviewController.text.trim(),
    );
    closKeyPad(context);
    final proceed = await addReviewController.sendAReview(
      widget.review.serviceType,
      widget.review.serviceId,
      request,
    );

    if (proceed) {
      await refreshAllBookings();

      $navigate.popUntil(1);
    }
  }

  Future<void> refreshAllBookings() async {
    final bookingCtrl = ref.read(bookingController.notifier);

    await Future.wait([
      bookingCtrl.getBookings(BookingStatus.pending),
      bookingCtrl.getBookings(BookingStatus.completed),
      bookingCtrl.getBookings(BookingStatus.accepted),
      bookingCtrl.getBookings(BookingStatus.rejected),
    ]);
  }
}
