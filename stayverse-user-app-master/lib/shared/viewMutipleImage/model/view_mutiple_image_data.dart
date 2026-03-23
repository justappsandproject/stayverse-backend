//[ImageType] can be Unit8List or String or Object

class ViewMutiplePageData<T> {
  final int currentImageIndex;
  final List<T> images;

  ViewMutiplePageData({
    required this.currentImageIndex,
    required this.images,
  });
}
