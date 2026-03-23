import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/constant.dart';
import 'package:stayverse/feature/apartmentDetails/view/page/apartment_details_page.dart';
import 'package:stayverse/feature/carDetails/view/page/car_detail_page.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/home/model/data/ride_response.dart';
import 'package:stayverse/feature/chefDetails/view/page/chef_profile_page.dart';
import 'package:stayverse/feature/search/model/data/map_data.dart';
import 'package:stayverse/feature/search/view/component/search_result_dialog.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/image_loading_progress.dart';

class MapItemCard extends ConsumerWidget {
  final MapData? data;

  const MapItemCard({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBtn.basic(
      onPressed: () {
        _navigateToDetail();
      },
      semanticLabel: 'Search result',
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.network(
                      data?.imageUrl ?? Constant.defaultApartmentImage,
                      height: 100,
                      width: 130,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 100,
                          width: 130,
                          padding: const EdgeInsets.all(10),
                          color: Colors.grey.shade200,
                          child: LinearImageLoadingProgress(
                            loadingProgress: loadingProgress,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: 130,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                        );
                      },
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data?.title ?? 'unamed',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                data?.location ?? '--',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: data?.price,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '/${data?.period}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail() {
    final result = data?.searchResult;

    if (result is Apartment) {
      SearchResultDialog.closeSearchResult();
      $navigate.toWithParameters(ApartmentDetailsPage.route, args: result);
      return;
    }

    if (result is Ride) {
      SearchResultDialog.closeSearchResult();
      $navigate.toWithParameters(CarDetailPage.route, args: result);
      return;
    }

    if (result is Chef) {
      SearchResultDialog.closeSearchResult();
      $navigate.toWithParameters(ChefProfilePage.route, args: result);
      return;
    }
  }
}
