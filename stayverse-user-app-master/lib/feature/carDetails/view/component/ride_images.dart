import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/media/media_url.dart';
import 'package:stayverse/shared/stayverse_network_image.dart';
import 'package:stayverse/shared/viewMutipleImage/model/view_mutiple_image_data.dart';
import 'package:stayverse/shared/viewMutipleImage/view/view_mutiple_image.dart';

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

    return PageView.builder(
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
    );
  }
}
