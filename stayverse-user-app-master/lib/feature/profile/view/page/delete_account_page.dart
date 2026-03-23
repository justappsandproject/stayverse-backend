import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/view/page/login_page.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/service/appSession/session.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/profile/controller/delete_account_controller.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class DeleteAccountPage extends ConsumerStatefulWidget {
  static const String route = '/DeleteAccount';

  const DeleteAccountPage({super.key});

  @override
  ConsumerState<DeleteAccountPage> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isBusy: ref.watch(deleteAccountController).isBusy,
      backgroundColor: $styles.colors.white,
      bodyPadding: const EdgeInsets.symmetric(horizontal: 16),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Delete Account',
          style: $styles.text.h1.copyWith(
            color: $styles.colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: $styles.colors.white,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(30),
              Text(
                  'You will lose access to your profile, and all account details will be permanently erased.',
                  textAlign: TextAlign.center,
                  style: $styles.text.bodySmall.copyWith(
                      fontWeight: FontWeight.w400,
                      color: $styles.colors.black,
                      fontSize: 14.sp)),
              const Gap(40),
              AppTextField(
                hintText: 'Type in your password to confirm',
                controller: _passwordController,
                isPassword: true,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                validator: (value) => Validator.validatePassword(value),
              ),
              const Gap(60),
              AppBtn.from(
                onPressed: () {
                  _submit();
                },
                textColor: $styles.colors.white,
                expand: true,
                bgColor: Colors.red,
                semanticLabel: '',
                text: 'Delete Account',
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final proceed =
          await ref.read(deleteAccountController.notifier).deleteAccount(
                _passwordController.text.trim(),
              );

      if (proceed) {
        _logOut();
      }
    }
  }

  _logOut() async {
    await AppSession.logOut(ref, route: LoginPage.route);
  }
}
