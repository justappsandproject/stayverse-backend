// property_card.dart
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/shared/image_loading_progress.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment? apartment;
  final bool showFavourite;

  const ApartmentCard({
    super.key,
    this.apartment,
    this.showFavourite = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 180,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.09),
                blurRadius: 6,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Image.network(
                        apartment?.apartmentImages?.firstOrNull ??
                            Constant.defaultApartmentImage,
                        height: 140,
                        width: 180,
                        cacheHeight: 140.cacheSize(context),
                        cacheWidth: 180.cacheSize(context),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 140,
                            padding: const EdgeInsets.all(10),
                            color: Colors.grey.shade200,
                            child: LinearImageLoadingProgress(
                              loadingProgress: loadingProgress,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 140,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            ),
                          );
                        },
                      )),
                  if (showFavourite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          (apartment?.isFavourite ?? false)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: apartment?.isFavourite ?? false
                              ? Colors.red
                              : Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      apartment?.apartmentName ?? 'Unnamed Apartment',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const Gap(2),
                        Expanded(
                          child: Text(
                            apartment?.address ?? 'Location not available',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: MoneyServiceV2.formatNaira(
                              apartment?.pricePerDay ?? 0,
                              decimalDigits: 0,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '/day',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
