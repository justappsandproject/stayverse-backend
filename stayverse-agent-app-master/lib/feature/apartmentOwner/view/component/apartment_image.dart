import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/shared/viewMultipleImage/model/view_multiple_image_data.dart';
import 'package:stayvers_agent/shared/viewMultipleImage/view/view_multiple_image.dart';

class ApartmentImages extends StatelessWidget {
  final PageController pageController;
  final List<String> apartmentImages;

  const ApartmentImages({
    super.key,
    required this.pageController,
    required this.apartmentImages,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: apartmentImages.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  apartmentImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: LinearProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          color: Colors.grey[400],
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                ).onTap(() {
                  $navigate.toWithParameters(ViewMutipleImage.route,
                      args: ViewMutiplePageData(
                        images: apartmentImages,
                        currentImageIndex: index,
                      ));
                }),
              );
            },
          ),
          Positioned(
            bottom: 13,
            child: SmoothPageIndicator(
              controller: pageController,
              count: apartmentImages.length,
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
