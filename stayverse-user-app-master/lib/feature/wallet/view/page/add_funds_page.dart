import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/wallet/view/page/confirm_payment_page.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class AddFundsPage extends StatefulWidget {
  static const route = '/AddFundsPage';
  const AddFundsPage({super.key});

  @override
  State<AddFundsPage> createState() => _AddFundsPageState();
}

class _AddFundsPageState extends State<AddFundsPage> {
  final _formKey = GlobalKey<FormState>();
  final banks = ['Access Bank', 'UBA', 'GTBank', 'First Bank'];
  String? selectedBank;

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: const AppBackButton(),
        title: const Text(
          'Add Funds',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(0.05.sh),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Bank Transfer'),
                  value: selectedBank,
                  elevation: 2,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: banks.map((String bank) {
                    return DropdownMenuItem(
                      value: bank,
                      child: Text(bank),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedBank = value;
                    });
                  },
                ),
              ),
            ),
            const Gap(15),
            AppTextField(
              hintText: 'Amount',
              validator: (value) => Validator.validateEmptyField(value),
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.number,
            ),
            const Spacer(),
            AppBtn.from(
              text: 'Continue',
              expand: true,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              onPressed: _submit,
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      $navigate.to(ConfirmPaymentPage.route);
      // Handle withdrawal logic here
    }
  }
}
