class ImageFile {
  final String path;
  final int size;
  final String name;
  final bool isRemote;

  ImageFile({required this.path, required this.size, required this.name, this.isRemote = false,});
}