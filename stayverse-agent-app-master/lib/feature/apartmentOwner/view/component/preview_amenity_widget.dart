// ignore_for_file: collection_methods_unrelated_type

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';

import '../../controller/preview_amenities_controller.dart';
import '../ui_state/preview_amenity_ui_state.dart';

final showAllAmenitiesProvider = StateProvider<bool>((ref) => false);

class AmenitiesWidget extends ConsumerWidget {
  final List<String>? amenityNames;
  final List<AmenityFeature>? availableFeatures;

  const AmenitiesWidget({
    super.key,
    this.amenityNames,
    this.availableFeatures,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAll = ref.watch(showAllAmenitiesProvider);
    final showAllNotifier = ref.read(showAllAmenitiesProvider.notifier);

    // Source of truth for known features (either from prop or provider fallback)
    final knownAmenities = availableFeatures ?? ref.read(amenityProvider);

    // Map names to AmenityFeature
    final selectedAmenities = amenityNames?.map((name) {
      return knownAmenities?.firstWhere(
        (a) => a.name == name,
        orElse: () => AmenityFeature(
          name: name,
          iconName: _getDefaultIconForAmenity(name),
        ),
      );
    }).toList();

    final displayedAmenities = showAll
        ? selectedAmenities ?? []
        : (selectedAmenities != null ? selectedAmenities.take(6).toList() : []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        'Apartment Features'.txt16(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        12.sbH,
        if (selectedAmenities == null || selectedAmenities.isEmpty)
          "No amenities selected".txt14(
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          )
        else
          ...displayedAmenities
              .map<Widget>((amenity) => _buildAmenityItem(amenity)),
        7.sbH,
        if ((selectedAmenities?.length ?? 0) > 6)
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

  Widget _buildAmenityItem(AmenityFeature? amenity) {
    if (amenity == null) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyF7,
              border: Border.all(color: AppColors.greyF4),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: AppIcon(
              amenity.iconName!,
              size: 16,
            ),
          ),
          6.sbW,
          amenity.name.txt14(
            fontWeight: FontWeight.w400,
            color: AppColors.grey8D,
          ),
        ],
      ),
    );
  }

  AppIcons _getDefaultIconForAmenity(String name) {
    final iconMap = {
      'Air Conditioning': AppIcons.air_conditioner,
      'Parking': AppIcons.parking,
      'Wifi': AppIcons.wifi,
      'Washer': AppIcons.washer,
      'Mountain View': AppIcons.mountain,
      'Pets Allowed': AppIcons.pets_allowed,
      'Pool': AppIcons.pool,
      'Gym': AppIcons.gym,
      'Balcony': AppIcons.balcony,
      'Garage': AppIcons.garage,
      'Security': AppIcons.security,
      'Snooker Board': AppIcons.snooker,
    };

    return iconMap.entries
        .firstWhere(
          (entry) => name.toLowerCase().contains(entry.key.toLowerCase()),
          orElse: () => const MapEntry('', AppIcons.mountain_view),
        )
        .value;
  }
}
