import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/core/util/media/media_url.dart';
import 'package:stayverse/shared/stayverse_network_image.dart';
import 'package:stayverse/shared/viewMutipleImage/model/view_mutiple_image_data.dart';
import 'package:stayverse/shared/viewMutipleImage/view/view_mutiple_image.dart';

class ApartmentImages extends StatelessWidget {
  const ApartmentImages({
    super.key,
    required PageController pageController,
    required this.apartmentImages,
  }) : _pageController = pageController;

  final PageController _pageController;
  final List<String> apartmentImages;

  @override
  Widget build(BuildContext context) {
    final resolvedImages = apartmentImages
        .map((url) => MediaUrl.resolve(url) ?? url)
        .where((url) => url.isNotEmpty)
        .toList();

    return PageView.builder(
      controller: _pageController,
      itemCount: resolvedImages.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: StayverseNetworkImage(
            url: resolvedImages[index],
            assetFallback: AppAsset.apartment,
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
    );
  }
}
