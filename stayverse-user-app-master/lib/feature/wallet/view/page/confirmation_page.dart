import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/wallet/view/page/withdrawal_successful_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';

class ConfirmationPage extends StatefulWidget {
  static const route = '/ConfirmationPage';
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            height: 260.h,
            child: SvgPicture.asset(
              AppAsset.vectorShape,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  centerTitle: true,
                  leading: const AppBackButton(),
                  title: const Text(
                    'Confirmation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const EmojiSection(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Spacer(),
                        const AmountSection(),
                        const Gap(24),
                        const TransferDetailsCard(),
                        const Spacer(),
                        AppBtn.from(
                          text: "Back",
                          expand: true,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            $navigate.to(WithdrawalSuccessfulPage.route);
                          },
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmojiSection extends StatelessWidget {
  const EmojiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAsset.bigSmile);
  }
}

class AmountSection extends StatelessWidget {
  const AmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Booking Confirmed',
          style: $styles.text.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Text(
          'Great news! You have successfully booked this apartment. Here are your booking details:',
          style: $styles.text.body.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class TransferDetailsCard extends StatelessWidget {
  const TransferDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.color.primary),
      ),
      child: const Column(
        children: [
          DetailRow(label: 'Pickup Date', value: 'Wednesday 4th January'),
          DetailRow(label: 'Pickup Time', value: '12:00 PM'),
          DetailRow(
              label: 'Location', value: '7 Bayview street, Lekki Phase 1'),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isCopyable;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isCopyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: $styles.text.body.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF2C2C2C),
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: $styles.text.body.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
              const Gap(5),
              if (isCopyable)
                GestureDetector(
                  child: const Icon(
                    Icons.copy,
                    size: 16,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account number copied!')),
                    );
                  },
                )
            ],
          ),
        ],
      ),
    );
  }
}
