import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stayvers_agent/core/util/media/media_url.dart';

/// Network image with CDN normalization and disk caching.
class StayverseNetworkImage extends StatelessWidget {
  final String? url;
  final String? fallbackUrl;
  final String? assetFallback;
  final double? width;
  final double? height;
  final BoxFit fit;
  final int? cacheWidth;
  final int? cacheHeight;

  const StayverseNetworkImage({
    super.key,
    required this.url,
    this.fallbackUrl,
    this.assetFallback,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = MediaUrl.resolve(url) ?? MediaUrl.resolve(fallbackUrl);

    if (resolved == null || resolved.isEmpty) {
      return _placeholder();
    }

    return CachedNetworkImage(
      imageUrl: resolved,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, __) => _loadingPlaceholder(),
      errorWidget: (_, __, ___) {
        final fallback = MediaUrl.resolve(fallbackUrl);
        if (fallback != null && fallback != resolved) {
          return CachedNetworkImage(
            imageUrl: fallback,
            width: width,
            height: height,
            fit: fit,
            memCacheWidth: cacheWidth,
            memCacheHeight: cacheHeight,
            errorWidget: (_, __, ___) => _errorWidget(),
          );
        }
        if (assetFallback != null && assetFallback!.isNotEmpty) {
          return Image.asset(
            assetFallback!,
            width: width,
            height: height,
            fit: fit,
          );
        }
        return _errorWidget();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
    );
  }
}
