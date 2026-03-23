import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/widget_extension.dart';
import 'package:stayvers_agent/shared/skeleton.dart';
import 'package:stayvers_agent/shared/viewMultipleImage/model/view_multiple_image_data.dart';

class ViewMutipleImage extends StatefulWidget {
  static const String route = '/ViewMutipleImage';
  ViewMutipleImage({
    super.key,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    required this.data,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: data.currentImageIndex);

  final ViewMutiplePageData data;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  final PageController pageController;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _ViewMutipleImageState();
  }
}

class _ViewMutipleImageState extends State<ViewMutipleImage> {
  late int currentIndex = widget.data.currentImageIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      bodyPadding: EdgeInsets.zero,
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              itemCount: widget.data.images.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!),
                ),
              ),
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
              enableRotation: true,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  filterQuality: FilterQuality.high,
                  imageProvider: _getImageType(index),
                  initialScale: PhotoViewComputedScale.contained,
                  minScale:
                      PhotoViewComputedScale.contained * (0.5 + index / 10),
                  maxScale: PhotoViewComputedScale.covered * 4.1,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.cancel),
              color: Colors.white,
              onPressed: () {
                $navigate.back();
              },
            ).paddingOnly(top: 0.05.sh, left: 0.02.sw),
          ),
        ],
      ),
      isBusy: false,
    );
  }

  ImageProvider<Object>? _getImageType(int index) {
    final image = widget.data.images[index];

    if (image is String) {
      return NetworkImage(widget.data.images[index]);
    }
    if (image is Uint8List) {
      return MemoryImage(widget.data.images[index]);
    }
    return null;
  }
}
