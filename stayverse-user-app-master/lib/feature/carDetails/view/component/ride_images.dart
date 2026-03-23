import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
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
    return PageView.builder(
      controller: pageController,
      itemCount: rideImages.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            rideImages[index],
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.directions_car,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ).onTap(() {
            $navigate.toWithParameters(ViewMutipleImage.route,
                args: ViewMutiplePageData(
                  images: rideImages,
                  currentImageIndex: index,
                ));
          }),
        );
      },
    );
  }
}
