import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:stayverse/core/util/app/validator.dart';
import 'package:stayverse/core/util/textField/app_text_field.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  static const route = '/EditProfilePage';
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>(); //Agalaba

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    _populateFields();
    super.initState();
  }

  void _populateFields() {
    final populate = ref.read(dashboadController);
    _firstNameController.text = populate.user?.firstname ?? '';
    _lastNameController.text = populate.user?.lastname ?? '';
    _phoneNumController.text = populate.user?.phoneNumber ?? '';
    _emailController.text = populate.user?.email ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: true,
      isBusy: ref.watch(dashboadController).isBusy,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: const AppBackButton(),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              Text(
                'Edit Profile',
                style: $styles.text.bodyBold.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              const Gap(8),
              Text(
                'You can update your profile information.',
                style: $styles.text.bodyBold.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Gap(0.05.sh),
              AppTextField(
                title: 'First Name',
                hintText: 'First Name',
                controller: _firstNameController,
                validator: (value) => Validator.validateName(value),
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
              ),
              const Gap(20),
              AppTextField(
                title: 'Last Name',
                hintText: 'Last Name',
                controller: _lastNameController,
                validator: (value) => Validator.validateName(value),
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
              ),
              const Gap(20),
              AppTextField(
                title: 'Phone Number',
                hintText: 'Phone Number',
                controller: _phoneNumController,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.number,
                disableBorderColor: Colors.grey.shade300,
                readOnly: true,
                enabled: false,
              ),
              const Gap(20),
              AppTextField(
                title: 'Email',
                hintText: 'Email',
                controller: _emailController,
                validator: (value) => Validator.validateEmail(value),
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.emailAddress,
                disableBorderColor: Colors.grey.shade300,
                readOnly: true,
                enabled: false,
              ),
              Gap(0.10.sh),
              AppBtn.from(
                text: 'Save Changes',
                expand: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onPressed: () {
                  _submit();
                },
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {

      closKeyPad(context);
      final proceed = await ref.read(dashboadController.notifier).updateProfile(
          _firstNameController.text.trim(), _lastNameController.text.trim());

      if (proceed) {
        $navigate.popUntil(1);
      }
    }
  }
}
