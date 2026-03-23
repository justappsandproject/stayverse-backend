import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';

class ImageService {
  static Future<Map<String, Uint8List?>> getByteUsingConcurrency(
      List<String> imageUrls) async {
    final Map<String, Future<Uint8List?>> futures = {
      for (String url in imageUrls) url: _fileFromNetwork(url)
    };

    final List<MapEntry<String, Uint8List?>> results = await Future.wait(
      futures.entries.map((entry) async {
        final bytes = await entry.value;
        return MapEntry(entry.key, bytes);
      }),
    );

    final Map<String, Uint8List?> photos = {
      for (var result in results) result.key: result.value
    };

    return photos;
  }

  static Future<Uint8List?> _fileFromNetwork(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) return null;

      return response.bodyBytes;
    } catch (_) {
      return null;
    }
  }

  ///Pick image from gallery and return the path
  static Future<String?> selectSingleImage() async {
    try {
      final XFile? image = await locator
          .get<ImagePicker>()
          .pickImage(source: ImageSource.gallery);

      return image?.path;
    } on PlatformException catch (e) {
      BrimToast.showError(e.toString());
      return null;
    }
  }

  static Future<List<MultipartFile>> convertMutipleImagetoMultipart(
      String filePath,
      {String? fileName}) async {
    final multipartFiles = <MultipartFile>[];

    String fileExtension = filePath.split('.').last.toLowerCase();

    const mimeTypes = {
      'jpg': 'jpeg',
      'jpeg': 'jpeg',
      'png': 'png',
      'webp': 'webp',
    };

    final mimeSubType = mimeTypes[fileExtension] ?? 'jpeg';

    final multipartFile = await MultipartFile.fromFile(
      filePath,
      contentType: DioMediaType('image', mimeSubType),
      filename:
          '${fileName ?? 'photo'}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
    );

    multipartFiles.add(multipartFile);
    return multipartFiles;
  }

  static Future<MultipartFile> convertImagetoMultipart(String filePath,
      {String? fileName}) async {
    String fileExtension = filePath.split('.').last.toLowerCase();

    const mimeTypes = {
      'jpg': 'jpeg',
      'jpeg': 'jpeg',
      'png': 'png',
      'webp': 'webp',
    };

    final mimeSubType = mimeTypes[fileExtension] ?? 'jpeg';

    final multipartFile = await MultipartFile.fromFile(
      filePath,
      contentType: DioMediaType('image', mimeSubType),
      filename:
          '${fileName ?? 'photo'}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
    );

    return multipartFile;
  }
}
