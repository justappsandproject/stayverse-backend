import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/apartmentOwner/view/ui_state/preview_amenity_ui_state.dart';
import 'package:stayvers_agent/shared/buttons.dart';

final showAllAmenitiesProvider = StateProvider<bool>((ref) => false);

class RideAmenitiesWidget extends ConsumerWidget {
  final List<String>? selectedFeatureNames;
  final List<AmenityFeature>? allAvailableAmenities;

  const RideAmenitiesWidget({
    super.key,
    this.selectedFeatureNames,
    this.allAvailableAmenities,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAll = ref.watch(showAllAmenitiesProvider);
    final showAllNotifier = ref.read(showAllAmenitiesProvider.notifier);

    final selectedRideAmenities = _getSelectedRideAmenities(
      selectedFeatureNames ?? [],
      allAvailableAmenities ?? [],
    );

    final displayedAmenities = showAll
        ? selectedRideAmenities
        : selectedRideAmenities.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Ride Features".txt16(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        12.sbH,
        if (selectedRideAmenities.isEmpty)
          "No Features selected".txt14(
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          )
        else
          ...displayedAmenities.map(_buildAmenityItem),
        7.sbH,
        if (selectedRideAmenities.length > 6)
          AppBtn.from(
            text: showAll ? "Show less amenities" : 'Show all amenities',
            expand: true,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            bgColor: AppColors.greyF7,
            borderRadius: 8,
            padding: const EdgeInsets.symmetric(vertical: 18),
            border: const BorderSide(color: AppColors.greyF4),
            onPressed: () => showAllNotifier.state = !showAll,
          ),
      ],
    );
  }

  List<AmenityFeature> _getSelectedRideAmenities(
    List<String> featureNames,
    List<AmenityFeature> allAmenities,
  ) {
    final amenityMap = {
      for (var amenity in allAmenities) amenity.name: amenity,
    };

    return featureNames.map((name) {
      return amenityMap[name] ?? AmenityFeature(name: name);
    }).toList();
  }

  Widget _buildAmenityItem(AmenityFeature amenity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          amenity.name.txt14(
            fontWeight: FontWeight.w500,
            color: AppColors.grey8D,
          ),
        ],
      ),
    );
  }
}
