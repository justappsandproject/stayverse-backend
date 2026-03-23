import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/feature/bookings/model/data/booking_response.dart';
import 'package:stayverse/feature/bookings/model/data/leave_a_review_args.dart';
import 'package:stayverse/feature/bookings/view/page/leave_a_review_page.dart';
import 'package:stayverse/feature/chefDetails/view/component/certification_section.dart';
import 'package:stayverse/feature/chefDetails/view/component/experience_section.dart';
import 'package:stayverse/feature/favourite/view/component/build_featured_section.dart';
import 'package:stayverse/feature/favourite/view/component/section_title.dart';
import 'package:stayverse/feature/home/view/component/chef_about_section.dart';
import 'package:stayverse/feature/home/view/component/chef_profile_header.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';

class ChefBookedPage extends StatefulWidget {
  static const route = '/ChefBookedPage';
  const ChefBookedPage({super.key, this.data});

  final Booking? data;

  @override
  State<ChefBookedPage> createState() => _ChefBookedPageState();
}

class _ChefBookedPageState extends State<ChefBookedPage> {
  @override
  Widget build(BuildContext context) {
    final booking = widget.data;
    final isCompleted = booking?.status == BookingStatus.completed.name;
    return BrimSkeleton(
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChefProfileHeader(
              chef: widget.data?.chef,
              totalPrice: widget.data?.totalPrice,
            ),
            const Gap(17),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ChefAboutSection(
                    chef: widget.data?.chef,
                  ),
                  ExperienceSection(chef: widget.data?.chef),
                  const Gap(24),
                  const SectionTitle(title: 'Featured'),
                  const Gap(24),
                  FeaturedSection(chef: widget.data?.chef),
                  const Gap(10),
                  const HorizontalLine(
                    thickness: 0.8,
                  ),
                  const Gap(24),
                  LicenseSection(chef: widget.data?.chef),
                  if (isCompleted) ...[
                    const Gap(10),
                    AppBtn.from(
                      text: 'Leave a Review',
                      bgColor: Colors.black,
                      expand: true,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        $navigate.toWithParameters(
                          LeaveAReviewPage.route,
                          args: LeaveAReviewArgs(
                          serviceType: ServiceType.chefs.apiPoint,
                          serviceId: widget.data?.chef?.id ?? '',
                        ),
                        );
                      },
                    ),
                  ],
                  const Gap(32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
