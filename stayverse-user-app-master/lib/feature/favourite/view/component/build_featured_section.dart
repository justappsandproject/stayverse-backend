import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/image_loading_progress.dart';

class FeaturedSection extends StatefulWidget {
  final Chef? chef;
  const FeaturedSection({super.key, this.chef});

  @override
  FeaturedSectionState createState() => FeaturedSectionState();
}

class FeaturedSectionState extends State<FeaturedSection> {
  int _currentIndex = 0;

  List<FeaturedImage> get featuredImages {
    if (widget.chef?.features == null || widget.chef!.features!.isEmpty) {
      return [];
    }

    List<FeaturedImage> allImages = [];
    for (var feature in widget.chef!.features!) {
      if (feature.featuredImages != null) {
        allImages.addAll(feature.featuredImages!);
      }
    }
    return allImages;
  }

  @override
  Widget build(BuildContext context) {
    final images = featuredImages;

    if (images.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

    // 🔸 If only one feature → show static like FeaturedSection2
    if (images.length == 1) {
      final featuredImage = images.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFF7F7F7)),
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
                  child: featuredImage.imageUrl != null
                      ? Image.network(
                          featuredImage.imageUrl!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
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
                              color: const Color(0xFFF7F7F7),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 48,
                                  color: Color(0xFF616161),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: 180,
                          color: const Color(0xFFF7F7F7),
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: Color(0xFF616161),
                            ),
                          ),
                        ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    featuredImage.description ?? 'No description available',
                    style: $styles.text.title2.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Gap(10),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
            height: 260.0,
            autoPlay: false,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            pageSnapping: true,
            enlargeFactor: 0.2,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final featuredImage = images[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey.shade200,
                ),
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
                    child: featuredImage.imageUrl != null
                        ? Image.network(
                            featuredImage.imageUrl!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            height: 180,
                            color: const Color(0xFFF7F7F7),
                            child: const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: Color(0xFF616161),
                              ),
                            ),
                          ),
                  ),
                  const Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      featuredImage.description ?? 'No description available',
                      textAlign: TextAlign.center,
                      style: $styles.text.title2.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 13.5,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const Gap(10),
        Center(
          child: SmoothPageIndicator(
            controller: PageController(initialPage: _currentIndex),
            count: images.length,
            effect: const WormEffect(
              activeDotColor: Color(0xFFD1D1D6),
              dotColor: Color(0xFFF4F4F4),
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
        ),
        const Gap(10),
      ],
    );
  }
}
