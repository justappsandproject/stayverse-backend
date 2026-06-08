import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_favourite.dart';
import 'package:stayverse/feature/chefDetails/controller/chef_details_controller.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/shared/stayverse_network_image.dart';

class ChefsCard extends ConsumerStatefulWidget {
  final Chef? chef;
  final bool showFavourite;

  const ChefsCard({super.key, this.chef, this.showFavourite = true});

  @override
  ConsumerState<ChefsCard> createState() => _ChefsCardState();
}

class _ChefsCardState extends ConsumerState<ChefsCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 170,
          height: 200,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(1, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: StayverseNetworkImage(
                  url: widget.chef?.coverPhoto,
                  assetFallback: AppAsset.shortlet,
                  height: 70,
                  cacheHeight: 70.cacheSize(context),
                  width: 170,
                  cacheWidth: 170.cacheSize(context),
                  fit: BoxFit.cover,
                ),
              ),
              if (widget.showFavourite)
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
                        (state) =>
                            state.isFavourite ??
                            widget.chef?.isFavorite ??
                            false,
                      )),
                    ),
                  ),
                ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(20),
                    Hero(
                      tag: 'chef-profile-${widget.chef?.id}',
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: StayverseNetworkImage(
                          url: widget.chef?.profilePicture,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      widget.chef?.fullName ?? '',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        widget.chef?.bio ?? 'No bio available',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: $styles.text.bodySmall.copyWith(
                          fontSize: 11.5,
                          height: 1.3,
                          color: Colors.grey.shade700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Gap(20),
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
