import 'package:flutter/material.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/feature/bookings/model/data/booking_response.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/page/reviews_page.dart';

class RideHeaderSection extends StatelessWidget {
  final String rideName;
  final double rating;
  final Booking rideBooking;

  const RideHeaderSection({
    super.key,
    required this.rideName,
    required this.rating,
    required this.rideBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            rideName,
            style: $styles.text.title1.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            $navigate.toWithParameters(ReviewsPage.route,
                args: LeaveAReviewArgs(
                     serviceType: ServiceType.rides.apiPoint,
                      serviceId: rideBooking.ride?.id ?? '',));
          },
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.black, size: 20),
              Text(
                rating.toStringAsFixed(1),
                style: $styles.text.bodyBold.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: 0.85,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
