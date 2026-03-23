import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/apartmentDetails/view/component/apartment_favourite.dart';
import 'package:stayverse/feature/chefDetails/controller/chef_details_controller.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/shared/image_loading_progress.dart';

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
                child: Image.network(
                  widget.chef?.coverPhoto ?? '',
                  height: 70,
                  cacheHeight: 70.cacheSize(context),
                  width: 170,
                  cacheWidth: 170.cacheSize(context),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 70,
                      width: double.infinity,
                      color: const Color.fromARGB(255, 61, 31, 31),
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
                        child: Image.network(
                          widget.chef?.profilePicture ?? '',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 100,
                              width: 100,
                              padding: const EdgeInsets.all(10),
                              color: Colors.grey.shade200,
                              child: LinearImageLoadingProgress(
                                loadingProgress: loadingProgress,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 90,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.image_not_supported,
                                    color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      widget.chef?.fullName ?? "",
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
