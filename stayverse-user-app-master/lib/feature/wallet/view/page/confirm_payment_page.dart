import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/wallet/view/page/pin_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';

class ConfirmPaymentPage extends StatefulWidget {
  static const route = '/ConfirmPaymentPage';
  const ConfirmPaymentPage({super.key});

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
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
                    'Confirm Payment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Gap(20),
                const EmojiSection(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Gap(40),
                        const AmountSection(),
                        const Gap(24),
                        const TransferDetailsCard(),
                        const Spacer(),
                        AppBtn.from(
                          text: "I've made this transfer",
                          expand: true,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            $navigate.to(PinPage.route);
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
          'Total Payment',
          style: $styles.text.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.color.primary,
          ),
        ),
        Text(
          'N1,000,000',
          style: $styles.text.body.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
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
          DetailRow(label: 'Payment Type', value: 'Bank Transfer'),
          DetailRow(label: 'Bank Name', value: 'Werna Bank'),
          DetailRow(label: 'Account Name', value: 'Paystack TITAN'),
          DetailRow(
            label: 'Account Number',
            value: '8059854366',
            isCopyable: true,
          ),
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
                ),
            ],
          ),
        ],
      ),
    );
  }
}
