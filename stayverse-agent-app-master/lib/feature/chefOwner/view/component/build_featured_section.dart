import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_response.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/delete_dialog.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/empty_state_view.dart';
import 'package:stayvers_agent/shared/image_loading_progress.dart';
import 'package:stayvers_agent/shared/line.dart';

import 'featured_form.dart';

class FeaturedSection extends ConsumerStatefulWidget {
  final ChefProfileData? chefProfileData;

  const FeaturedSection({
    super.key,
    this.chefProfileData,
  });

  @override
  ConsumerState<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends ConsumerState<FeaturedSection> {
  int _currentIndex = 0;
  int? _longPressedIndex;

  Timer? _overlayTimer;

  void _startOverlayTimer() {
    _overlayTimer?.cancel();
    _overlayTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _longPressedIndex = null);
      }
    });
  }

  @override
  void dispose() {
    _overlayTimer?.cancel();
    super.dispose();
  }

  // Helper method to get all featured images with descriptions
  List<FeaturedImage> get featuredImages {
    if (widget.chefProfileData?.features == null ||
        widget.chefProfileData!.features!.isEmpty) {
      return [];
    }

    // Flatten all featured images from all features
    List<FeaturedImage> allImages = [];
    for (var feature in widget.chefProfileData!.features!) {
      if (feature.featuredImages != null) {
        allImages.addAll(feature.featuredImages!);
      }
    }
    return allImages;
  }

  @override
  Widget build(BuildContext context) {
    final images = featuredImages;

    // If no featured images, show empty state or hide section
    if (images.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'Featured'.txt14(
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              AppBtn(
                onPressed: () => $navigate.to(FeaturedForm.route),
                semanticLabel: '',
                padding: EdgeInsets.zero,
                bgColor: Colors.transparent,
                child: const Icon(
                  Icons.add,
                  color: AppColors.black,
                  size: 30,
                ),
              ),
            ],
          ),
          const Gap(16),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlexibleEmptyStateView(
                  message: 'No Featured Dish Added',
                  subtitle: 'No Featured Dish Added at the moment.',
                  lottieAsset: AppAsset.chefEmpty,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            'Featured'.txt14(
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            AppBtn(
              onPressed: () => $navigate.to(FeaturedForm.route),
              semanticLabel: '',
              padding: EdgeInsets.zero,
              bgColor: Colors.transparent,
              child: const Icon(
                Icons.add,
                color: AppColors.black,
                size: 30,
              ),
            ),
          ],
        ),
        const Gap(24),
        CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
            height: 251.0,
            autoPlay: false,
            viewportFraction: 0.99,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: false,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final featuredImage = images[index];

            return GestureDetector(
              onLongPress: () {
                setState(() => _longPressedIndex = index);
                _startOverlayTimer();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyF7),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          featuredImage.imageUrl != null
                              ? Image.network(
                                  featuredImage.imageUrl!,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 180,
                                      width: double.infinity,
                                      color: Colors.grey.shade200,
                                      child: LinearImageLoadingProgress(
                                        loadingProgress: loadingProgress,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 180,
                                      color: AppColors.greyF7,
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          size: 48,
                                          color: AppColors.grey61,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 180,
                                  color: AppColors.greyF7,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 48,
                                      color: AppColors.grey61,
                                    ),
                                  ),
                                ),

                          // 🔥 OVERLAY WITH DELETE ICON
                          AnimatedOpacity(
                            opacity: _longPressedIndex == index ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 250),
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                color: Colors.black.withOpacity(0.55),
                              ),
                              child: Center(
                                child: AppBtn(
                                  onPressed: () {
                                    _deleteFeatured();
                                  },
                                  semanticLabel: '',
                                  padding: EdgeInsets.zero,
                                  bgColor: Colors.transparent,
                                  child: const AppIcon(
                                    AppIcons.delete,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                )
                                    .animate(
                                        target:
                                            _longPressedIndex == index ? 1 : 0)
                                    .scale(
                                        begin: const Offset(1, 1),
                                        end: const Offset(1.2, 1.2))
                                    .then()
                                    .shake(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: (featuredImage.description ??
                                'No description available')
                            .txt10(
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey61,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (images.length > 1) ...[
          12.sbH,
          Center(
            child: SmoothPageIndicator(
              controller: PageController(initialPage: _currentIndex),
              count: images.length,
              effect: const WormEffect(
                activeDotColor: AppColors.greyD6,
                dotColor: AppColors.greyF4,
                dotHeight: 6,
                dotWidth: 6,
              ),
            ),
          ),
        ],
        19.sbH,
        const HorizontalLine(color: AppColors.greyF7),
      ],
    );
  }

  void _deleteFeatured() {
    showDialog(
      context: context,
      builder: (_) => DeleteDialog(
          title: 'Featured',
          onConfirm: () {
            final chefId = widget.chefProfileData?.features?.first.id;
            ref.read(chefController.notifier).deleteFeatured(chefId ?? '');
            $navigate.back();
          }),
    );
  }
}
