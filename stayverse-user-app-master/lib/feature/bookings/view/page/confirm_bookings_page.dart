import 'package:flutter/material.dart';
import 'package:gap/gap.dart'; // Import the gap package
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/shared/calender/custom_calendar.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class ConfirmBookingsPage extends StatefulWidget {
  static const route = '/ConfirmBookingsPage';
  const ConfirmBookingsPage({super.key});

  @override
  State<ConfirmBookingsPage> createState() => _ConfirmBookingsPageState();
}

class _ConfirmBookingsPageState extends State<ConfirmBookingsPage> {
  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(
          'Bookings',
          style: $styles.text.title1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.asset(
                    AppAsset.apartment,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'De Vans Apartment',
                    style: $styles.text.title1.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.black),
                      Text(
                        ' 4.68',
                        style: $styles.text.bodyBold.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(4),
              Row(
                children: [
                  Text(
                    'N80k',
                    style: $styles.text.body.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '/night',
                    style: $styles.text.body.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Check-in Date',
                          style: $styles.text.title1.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'N900k',
                          style: $styles.text.title1.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    CustomCalendar(
                      onDateSelected: (DateTime date) {
                        // Handle date selection
                      },
                    ),
                  ],
                ),
              ),
              const Gap(24),
              AppBtn.from(
                text: 'Confirm Bookings',
                expand: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
