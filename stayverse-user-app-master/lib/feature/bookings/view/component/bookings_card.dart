import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/feature/bookings/model/data/booking_response.dart';
import 'package:stayverse/feature/bookings/view/page/apartment_booked_page.dart';
import 'package:stayverse/feature/bookings/view/page/car_booked_page.dart';
import 'package:stayverse/feature/bookings/view/page/chef_booked_page.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';

class BookingsCard extends StatelessWidget {
  final Booking? booking;

  const BookingsCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToDetail();
      },
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    booking?.imageUrl ?? '',
                    width: 130,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          booking?.title ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                booking?.address ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          booking?.description ?? '',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail() {
    final result = booking?.service;

    if (result is Apartment && booking != null) {
      debugPrint(jsonEncode(result.agent?.toJson()), wrapWidth: 1024);

      $navigate.toWithParameters(ApartmentBookedPage.route, args: booking!);
      return;
    }

    if (result is Ride) {
      $navigate.toWithParameters(CarBookedPage.route, args: booking!);
      return;
    }

    if (result is Chef) {
      $navigate.toWithParameters(ChefBookedPage.route, args: booking!);
      return;
    }
  }
}
