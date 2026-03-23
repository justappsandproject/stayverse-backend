import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/profile/controller/profile_controller.dart';
import 'package:stayverse/feature/profile/model/data/update_password_request.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  static const route = '/ChangePasswordPage';
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: true,
      isBusy: ref.watch(profileController).isBusy,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: const AppBackButton(),
        title: const Text(
          'Change Password',
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
            const Gap(15),
            AppTextField(
              hintText: 'Current Password',
              controller: _currentPasswordController,
              validator: (value) => Validator.validatePassword(value),
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.visiblePassword,
            ),
            const Gap(15),
            AppTextField(
              hintText: 'New Password',
              controller: _newPasswordController,
              validator: (value) => Validator.validatePassword(value),
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.visiblePassword,
            ),
            const Gap(15),
            AppTextField(
              hintText: 'Confirm Password',
              controller: _confirmPasswordController,
              validator: (value) => Validator.validateConfirmPassword(
                  value, _newPasswordController.text),
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.visiblePassword,
            ),
            const Spacer(),
            AppBtn.from(
              text: 'Confirm',
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final proceed = await ref.read(profileController.notifier).updatePassword(
            UpdatePasswordRequest(
              oldPassword: _currentPasswordController.text,
              newPassword: _newPasswordController.text,
            ),
          );

      if (proceed) {
        $navigate.back();
      }
    }
  }
}
