import 'package:stayverse/core/commonLibs/common_libs.dart';

class PrivacyPolicySheet extends StatelessWidget {
  const PrivacyPolicySheet({super.key});

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
                      'Stayverse Privacy Policy',
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
                      'Stayverse values your privacy and is committed to protecting your personal information. This Privacy Policy explains how we collect, use, and protect your data when you use our platform and services.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section 1
                    Text(
                      '1. Information We Collect',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'We may collect personal details such as your name, email address, phone number, payment information, and booking history. We may also collect non-personal information such as device type, browser, and location data for service optimization.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 2
                    Text(
                      '2. How We Use Your Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'Your information is used to process bookings, facilitate communication with hosts and service providers, improve our services, and provide customer support.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 3
                    Text(
                      '3. Sharing of Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'Stayverse will never sell your information to third parties. We may share your information with hosts, drivers, and chefs strictly for fulfilling your bookings. We may also disclose data if required by law or to protect our rights.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 4
                    Text(
                      '4. Data Security',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'We implement industry-standard security measures to safeguard your data. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 5
                    Text(
                      '5. Your Rights',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'You have the right to access, update, or request deletion of your personal information. You may also opt out of marketing communications at any time.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section 6
                    Text(
                      '6. Updates to this Policy',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      'Stayverse may update this Privacy Policy from time to time. Any changes will be communicated on our platform. Continued use of our services indicates acceptance of the revised policy.',
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

void showPrivacyPolicy(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const PrivacyPolicySheet(),
  );
}
