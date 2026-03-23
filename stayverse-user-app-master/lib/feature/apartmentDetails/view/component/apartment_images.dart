import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/shared/image_loading_progress.dart';
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
    return PageView.builder(
      controller: _pageController,
      itemCount: apartmentImages.length,
      itemBuilder: (context, index) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              apartmentImages[index],
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: LinearImageLoadingProgress(
                      loadingProgress: loadingProgress,
                    ));
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AppAsset.apartment,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ).onTap(() {
              $navigate.toWithParameters(ViewMutipleImage.route,
                  args: ViewMutiplePageData(
                    images: apartmentImages,
                    currentImageIndex: index,
                  ));
            }));
      },
    );
  }
}
