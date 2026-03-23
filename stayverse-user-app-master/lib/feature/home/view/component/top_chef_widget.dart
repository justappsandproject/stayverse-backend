import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/widget_extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_favourite.dart';
import 'package:stayverse/feature/chefDetails/controller/chef_details_controller.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/feature/chefDetails/view/page/chef_profile_page.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/image_loading_progress.dart';

class TopChefWidget extends ConsumerWidget {
  final Chef? chef;
  final bool showFavourite;

  const TopChefWidget({
    super.key,
    this.chef,
    this.showFavourite = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(1, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.network(
                  chef?.coverPhoto ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 70,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 70,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: LinearImageLoadingProgress(
                        loadingProgress: loadingProgress,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppAsset.shortlet,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180,
                    );
                  },
                )),
          ),
          if (showFavourite)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: FavouriteBtn(
                  isFavourite: ref.watch(chefDetailsController.select(
                    (state) => state.isFavourite ?? chef?.isFavorite ?? false,
                  )),
                  onTap: (action) {
                    ref.read(chefDetailsController.notifier).debounceFavourite(
                          action: action,
                          chefId: chef?.id ?? '',
                        );
                  },
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(20),
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: ClipOval(
                    child: Image.network(
                  chef!.profilePicture!,
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 90,
                      width: 90,
                      color: Colors.grey.shade200,
                      child: LinearImageLoadingProgress(
                        loadingProgress: loadingProgress,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppAsset.chefBackground,
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    );
                  },
                )),
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          chef?.fullName ?? "Unknown Chef",
                          maxLines: 1,
                          style: $styles.text.bodyBold.copyWith(
                            fontSize: 14,
                            height: 1.3,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          chef?.bio ??
                              chef?.about ??
                              "No description available",
                          maxLines: 2,
                          style: $styles.text.bodySmall.copyWith(
                            fontSize: 12,
                            height: 1.3,
                            color: Colors.grey.shade500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          chef?.pricingPerHour != null
                              ? '${MoneyServiceV2.formatNaira(chef!.pricingPerHour?.toDouble() ?? 0, decimalDigits: 0)}/hr'
                              : 'Price N/A',
                          maxLines: 1,
                          style: $styles.text.bodyBold.copyWith(
                            fontSize: 14,
                            height: 1.3,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(3),
                        AppBtn.from(
                          onPressed: () {
                            if (chef != null) {
                              // Pass the chef object to the profile page
                              $navigate.toWithParameters(
                                ChefProfilePage.route,
                                args: chef!,
                              );
                            }
                          },
                          semanticLabel: 'view chef profile',
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          text: 'View Profile',
                          textStyle: $styles.text.bodySmall.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const Gap(20),
            ],
          ).paddingSymmetric(horizontal: 15),
        ],
      ),
    );
  }
}
