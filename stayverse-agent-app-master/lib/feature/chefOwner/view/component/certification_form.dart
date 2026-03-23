import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/app/validator.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/add_certification.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/experience_form.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../../../../shared/app_back_button.dart';

class CertificationForm extends ConsumerStatefulWidget {
  static const route = '/CertificationForm';
  const CertificationForm({super.key});

  @override
  ConsumerState<CertificationForm> createState() => _CertificationFormState();
}

class _CertificationFormState extends ConsumerState<CertificationForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _certURlController = TextEditingController();
  final _issuedDateController = TextEditingController();

  String? _issuedDateIso;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _certURlController.dispose();
    _issuedDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: true,
      isBusy: ref.watch(chefController).isBusy,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        leading: const AppBackButton(),
      ),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 18),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'Add Certifications'.txt(
                      size: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    23.sbH,
                    AppTextField(
                      title: 'Title',
                      controller: _titleController,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 17),
                      validator: (value) => Validator.validateEmptyField(value),
                    ),
                    27.sbH,
                    AppTextField(
                      title: 'Company or organization',
                      controller: _companyController,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 17),
                      validator: (value) => Validator.validateEmptyField(value),
                    ),
                    27.sbH,
                    ExperienceDatePicker(
                      label: 'Issued Date',
                      controller: _issuedDateController,
                      onDateSelected: (displayDate, isoDate) {
                        setState(() {
                          _issuedDateIso = isoDate;
                        });
                      },
                      validator: (value) => Validator.validateEmptyField(value),
                    ),
                    27.sbH,
                    AppTextField(
                      title: 'Certificate URL',
                      controller: _certURlController,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 17),
                      validator: (value) => Validator.validateUrl(value),
                    ),
                    27.sbH,
                  ],
                ),
              ),
            ),
          ),
          17.sbH,
          AppBtn.from(
            text: 'Save',
            expand: true,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            bgColor: AppColors.black,
            onPressed: () {
              _submit();
            },
          ),
          17.sbH,
        ],
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final proceed = await ref.read(chefController.notifier).addCertification(
            CertificationRequest(
              title: _titleController.text.trim(),
              organization: _companyController.text.trim(),
              issuedDate: _issuedDateIso,
              certificateUrl: _certURlController.text.trim(),
            ),
          );

      if (proceed) {
        ref.read(chefController.notifier).getChefStatus();
        $navigate.popUntil(1);
      }
    }
  }
}
