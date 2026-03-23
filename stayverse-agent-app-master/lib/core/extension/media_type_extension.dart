// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

MediaType getContentTypeFromExtension(String extension) {
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return MediaType('image', 'jpeg');
    case 'png':
      return MediaType('image', 'png');
    case 'webp':
      return MediaType('image', 'webp');
    case 'gif':
      return MediaType('image', 'gif');
    default:
      return MediaType('image', 'png');
  }
}
