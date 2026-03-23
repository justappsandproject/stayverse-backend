import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/shared/viewMutipleImage/model/view_mutiple_image_data.dart';
import 'package:stayverse/shared/viewMutipleImage/view/view_mutiple_image.dart';

class ImageCarouselSection extends StatelessWidget {
  final List<String> images;
  final PageController pageController;
  final String status;

  const ImageCarouselSection({
    super.key,
    required this.images,
    required this.pageController,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: images[index].startsWith('http')
                      ? Image.network(
                          images[index],
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AppAsset.car,
                              height: 140,
                              fit: BoxFit.cover,
                            );
                          },
                        ).onTap(() {
                          $navigate.toWithParameters(ViewMutipleImage.route,
                              args: ViewMutiplePageData(
                                images: images,
                                currentImageIndex: index,
                              ));
                        })
                      : Image.asset(
                          images[index],
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                );
              },
            ),
            Positioned(
              top: 8,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: context.color.primary,
                ),
                child: Center(
                  child: Text(
                    status.capitalize(),
                    style: $styles.text.title1.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: images.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: context.color.primary,
                    dotColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
