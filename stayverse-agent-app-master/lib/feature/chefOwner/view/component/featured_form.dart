import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/media_type_extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/apartmentOwner/controller/image_picker_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/featured_request.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/featured_image_widget.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../../../../shared/app_back_button.dart';

class FeaturedForm extends ConsumerStatefulWidget {
  static const route = '/FeaturedForm';
  const FeaturedForm({super.key});

  @override
  ConsumerState<FeaturedForm> createState() => _FeaturedFormState();
}

class _FeaturedFormState extends ConsumerState<FeaturedForm> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
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
                    'Add A Featured'.txt(
                      size: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    23.sbH,
                    const FeaturedImageWidget(mode: ProviderMode.create,),
                    27.sbH,
                    AppTextField(
                      title: 'Description',
                      controller: _descriptionController,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 17),
                      minLines: 5,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      borderRadius: BorderRadius.circular(17),
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
    final imageState = ref.read(createPickImageProvider);
    final featuredImage = imageState["featured"];

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<MultipartFile>? featuredPhotoFiles;
      if (featuredImage != null) {
        final featuredExt = featuredImage.name.split('.').last;
        final featuredContentType = getContentTypeFromExtension(featuredExt);

        featuredPhotoFiles = [
          await MultipartFile.fromFile(
            featuredImage.path,
            filename: featuredImage.name,
            contentType: featuredContentType,
          ),
        ];
      }

      final request = FeaturedRequest(
        featuredImage: featuredPhotoFiles,
        imageDescription: _descriptionController.text.trim(),
      );

      final proceed =
          await ref.read(chefController.notifier).createFeatured(request);

      if (proceed) {
        _resetState();
        $navigate.back();
      }
    }
  }

  void _resetState() {
    ref.read(createPickImageProvider.notifier).removeImage("featured");
  }
}
