/// Resolves listing media URLs from the API (CDN, legacy bucket, or relative paths).
class MediaUrl {
  static const String defaultCdnBase =
      'https://stayversepro.sfo3.cdn.digitaloceanspaces.com';

  static String cdnBase = defaultCdnBase;

  static String? resolve(String? url) {
    if (url == null) return null;
    var value = url.trim();
    if (value.isEmpty) return null;

    if (value.contains('your_cdn_url')) {
      value = value.replaceAll(
        RegExp(r'https?://your_cdn_url/?', caseSensitive: false),
        cdnBase.endsWith('/') ? cdnBase : '$cdnBase/',
      );
    }

    if (value.contains('.digitaloceanspaces.com/') &&
        !value.contains('.cdn.digitaloceanspaces.com/')) {
      value = value.replaceFirst(
        '.digitaloceanspaces.com/',
        '.cdn.digitaloceanspaces.com/',
      );
    }

    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      final base = cdnBase.endsWith('/') ? cdnBase : '$cdnBase/';
      value = '$base${value.startsWith('/') ? value.substring(1) : value}';
    }

    return value;
  }
}
