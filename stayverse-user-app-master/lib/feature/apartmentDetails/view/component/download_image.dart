import 'package:flutter/material.dart';
import 'package:stayverse/core/service/image_service.dart';

class DownloadImage extends StatefulWidget {
  final Future<String> Function() getImageUrl;

  const DownloadImage({
    super.key,
    required this.getImageUrl,
  });

  @override
  State<DownloadImage> createState() => _DownloadImageState();
}

class _DownloadImageState extends State<DownloadImage> {
  bool _isDownloading = false;

  Future<void> _handleDownload() async {
    setState(() => _isDownloading = true);

    try {
      final url = await widget.getImageUrl();
      if (url.isNotEmpty) {
        await ImageService.downloadImageToGallery(url);
      }
    } catch (_) {}

    setState(() => _isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 40,
      child: GestureDetector(
        onTap: _isDownloading ? null : _handleDownload,
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: _isDownloading
              ? const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(
                  Icons.download,
                  color: Colors.black,
                  size: 16,
                ),
        ),
      ),
    );
  }
}
