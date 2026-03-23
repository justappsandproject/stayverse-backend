import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service.dart';
import 'package:stayverse/feature/search/controller/search_controller.dart';
import 'package:stayverse/feature/search/model/data/apartment_search_filter.dart';
import 'package:stayverse/shared/app_back_button.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/calender/single_calender.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/skeleton.dart';

class ApartmentFilterPage extends ConsumerWidget {
  static const route = '/ApartmentFilterPage';

  const ApartmentFilterPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchController);
    final controller = ref.read(searchController.notifier);

    final filter = searchState.apartmentFilter;

    return BrimSkeleton(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: const AppBackButton(
          icon: CupertinoIcons.clear,
        ),
        centerTitle: true,
        actions: [
          AppBtn.basic(
            onPressed: () {
              controller.resetApartmentFilter();
            },
            semanticLabel: 'Reset',
            child: Text(
              'Reset',
              style: $styles.text.title1.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const Gap(16)
        ],
        title: Text(
          'Filter',
          style: $styles.text.title1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRICE RANGE SECTION
              _buildPriceRangeSection(context, filter, controller),

              const Gap(24),

              // BEDROOMS SECTION
              _buildBedroomsSection(context, filter, controller),

              const Gap(24),

              // AMENITIES SECTION
              _buildAmenitiesSection(context, filter, controller),

              const Gap(20),

              // CALENDAR SECTION
              _buildCalendarSection(context, filter, controller),

              const Gap(15),

              // APPLY BUTTON
              AppBtn.from(
                text: 'Apply Filter',
                expand: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              const Gap(20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection(BuildContext context,
      ApartmentSearchFilter filter, SearchFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range (N/per night)',
          style: $styles.text.title1.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Gap(16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorColor: context.color.primary,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
          child: RangeSlider(
            values: RangeValues(
              filter.minPrice?.toDouble() ?? 0,
              filter.maxPrice?.toDouble() ?? 0,
            ),
            min: 0,
            max: 900000,
            divisions: 100,
            activeColor: context.color.primary,
            inactiveColor: Colors.grey[300],
            labels: RangeLabels(
              'N${MoneyService.formatMoney(filter.minPrice?.round().toDouble() ?? 0)}',
              'N${MoneyService.formatMoney(filter.maxPrice?.round().toDouble() ?? 0)}',
            ),
            onChanged: (RangeValues values) {
              controller.updateApartmentFilter(
                minPrice: values.start,
                maxPrice: values.end,
              );
            },
            overlayColor: WidgetStateProperty.all(context.color.primary),
          ),
        ),
        const Gap(16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Min. Price',
                    style: $styles.text.title1.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      style: const TextStyle(color: Color(0xFFFFB800)),
                      controller: TextEditingController(
                        text: 'N${filter.minPrice?.toInt() ?? 0}',
                      ),
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFFFF8E7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'N100',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: SizedBox(
                width: 16.w,
                child: const HorizontalLine(),
              ),
            ),
            const Gap(5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Max. Price',
                    style: $styles.text.title1.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: TextEditingController(
                        text: 'N${filter.maxPrice?.toInt() ?? 0}',
                      ),
                      enabled: false,
                      style: const TextStyle(
                        color: Color(0xFFFFB800),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFFFF8E7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'N400,000',
                        hintStyle: const TextStyle(color: Color(0xFFFFB800)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBedroomsSection(BuildContext context,
      ApartmentSearchFilter filter, SearchFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bedrooms',
          style: $styles.text.title1.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Gap(16),
        Row(
          children: List.generate(6, (index) {
            final bedCount = index + 1;
            final label = bedCount == 6 ? '6+' : bedCount.toString();
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: filter.numberOfBedrooms == bedCount
                        ? const Color(0xFFFFF8E7)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AppBtn.basic(
                    onPressed: () {
                      controller.updateApartmentFilter(
                        numberOfBedrooms: bedCount,
                      );
                    },
                    semanticLabel: 'Bedrooms:',
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: TextStyle(
                          color: filter.numberOfBedrooms == bedCount
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection(BuildContext context,
      ApartmentSearchFilter filter, SearchFilterController controller) {
    final amenities = [
      'Garage',
      'Security',
      'Gym',
      'Air Conditioning',
      'Parking',
      'Pool',
      'Balcony',
      'Snooker Board',
      'Ps5',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Amenities',
              style: $styles.text.title1.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View all',
                style: $styles.text.title1.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.color.primary,
                ),
              ),
            ),
          ],
        ),
        const Gap(10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amenities.map((amenity) {
            final isSelected = filter.amenities?.contains(amenity) ?? false;
            return Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFF8E7) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFFB800)
                      : Colors.grey.shade100,
                  width: 1,
                ),
              ),
              child: AppBtn.basic(
                onPressed: () {
                  List<String> updatedAmenities =
                      List.from(filter.amenities ?? []);

                  if (isSelected) {
                    updatedAmenities.remove(amenity);
                  } else {
                    updatedAmenities.add(amenity);
                  }

                  controller.updateApartmentFilter(
                    amenities: updatedAmenities,
                  );
                },
                semanticLabel: '',
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Text(
                    amenity,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFFFB800)
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCalendarSection(BuildContext context,
      ApartmentSearchFilter filter, SearchFilterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'When?',
          style: $styles.text.title1.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Gap(5),
        Text(
          'Select move-in date',
          style: $styles.text.title1.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const Gap(10),
        SingleCalendar(
          onDateSelected: (date) {
            controller.updateApartmentFilter(
              moveInDate: date,
            );
          },
          selectedDate: filter.moveInDate,
          height: 340,
          showOutsideDays: true,
          selectedColor: context.color.primary,
        ),
      ],
    );
  }
}
