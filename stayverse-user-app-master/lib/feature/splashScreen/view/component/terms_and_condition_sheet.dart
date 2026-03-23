import 'package:stayverse/core/commonLibs/common_libs.dart';

class TermsAndConditionsSheet extends StatelessWidget {
  const TermsAndConditionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  children: [
                    // Title
                    const Text(
                      'Stayverse Terms and Conditions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Introduction
                    Text(
                      'Welcome to Stayverse! These Terms and Conditions govern your use of our platform, services, and applications. By accessing or using Stayverse, you agree to comply with and be bound by these Terms. If you do not agree, please refrain from using our services.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section 1
                    Text(
                      '1. Use of Services',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'Stayverse provides a platform that connects users to verified apartments, vehicles, and catering services. Users must be at least 18 years old to use our platform. You agree to provide accurate information and comply with all applicable laws when using our services.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 2
                    Text(
                      '2. Bookings and Payments',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'All bookings made through Stayverse must be paid in full at the time of confirmation unless otherwise stated. You authorize Stayverse to charge your selected payment method for all bookings and related fees.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 3
                    Text(
                      '3. Cancellations and Refunds',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'Cancellations are subject to the Stayverse Cancellation Policy. Refund eligibility will depend on the timing of your cancellation. No-shows are non-refundable.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 4
                    Text(
                      '4. User Responsibilities',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'Users are expected to treat hosts, drivers, and chefs respectfully and responsibly. Any misuse, abuse, or violation of our policies may result in account suspension or termination.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 5
                    Text(
                      '5. Liability',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'Stayverse acts as an intermediary platform and is not directly responsible for the services provided by hosts, drivers, or chefs. We do not guarantee the accuracy of listings but ensure all are verified at the time of posting.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 6
                    Text(
                      '6. Modifications',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'Stayverse reserves the right to modify or update these Terms at any time. Continued use of our services after updates constitutes acceptance of the revised Terms.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
void showTermsAndConditions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const TermsAndConditionsSheet(),
  );
}