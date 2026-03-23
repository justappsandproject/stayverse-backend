import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/extension/media_type_extension.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/apartmentOwner/controller/image_picker_controller.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/custom_textfield_ui_state.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/image_picker_ui_state.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_request.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../../apartmentOwner/view/component/custom_textfield.dart';
import '../../controller/culinary_specialties_controller.dart';
import '../component/chef_location_search.dart';
import '../component/cover_image.dart';
import '../component/profile_image_widget.dart';
import 'culinary_specialties_page.dart';

class EditChefProfilePage extends ConsumerStatefulWidget {
  static const route = '/EditChefProfilePage';
  const EditChefProfilePage({super.key});

  @override
  ConsumerState<EditChefProfilePage> createState() =>
      _EditChefProfilePageState();
}

class _EditChefProfilePageState extends ConsumerState<EditChefProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _pricingController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  String? _selectedPlaceId;

  @override
  void initState() {
    super.initState();
    // Defer profile loading until after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  void _loadProfile() {
    final profile = ref.read(chefController).profile;
    if (profile == null) return;

    _fullNameController.text = profile.fullName ?? '';
    _bioController.text = profile.bio ?? '';
    _aboutController.text = profile.about ?? '';
    _locationController.text = profile.address ?? '';
    _selectedPlaceId = profile.placeId;
    _pricingController.text = profile.pricingPerHour?.toString() ?? '';

    // Load specialty selections - now safe to modify provider
    if (profile.culinarySpecialties != null) {
      ref
          .read(editCulinarySpecialtiesProvider.notifier)
          .setSelectedSpecialties(profile.culinarySpecialties!);
    }

    // Load existing images for edit mode
    final imageNotifier = ref.read(editPickImageProvider.notifier);
    imageNotifier.setInitialRemoteImage('profile', profile.profilePicture);
    imageNotifier.setInitialRemoteImage('cover', profile.coverPhoto);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bioController.dispose();
    _aboutController.dispose();
    _pricingController.dispose();
    _locationController.dispose();
    _locationFocusNode.dispose();
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              'Edit profile'.txt(
                size: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              23.sbH,
              AppTextField(
                title: 'FullName',
                controller: _fullNameController,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              ),
              27.sbH,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: $styles.text.h4.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  10.sbH,
                  ChefLocationSearch(
                    onLocationSelected: (placeId, location) {
                      _selectedPlaceId = placeId;
                      _locationController.text = location;
                    },
                    controller: _locationController,
                    focusNode: _locationFocusNode,
                  ),
                ],
              ),
              27.sbH,
              AppTextField(
                title: 'Bio',
                controller: _bioController,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                minLines: 3,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                borderRadius: BorderRadius.circular(17),
              ),
              27.sbH,
              AppTextField(
                title: 'About',
                controller: _aboutController,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                minLines: 3,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                borderRadius: BorderRadius.circular(17),
              ),
              12.sbH,
              const CulinarySpecialtiesSelection(
                mode: ProviderMode.edit,
              ),
              27.sbH,
              SizedBox(
                width: 160,
                child: CustomTextField(
                  semanticLabel: 'Menu & Pricing',
                  title: 'Menu & Pricing /hour',
                  controller: _pricingController,
                  inputFormatters: [MoneyFormatter()],
                  keyboardType: TextInputType.number,
                ),
              ),
              27.sbH,
              const ProfilePictureWidget(mode: ProviderMode.edit),
              27.sbH,
              const CoverPhotoWidget(mode: ProviderMode.edit),
              35.sbH,
              AppBtn.from(
                text: 'Save Changes',
                expand: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                bgColor: AppColors.black,
                onPressed: () {
                  _submit(context);
                },
              ),
              17.sbH,
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    // Get selected specialties
    final selectedSpecialties = ref
        .read(editCulinarySpecialtiesProvider)
        .where((specialty) => specialty.isSelected)
        .toList();

    // Check if at least 3 specialties are selected
    final isSpecialtiesValid = selectedSpecialties.length >= 3;

    if (!isSpecialtiesValid) {
      // Show toast if not enough specialties selected
      BrimToast.showHint('Please select at least 3 culinary specialties.');
      return;
    }

    // Get specialty names for the request
    final specialtyNames =
        selectedSpecialties.map((specialty) => specialty.name).toList();

    // Get images from the provider
    final imageState = ref.read(editPickImageProvider);
    final profileImage = imageState["profile"];
    final coverImage = imageState["cover"];

    // Validate the form
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Format pricing
      final pricingStr =
          _pricingController.text.replaceAll(RegExp(r'[^0-9.]'), '');
      final pricing = double.tryParse(pricingStr) ?? 0.0;

      List<MultipartFile>? processFile(ImageFile? file) {
        if (file == null) return null;
        if (file.isRemote == true) return null; // <-- prevents your crash

        final ext = file.name.split('.').last;
        final contentType = getContentTypeFromExtension(ext);

        return [
          MultipartFile.fromFileSync(
            file.path,
            filename: file.name,
            contentType: contentType,
          ),
        ];
      }

      final profilePictureFiles = processFile(profileImage);
      final coverPhotoFiles = processFile(coverImage);

      // Create the request object with all data
      final request = ChefProfileRequest(
        fullName: _fullNameController.text,
        placeId: _selectedPlaceId,
        bio: _bioController.text,
        about: _aboutController.text,
        culinarySpecialties: specialtyNames,
        pricingPerHour: pricing,
        profilePicture: profilePictureFiles,
        coverPhoto: coverPhotoFiles,
      );

      // Submit request
      final proceed =
          await ref.read(chefController.notifier).updateChefProfile(request);

      if (proceed) {
        _resetState();

        $navigate.popUntil(1);
      }
    }
  }

  void _resetState() {
    ref.read(editPickImageProvider.notifier).removeImage("profile");
    ref.read(editPickImageProvider.notifier).removeImage("cover");
    ref.read(editCulinarySpecialtiesProvider.notifier).reset();
    final semanticLabels = ['Menu & Pricing'];
    for (final label in semanticLabels) {
      ref.read(textFieldProvider(label).notifier).updateText('');
    }
  }
}
