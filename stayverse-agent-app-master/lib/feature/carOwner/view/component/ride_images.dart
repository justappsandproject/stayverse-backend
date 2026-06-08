import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/util/media/media_url.dart';
import 'package:stayvers_agent/shared/stayverse_network_image.dart';
import 'package:stayvers_agent/shared/viewMultipleImage/model/view_multiple_image_data.dart';
import 'package:stayvers_agent/shared/viewMultipleImage/view/view_multiple_image.dart';

class RideImages extends StatelessWidget {
  final PageController pageController;
  final List<String> rideImages;

  const RideImages({
    super.key,
    required this.pageController,
    required this.rideImages,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedImages = rideImages
        .map((url) => MediaUrl.resolve(url) ?? url)
        .where((url) => url.isNotEmpty)
        .toList();

    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: resolvedImages.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: StayverseNetworkImage(
                  url: resolvedImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ).onTap(() {
                  $navigate.toWithParameters(
                    ViewMutipleImage.route,
                    args: ViewMutiplePageData(
                      images: resolvedImages,
                      currentImageIndex: index,
                    ),
                  );
                }),
              );
            },
          ),
          Positioned(
            bottom: 13,
            child: SmoothPageIndicator(
              controller: pageController,
              count: resolvedImages.length,
              effect: WormEffect(
                dotHeight: 6,
                dotWidth: 6,
                activeDotColor: Colors.white,
                dotColor: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
