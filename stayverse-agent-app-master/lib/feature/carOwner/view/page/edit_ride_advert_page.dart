import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/dropdown_data.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/core/util/dropdown/app_dropdown.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_advert_controller.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_amenities_controller.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/ride_response.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/ride_image_picker.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/component/custom_textfield.dart';
import 'package:stayvers_agent/feature/carOwner/view/component/ride_location_search.dart';
import 'package:stayvers_agent/feature/carOwner/view/page/edit_ride_details_form_page.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../controller/ride_image_picker_controller.dart';
import 'ride_amenities_selection.dart';

class EditRideAdvertPage extends ConsumerStatefulWidget {
  static const route = '/EditRideAdvertPage';
  final Ride? ride;

  const EditRideAdvertPage({super.key, this.ride});

  @override
  ConsumerState<EditRideAdvertPage> createState() => _EditRideAdvertPageState();
}

class _EditRideAdvertPageState extends ConsumerState<EditRideAdvertPage> {
  @override
  void initState() {
    super.initState();
    if (widget.ride != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(editRideAdvertProvider.notifier)
            .loadRideData(widget.ride!, ref);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editVehicleType);
    final notifier = ref.watch(editRideAdvertProvider.notifier);
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
              title: 'Car Name',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              controller: notifier.rideNameController,
            ),
            27.sbH,
            AppTextField(
              title: 'Ride Details',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              minLines: 3,
              borderRadius: BorderRadius.circular(17),
              controller: notifier.rideDetailsController,
            ),
            27.sbH,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: $styles.text.h4.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                10.sbH,
                const RideLocationSearch(mode: ProviderMode.edit),
              ],
            ),
            27.sbH,
            AppDropdown(
              title: 'Vehicle Type',
              value: state.selectedType,
              items: DropdownLists.vehicleTypes,
              onChanged: (selectedType) {
                ref.read(editVehicleType.notifier).selectType(selectedType!);
                ref
                    .read(editRideAdvertProvider.notifier)
                    .updateRideType(selectedType);
              },
            ),
            27.sbH,
            const RideImagePickerWidget(mode: ProviderMode.edit),
            27.sbH,
            const RideAmenitiesSelection(mode: ProviderMode.edit),
            27.sbH,
            Align(
              alignment: Alignment.topLeft,
              child: Text('Pricing (N/per hour)',
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
                controller: notifier.ridepriceController,
              ),
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
              title: 'Rules',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              minLines: 3,
              textInputType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              borderRadius: BorderRadius.circular(17),
              controller: notifier.rideRulesController,
            ),
            27.sbH,
            SizedBox(
              width: 180,
              child: CustomTextField(
                semanticLabel: 'No. Passenger',
                title: 'No. of Passenger (optional)',
                keyboardType: TextInputType.number,
                controller: notifier.numOfPassController,
              ),
            ),
            37.sbH,
            AppBtn.from(
              text: 'Continue',
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
        .read(editRideAmenitiesProvider)
        .where((amenity) => amenity.isSelected)
        .toList();
    final selectedImages = ref.read(editRideImagePickerProvider);
    final isAmenitiesValid = selectedAmenities.length >= 3;
    final isImagesValid = selectedImages.length >= 2;

    if (isAmenitiesValid && isImagesValid) {
      final notifier = ref.read(editRideAdvertProvider.notifier);
      notifier.updateStateFromControllers();
      $navigate.toWithParameters(
        EditRideDetailsFormPage.route,
        args: widget.ride?.id ?? '',
      );
    } else {
      BrimToast.showHint(
          'Please select at least 3 amenities or upload 2 images.');
    }
  }
}
