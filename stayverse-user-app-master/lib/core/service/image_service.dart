import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/service/toast_service.dart';

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

  /// Pick image from gallery and return the path
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

  static Future<void> downloadImageToGallery(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        BrimToast.showError('Failed to download image');
        return;
      }
      final result = await ImageGallerySaver.saveImage(response.bodyBytes);

      if (result['isSuccess']) {
        BrimToast.showSuccess('Image saved to gallery');
      } else {
        BrimToast.showError('Failed to save image to gallery');
      }
    } catch (e) {
      BrimToast.showError('Download failed: $e');
    }
  }
  static Future<List<MultipartFile>> convertMutipleImagetoMultipart(
      String filePath,
      {String? fileName}) async {
    final multipartFiles = <MultipartFile>[];

    final preparedFilePath = await _prepareImageForUpload(filePath);
    final fileExtension = preparedFilePath.split('.').last.toLowerCase();

    const mimeTypes = {
      'jpg': 'jpeg',
      'jpeg': 'jpeg',
      'png': 'png',
      'webp': 'webp',
      'heic': 'jpeg',
      'heif': 'jpeg',
    };

    final mimeSubType = mimeTypes[fileExtension] ?? 'jpeg';

    final multipartFile = await MultipartFile.fromFile(
      preparedFilePath,
      contentType: DioMediaType('image', mimeSubType),
      filename:
          '${fileName ?? 'photo'}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
    );

    multipartFiles.add(multipartFile);
    return multipartFiles;
  }

  static Future<MultipartFile> convertImagetoMultipart(String filePath,
      {String? fileName}) async {
    final preparedFilePath = await _prepareImageForUpload(filePath);
    final fileExtension = preparedFilePath.split('.').last.toLowerCase();

    const mimeTypes = {
      'jpg': 'jpeg',
      'jpeg': 'jpeg',
      'png': 'png',
      'webp': 'webp',
      'heic': 'jpeg',
      'heif': 'jpeg',
    };

    final mimeSubType = mimeTypes[fileExtension] ?? 'jpeg';

    final multipartFile = await MultipartFile.fromFile(
      preparedFilePath,
      contentType: DioMediaType('image', mimeSubType),
      filename:
          '${fileName ?? 'photo'}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
    );

    return multipartFile;
  }

  static Future<String> _prepareImageForUpload(String filePath) async {
    try {
      final sourceFile = File(filePath);
      if (!sourceFile.existsSync()) return filePath;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final targetPath = filePath.replaceAllMapped(
        RegExp(r'\.[^.]+$'),
        (_) => '_optimized_$timestamp.jpg',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        sourceFile.absolute.path,
        targetPath,
        quality: 80,
        minWidth: 1440,
        minHeight: 1440,
        format: CompressFormat.jpeg,
      );

      return compressedFile?.path ?? filePath;
    } catch (_) {
      return filePath;
    }
  }
}
