import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/dropdown_data.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/core/util/dropdown/app_dropdown.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_response.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/custom_textfield.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/page/edited_apartment_preview_page.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../controller/amenity_selection_controller.dart';
import '../../controller/apartment_advert_notifier.dart';
import '../../controller/image_picker_controller.dart';
import '../component/advert_apartment_location_field.dart';
import '../component/image_picker_widget.dart';
import '../component/time_picker_widget.dart';
import 'amenitites_selection_page.dart';

class EditApartmentAdvertPage extends ConsumerStatefulWidget {
  static const route = '/EditApartmentAdvertPage';
  final Apartment? apartment;
  const EditApartmentAdvertPage({super.key, this.apartment});

  @override
  ConsumerState<EditApartmentAdvertPage> createState() =>
      _EditApartmentAdvertPageState();
}

class _EditApartmentAdvertPageState
    extends ConsumerState<EditApartmentAdvertPage> {
  @override
  void initState() {
    super.initState();
    if (widget.apartment != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(editApartmentAdvert.notifier)
            .loadApartmentData(widget.apartment!, ref);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final apartmentTypeState = ref.watch(editApartmentType);
    final notifier = ref.read(editApartmentAdvert.notifier);
    return BrimSkeleton(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
      ),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 18),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Edit Advert'.txt(
              size: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
            'You can edit your advert details below'.txt14(
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
            23.sbH,
            AppTextField(
              title: 'Apartment Name',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              controller: notifier.apartmentNameController,
            ),
            27.sbH,
            AppTextField(
              title: 'Apartment Description',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              minLines: 3,
              borderRadius: BorderRadius.circular(17),
              controller: notifier.detailsController,
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
                const ApartmentAdvertLocationSearch(
                  mode: ProviderMode.edit,
                ),
              ],
            ),
            27.sbH,
            AppDropdown(
              title: 'Apartment Type',
              value: apartmentTypeState.selectedType,
              items: DropdownLists.apartmentTypes,
              onChanged: (selectedType) {
                if (selectedType != null) {
                  ref.read(editApartmentType.notifier).selectType(selectedType);
                  ref
                      .read(editApartmentAdvert.notifier)
                      .updateApartmentType(selectedType);
                }
              },
            ),
            27.sbH,
            SizedBox(
              width: 160,
              child: CustomTextField(
                semanticLabel: 'No. Bathrooms',
                title: 'No. of bathrooms',
                keyboardType: TextInputType.number,
                controller: notifier.numberOfBathroomsController,
              ),
            ),
            27.sbH,
            const ImagePickerWidget(
              mode: ProviderMode.edit,
            ),
            27.sbH,
            const AmenitiesSelection(
              mode: ProviderMode.edit,
            ),
            27.sbH,
            Align(
              alignment: Alignment.topLeft,
              child: Text('Pricing (N/per night)',
                  textAlign: TextAlign.start,
                  style: $styles.text.h4.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  )),
            ),
            Gap(10.spaceScale),
            SizedBox(
              width: 160,
              child: CustomTextField(
                  semanticLabel: 'Min. Price',
                  title: 'Min. Price',
                  titleColor: AppColors.grey8D,
                  inputFormatters: [MoneyFormatter()],
                  keyboardType: TextInputType.number,
                  controller: notifier.priceController),
            ),
            27.sbH,
              Align(
              alignment: Alignment.topLeft,
              child: Text('Cautioning Fee (optional)',
                  textAlign: TextAlign.start,
                  style: $styles.text.h4.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  )),
            ),
            Gap(10.spaceScale),
            SizedBox(
              width: 160,
              child: CustomTextField(
                semanticLabel: 'Caution Fee',
                title: 'Caution Fee',
                titleColor: AppColors.grey8D,
                inputFormatters: [MoneyFormatter()],
                keyboardType: TextInputType.number,
                controller: notifier.cautionFeeController,
              ),
            ),
            27.sbH,
            AppTextField(
              title: 'House Rules',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              minLines: 3,
              textInputType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              borderRadius: BorderRadius.circular(17),
              controller: notifier.houseRulesController,
            ),
            27.sbH,
            SizedBox(
              width: 160,
              child: CustomTextField(
                semanticLabel: 'No. Guest',
                title: 'No. of Guest (optional)',
                keyboardType: TextInputType.number,
                controller: notifier.maxGuestsController,
              ),
            ),
            27.sbH,
            const TimePickerWidget(
              mode: ProviderMode.edit,
            ),
            37.sbH,
            AppBtn.from(
              text: 'Preview',
              expand: true,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
              bgColor: AppColors.black,
              onPressed: () {
                _submit(ref);
              },
            ),
            17.sbH,
          ],
        ),
      ),
    );
  }

  void _submit(WidgetRef ref) {
    final selectedAmenities = ref
        .read(editApartmentAmenities)
        .where((amenity) => amenity.isSelected)
        .toList();
    final selectedImages = ref.read(editApartmentImagePicker);
    final isAmenitiesValid = selectedAmenities.length >= 3;
    final isImagesValid = selectedImages.length >= 2;

    if (isAmenitiesValid && isImagesValid) {
      final notifier = ref.read(editApartmentAdvert.notifier);
      notifier.updateStateFromControllers();
      $navigate.toWithParameters(
        EditedApartmentPreviewPage.route,
        args: widget.apartment?.id ?? '',
      );
    } else {
      BrimToast.showHint(
          'Please select at least 3 amenities or upload 2 images.');
    }
  }
}
