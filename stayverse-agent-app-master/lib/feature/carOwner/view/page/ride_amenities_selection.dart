import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/carOwner/controller/ride_advert_controller.dart';

import '../../controller/ride_amenities_controller.dart';

class RideAmenitiesSelection extends ConsumerWidget {
  final ProviderMode mode;
  const RideAmenitiesSelection({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amenitiesProvider = mode == ProviderMode.create
        ? createRideAmenitiesProvider
        : editRideAmenitiesProvider;
    final advertProvider = mode == ProviderMode.create
        ? createRideAdvertProvider
        : editRideAdvertProvider;

    final rideAmenities = ref.watch(amenitiesProvider);
    final selectedAmenities = rideAmenities.where((a) => a.isSelected).toList();
    final rideState = ref.read(advertProvider);
    final selectedCount = selectedAmenities.length;
    final isValid = selectedCount >= 3 && selectedCount <= 7;

    if (rideState.features?.isNotEmpty ?? false) {
      // This is just to check if we need to sync states
      final currentSelectedNames =
          selectedAmenities.map((a) => a.name).toList();
      final shouldSync = !listEquals(currentSelectedNames, rideState.features);

      if (shouldSync) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // For each amenity in the apartment state that isn't selected in the UI, toggle it
          for (final amenityName in rideState.features ?? []) {
            if (!currentSelectedNames.contains(amenityName)) {
              ref
                  .read(amenitiesProvider.notifier)
                  .toggleAmenity(amenityName);
            }
          }
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text('Amenities & Features',
              textAlign: TextAlign.start,
              style: $styles.text.h4.copyWith(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 0,
              )),
        ),
        Gap(10.spaceScale),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: AppColors.greyD6),
          ),
          constraints: const BoxConstraints(minHeight: 100),
          child: selectedAmenities.isEmpty
              ? const Text(
                  'Select 3-7 amenities',
                  style: TextStyle(color: Colors.black38),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedAmenities.map((amenity) {
                    return ActionChip(
                      label: amenity.name.txt12(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryyellow,
                      ),
                      side: const BorderSide(
                        color: AppColors.yellowC9,
                      ),
                      backgroundColor: AppColors.yellowD7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () => ref
                          .read(amenitiesProvider.notifier)
                          .toggleAmenity(amenity.name),
                    );
                  }).toList(),
                ),
        ),
        if (!isValid)
          '**minimum of 3 Amenities required**'.txt10(
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        13.sbH,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: rideAmenities
              .where((amenity) => !amenity.isSelected)
              .map((amenity) {
            final atMaxSelection = selectedAmenities.length >= 7;
            return ActionChip(
              label: amenity.name.txt12(
                fontWeight: FontWeight.w500,
                color: atMaxSelection ? Colors.grey : AppColors.black,
              ),
              side: BorderSide(
                color: atMaxSelection ? Colors.grey.shade300 : AppColors.greyF4,
              ),
              backgroundColor:
                  atMaxSelection ? Colors.grey.shade100 : AppColors.greyF7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: atMaxSelection
                  ? null
                  : () => ref
                      .read(amenitiesProvider.notifier)
                      .toggleAmenity(amenity.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}
